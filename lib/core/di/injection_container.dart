import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

void initDependencies() {
  sl.registerLazySingleton(() => Supabase.instance.client);
}
