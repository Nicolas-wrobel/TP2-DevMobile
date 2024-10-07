import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/found_object.dart';

class ApiService {
  int currentPage = 0;
  int itemsPerPage = 20;

  Future<List<FoundObject>> fetchFoundObjects() async {
    final response = await http.get(Uri.parse(
        'https://data.sncf.com/api/records/1.0/search/?dataset=objets-trouves-restitution&rows=$itemsPerPage&start=${currentPage * itemsPerPage}&sort=date'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['records'];
      return data.map((item) => FoundObject.fromJson(item['fields'])).toList();
    } else {
      print('Failed to load found objects: ${response.body}');
      throw Exception('Failed to load found objects');
    }
  }

  Future<List<FoundObject>> fetchMoreFoundObjects() async {
    currentPage++;
    final response = await http.get(Uri.parse(
        'https://data.sncf.com/api/records/1.0/search/?dataset=objets-trouves-restitution&rows=$itemsPerPage&start=${currentPage * itemsPerPage}&sort=date'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['records'];
      return data.map((item) => FoundObject.fromJson(item['fields'])).toList();
    } else {
      print('Failed to load more found objects: ${response.body}');
      throw Exception('Failed to load more found objects');
    }
  }

  Future<List<FoundObject>> fetchObjectsByDate(DateTime date) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await http.get(Uri.parse(
        'https://data.sncf.com/api/records/1.0/search/?dataset=objets-trouves-restitution'
        '&rows=$itemsPerPage'
        '&start=${currentPage * itemsPerPage}'
        '&sort=date'
        '&refine.date=$formattedDate'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['records'];
      return data.map((item) => FoundObject.fromJson(item['fields'])).toList();
    } else {
      throw Exception('Failed to load objects for the selected date');
    }
  }

  // Nouvelle méthode pour le scroll infini lors de la recherche par date
  Future<List<FoundObject>> fetchMoreObjectsByDate(DateTime date) async {
    currentPage++; // On continue de paginer les résultats
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await http.get(Uri.parse(
        'https://data.sncf.com/api/records/1.0/search/?dataset=objets-trouves-restitution'
        '&rows=$itemsPerPage'
        '&start=${currentPage * itemsPerPage}'
        '&sort=date'
        '&refine.date=$formattedDate'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['records'];
      return data.map((item) => FoundObject.fromJson(item['fields'])).toList();
    } else {
      throw Exception('Failed to load more objects for the selected date');
    }
  }
}
