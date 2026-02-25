import os
import re

def parse_dart_file(filepath):
    """
    Parses a Dart file for imported packages and class names.
    This is a simplistic parser tailored for this specific task.
    """
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return None

    with open(filepath, 'r') as f:
        content = f.read()

    return content

def generate_mermaid():
    base_path = "lib"
    main_file = "lib/main_development.dart"
    bootstrap_file = "lib/bootstrap.dart"
    app_file = "lib/app/view/app.dart"

    print("Generating Mermaid diagram...")

    # 1. Main Entry Point
    main_content = parse_dart_file(main_file)
    if not main_content:
        print(f"Could not read {main_file}")
        return

    bootstrap_call = "bootstrap" in main_content

    mermaid_content = "graph TD\n"
    mermaid_content += "    subgraph EntryPoint [Entry Point]\n"
    mermaid_content += "        Main[main_development.dart]\n"
    mermaid_content += "    end\n\n"

    # 2. Bootstrap Layer
    bootstrap_content = parse_dart_file(bootstrap_file)
    mermaid_content += "    subgraph BootstrapLayer [Bootstrap Layer]\n"
    mermaid_content += "        Bootstrap[bootstrap.dart]\n"

    if bootstrap_content:
        if "Supabase.initialize" in bootstrap_content:
            mermaid_content += "        SupabaseInit(Supabase.initialize)\n"
            mermaid_content += "        Bootstrap --> SupabaseInit\n"
        if "SecureStorageClient" in bootstrap_content:
            mermaid_content += "        StorageClient(SecureStorageClient)\n"
            mermaid_content += "        Bootstrap --> StorageClient\n"
        if "PreferencesClient" in bootstrap_content:
            mermaid_content += "        PrefsClient(PreferencesClient)\n"
            mermaid_content += "        Bootstrap --> PrefsClient\n"
        if "ConnectivityClient" in bootstrap_content:
            mermaid_content += "        ConnClient(ConnectivityClient)\n"
            mermaid_content += "        Bootstrap --> ConnClient\n"

    mermaid_content += "    end\n\n"
    mermaid_content += "    Main --> Bootstrap\n"

    # 3. App Widget Layer
    app_content = parse_dart_file(app_file)
    mermaid_content += "    subgraph AppLayer [App Widget Layer]\n"
    mermaid_content += "        AppWidget[App Widget]\n"

    if not app_content:
        print(f"Could not read {app_file}")
        return

    # Parse RepositoryProviders
    repos = re.findall(r'RepositoryProvider<([^>]+)>', app_content)
    # Deduplicate
    repos = sorted(list(set(repos)))

    repo_nodes = []
    for repo in repos:
        node_id = repo.replace(" ", "")
        repo_nodes.append(node_id)
        mermaid_content += f"        {node_id}[{repo}]\n"

    # Parse BlocProviders
    blocs = re.findall(r'BlocProvider<([^>]+)>', app_content)
    blocs = sorted(list(set(blocs)))

    bloc_nodes = []
    for bloc in blocs:
        node_id = bloc.replace(" ", "")
        bloc_nodes.append(node_id)
        mermaid_content += f"        {node_id}[{bloc}]\n"

    mermaid_content += "    end\n\n"

    mermaid_content += "    Bootstrap --> AppWidget\n"

    # Connect App to Repositories
    if repo_nodes:
        mermaid_content += "    AppWidget -->|Provides| Repositories((Repositories))\n"
        for node in repo_nodes:
             mermaid_content += f"    Repositories --> {node}\n"

    # Connect App to Blocs
    if bloc_nodes:
        mermaid_content += "    AppWidget -->|Provides| Blocs((Blocs))\n"
        for node in bloc_nodes:
             mermaid_content += f"    Blocs --> {node}\n"
             # If a Bloc depends on a Repository, we can try to infer it from the name (simplistic)
             # e.g., AuthBloc -> AuthRepository
             for repo in repo_nodes:
                 if repo.replace("Repository", "") in node.replace("Bloc", "").replace("Cubit", ""):
                     mermaid_content += f"    {node} -.-> {repo}\n"

    output_path = "docs/project_structure.mmd"
    with open(output_path, "w") as f:
        f.write(mermaid_content)

    print(f"Mermaid diagram generated at {output_path}")

if __name__ == "__main__":
    generate_mermaid()
