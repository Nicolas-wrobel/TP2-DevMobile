class FoundObject {
  final String category;
  final String description;
  final String station;
  final DateTime date;
  final DateTime? restitutionDate;

  FoundObject({
    required this.category,
    required this.description,
    required this.station,
    required this.date,
    this.restitutionDate,
  });

  factory FoundObject.fromJson(Map<String, dynamic> json) {
    return FoundObject(
      category: json['gc_obo_type_c'] ?? 'Catégorie inconnue',
      description: json['gc_obo_nature_c'] ?? 'Description non disponible',
      station: json['gc_obo_gare_origine_r_name'] ?? 'Gare inconnue',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      restitutionDate: json['gc_obo_date_heure_restitution_c'] != null
          ? DateTime.parse(json['gc_obo_date_heure_restitution_c'])
          : null,
    );
  }
}
