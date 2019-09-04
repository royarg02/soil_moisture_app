class Plant {
  String label = 'Plant';
  double moisture;
  double critMoisture = 0.35;
  double moreThanNormal = 0.75;
  String imgAsset = '';

  Plant(this.moisture);
  Plant.fromJson(Map<String, dynamic> data) {
    this.moisture = data['moisture'];
  }

  bool isCritical() => (this.moisture <= this.critMoisture);
  bool isMoreThanNormal() => (this.moisture >= this.moreThanNormal);
}

// * IDEA 101
// * Integrate crit, img defined in PlantCard here
