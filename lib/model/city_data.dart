class CityData {
    String? lat;
    String? lon;
    String? displayName;

    CityData({
        this.lat,
        this.lon,
        this.displayName,
    });

    factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
    };
}