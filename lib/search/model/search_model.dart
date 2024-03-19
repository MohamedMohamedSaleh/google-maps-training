class SearchModel {
  late List<Results> results;
  SearchModel.fromJson(Map<String, dynamic> json) {
    results = List.from(json['features'] ?? [])
        .map((e) => Results.fromJson(e))
        .toList();
  }
}

class Results {
  late num lat, lng;
  late String name, lable;
  Results.fromJson(Map<String, dynamic> json) {
    lat = json['geometry']['coordinates'][0];
    lng = json['geometry']['coordinates'][1];
    name = json['properties']['name'];
    lable = json['properties']['label'];
  }
}
