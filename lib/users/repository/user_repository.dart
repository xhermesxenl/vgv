import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:vgv/users/model/user.dart';

class UserRepository {
  UserRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<User>> getUsers() async {
    final data = await _client
        .from('users')
        .select()
        .order('created_at', ascending: false);
    return data.map(User.fromJson).toList();
  }

  Future<User> addUser(User user) async {
    final data =
        await _client.from('users').insert(user.toJson()).select().single();
    return User.fromJson(data);
  }

  Future<User> updateUser(User user) async {
    final data = await _client
        .from('users')
        .update(user.toJson())
        .eq('id', user.id)
        .select()
        .single();
    return User.fromJson(data);
  }

  Future<void> deleteUser(String id) async {
    await _client.from('users').delete().eq('id', id);
  }
}
