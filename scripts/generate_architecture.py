import os
import re

def generate_architecture_diagram():
    root_dir = 'lib'
    output_file = 'docs/architecture_antigravity.md'

    classes = set()
    relationships = set()

    # Regex patterns
    class_pattern = re.compile(r'class\s+(\w+)(?:\s+extends\s+(\w+))?')

    # Specific types we care about
    interesting_suffixes = ['Bloc', 'Cubit', 'Repository', 'Page', 'App']

    files_content = {}

    # First pass: Identify all classes
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith('.dart'):
                filepath = os.path.join(dirpath, filename)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                    files_content[filepath] = content

                    matches = class_pattern.findall(content)
                    for match in matches:
                        class_name = match[0]

                        # Filter relevant classes
                        is_relevant = False
                        if class_name == 'App':
                            is_relevant = True
                        else:
                            for suffix in interesting_suffixes:
                                if class_name.endswith(suffix):
                                    is_relevant = True
                                    break

                        if is_relevant:
                            classes.add(class_name)

    # Second pass: Identify relationships
    for filepath, content in files_content.items():
        # Determine which class is defined in this file (simplification: assume one main class per file usually, or just check which of our known classes are present)
        # Actually, let's find the class defined in this file again
        matches = class_pattern.findall(content)
        current_classes = [m[0] for m in matches if m[0] in classes]

        for current_class in current_classes:
            # Look for usages of OTHER known classes in this file
            for other_class in classes:
                if other_class == current_class:
                    continue

                # Check if other_class is mentioned in the content (e.g. type annotation, constructor)
                # We use a simple regex to ensure it's a whole word
                if re.search(r'\b' + re.escape(other_class) + r'\b', content):
                    relationships.add(f"{current_class} --> {other_class}")

    # Generate Markdown
    # Ensure docs dir exists
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Architecture Antigravity\n\n")
        f.write("This document is automatically generated. It represents the current architecture of the application, focusing on the integration of key components.\n\n")
        f.write("```mermaid\n")
        f.write("classDiagram\n")

        for cls in sorted(list(classes)):
            f.write(f"  class {cls}\n")

        for rel in sorted(list(relationships)):
             f.write(f"  {rel}\n")

        f.write("```\n")

    print(f"Generated {output_file} with {len(classes)} classes and {len(relationships)} relationships.")

if __name__ == '__main__':
    generate_architecture_diagram()
