import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Read items with status 'today'
  Future<List<Map<String, dynamic>>> fetchTodayItems() async {
    final response = await supabase
        .from('todo')
        .select()
        .eq('status', 'today'); // Filter for 'today'
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  // Read items with status 'someday'
  Future<List<Map<String, dynamic>>> fetchSomedayItems() async {
    final response = await supabase
        .from('todo')
        .select()
        .eq('status', 'someday'); // Filter for 'someday'
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<bool> updateStatusJob(int id, String newStatus) async {
    await supabase
        .from('todo') // Nama tabel yang sesuai
        .update({'status_job': newStatus}) // Mengupdate status sesuai newStatus
        .eq('id', id);
    return true; // Update was successful, returning true
  }

  Future<bool> updateStatus(int id, String status) async {
    await supabase
        .from('todo') // Nama tabel yang sesuai
        .update({'status': status}) // Mengupdate status sesuai newStatus
        .eq('id', id);
        
    return true; // Update was successful, returning true
  }

   Future<void> addNote(String text) async {
    await supabase.from('todo').insert({'text': text});
  }

  Future<void> editNote(int id, String text) async {
    await supabase.from('todo').update({'text': text}).eq('id', id);
  }

   Future<void> deleteNote(int id) async {
    await supabase.from('todo').delete().eq('id', id);
  }


}
