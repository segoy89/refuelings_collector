import 'dart:convert';
import 'package:refuelings_collector/models/refueling.dart';

Refuelings refuelingsFromJson(String str) =>
    Refuelings.fromJson(json.decode(str));

class Refuelings {
  Refuelings({
    this.totalAvg,
    this.list,
  });

  double totalAvg;
  List<Refueling> list;

  factory Refuelings.fromJson(Map<String, dynamic> json) => Refuelings(
        totalAvg: json['total_avg'],
        list: List<Refueling>.from(
            json['refuelings'].map((x) => Refueling.fromJson(x))),
      );
}
