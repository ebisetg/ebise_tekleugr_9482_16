class Volunteer {
  final String id;
  final String title;
  final String organization;
  final String description;
  final String location;
  final int numberOfVolunteers;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Volunteer({
    required this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.location,
    required this.numberOfVolunteers,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'] as String,
      title: json['title'] as String,
      organization: json['organization'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      numberOfVolunteers: json['numberOfVolunteers'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'organization': organization,
      'description': description,
      'location': location,
      'numberOfVolunteers': numberOfVolunteers,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Volunteer copyWith({
    String? id,
    String? title,
    String? organization,
    String? description,
    String? location,
    int? numberOfVolunteers,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Volunteer(
      id: id ?? this.id,
      title: title ?? this.title,
      organization: organization ?? this.organization,
      description: description ?? this.description,
      location: location ?? this.location,
      numberOfVolunteers: numberOfVolunteers ?? this.numberOfVolunteers,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}