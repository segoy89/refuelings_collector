class Refueling {
  Refueling({
    this.id,
    this.userId,
    this.liters = 0.00,
    this.cost = '',
    this.kilometers = 0.00,
    this.avgFuelConsumption = 0.00,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  double liters;
  String cost;
  double kilometers;
  double avgFuelConsumption;
  String note;
  DateTime createdAt;
  DateTime updatedAt;

  factory Refueling.fromJson(Map<String, dynamic> json) => Refueling(
        id: json['id'],
        userId: json['user_id'],
        liters: json['liters'].toDouble(),
        cost: json['cost'],
        kilometers: json['kilometers'].toDouble(),
        avgFuelConsumption: json['avg_fuel_consumption'].toDouble(),
        note: json['note'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'refueling': {
          'liters': liters,
          'cost': cost,
          'kilometers': kilometers,
          'note': note,
        }
      };
}
