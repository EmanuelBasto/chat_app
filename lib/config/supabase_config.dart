class SupabaseConfig {
  // ⚠️ IMPORTANTE: Reemplaza 'TU_ANON_KEY_AQUI' con tu anon key de Supabase
  // Puedes encontrarla en: Supabase Dashboard > Settings > API > anon/public key
  static const String supabaseUrl = 'https://lgtcqbjseztdlqxzfxbz.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxndGNxYmpzZXp0ZGxxeHpmeGJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ2MzY0MzIsImV4cCI6MjA4MDIxMjQzMn0.nMkkL722LUye4tYhb6bj38wJBQBmLCUsjKL_041-v1o';
  
  // Nombre del bucket donde se guardarán las fotos
  // ⚠️ IMPORTANTE: Debe coincidir exactamente con el nombre del bucket en Supabase
  static const String photosBucket = 'FOTOS';
}

