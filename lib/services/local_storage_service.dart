import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveLastConsultationDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    print('Enregistrement de la dernière consultation : $now');
    await prefs.setString('last_consultation_date', now.toIso8601String());
  }

  Future<DateTime?> getLastConsultationDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastConsultationDateString =
        prefs.getString('last_consultation_date');
    if (lastConsultationDateString != null) {
      return DateTime.parse(lastConsultationDateString);
    }
    return null;
  }
}
