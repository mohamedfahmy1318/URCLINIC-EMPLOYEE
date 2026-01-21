import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

GetStorage localStorage = GetStorage();

void setValueToLocal(String key, dynamic value) {
  localStorage.write(key, value);
}

T getValueFromLocal<T>(String key) {
  final val = localStorage.read(key);
  return val;
}

void removeValueFromLocal(String key) {
  localStorage.remove(key);
}

/// Returns a Bool if exists in SharedPref
bool getBoolAsync(String key, {bool defaultValue = false}) {
  return sharedPreferences.getBool(key) ?? defaultValue;
}
