class EmployeeRecord {
  String? id;
  String? name;
  String? department;
  int? tenure;
  List<String?>? skills;

  EmployeeRecord(
      {this.id, this.name, this.department, this.tenure, this.skills});

  EmployeeRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    department = json['department'];
    tenure = json['tenure'];
    if (json['skills'] != null) {
      skills = List<String?>.from(
          json['skills'].map((dynamic skill) => skill as String?));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['department'] = department;
    data['tenure'] = tenure;
    if (skills != null) {
      data['skills'] = skills!.toList();
    } else {
      data['skills'] = null;
    }
    return data;
  }
}
