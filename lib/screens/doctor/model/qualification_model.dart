import 'package:flutter/material.dart';

class QualificationModel {
  int index;
  TextEditingController degreeCont;
  TextEditingController universityCont;
  TextEditingController yearCont;
  FocusNode degreeFocus;
  FocusNode universityFocus;
  FocusNode yearFocus;

  QualificationModel({
    required this.index,
    required this.degreeCont,
    required this.universityCont,
    required this.yearCont,
    required this.degreeFocus,
    required this.universityFocus,
    required this.yearFocus,
  });

  Map<String, dynamic> toJson() {
    return {
      "index": index,
      "degree": degreeCont.text.trim(),
      "university": universityCont.text.trim(),
      "year": yearCont.text.trim(),
    };
  }
}

class Qualifications {
  int id;
  int doctorId;
  String degree;
  String university;
  String year;
  int status;

  Qualifications({
    this.id = -1,
    this.doctorId = -1,
    this.degree = "",
    this.university = "",
    this.year = "",
    this.status = -1,
  });

  factory Qualifications.fromJson(Map<String, dynamic> json) {
    return Qualifications(
      id: json['id'] is int ? json['id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      degree: json['degree'] is String ? json['degree'] : "",
      university: json['university'] is String ? json['university'] : "",
      year: json['year'] is String ? json['year'] : "",
      status: json['status'] is int ? json['status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'degree': degree,
      'university': university,
      'year': year,
      'status': status,
    };
  }
}
