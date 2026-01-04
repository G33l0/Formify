class Education {
  final String degree;
  final String institution;
  final String startDate;
  final String endDate;
  final String? description;

  Education({
    required this.degree,
    required this.institution,
    required this.startDate,
    required this.endDate,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'degree': degree,
      'institution': institution,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      degree: map['degree'],
      institution: map['institution'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      description: map['description'],
    );
  }
}

class Experience {
  final String position;
  final String company;
  final String startDate;
  final String endDate;
  final String? description;

  Experience({
    required this.position,
    required this.company,
    required this.startDate,
    required this.endDate,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'position': position,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      position: map['position'],
      company: map['company'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      description: map['description'],
    );
  }
}

class Skill {
  final String name;
  final int level; // 1-5

  Skill({
    required this.name,
    this.level = 3,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      name: map['name'],
      level: map['level'] ?? 3,
    );
  }
}
