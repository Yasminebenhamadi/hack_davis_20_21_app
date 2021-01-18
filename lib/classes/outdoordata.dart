class OutdoorData {
  final int id;
  final String content;
  final int covidCases;
  final int covidTests;
  final String weather;
  final int temp;

  OutdoorData(
      {this.id,
      this.content,
      this.covidCases,
      this.covidTests,
      this.weather,
      this.temp});

  factory OutdoorData.fromJson(Map<String, dynamic> json) {
    return OutdoorData(
      id: json['id'],
      content: json['content'],
      covidCases: json['covidCases'],
      covidTests: json['covidTests'],
      weather: json['weather'],
      temp: json['temp'],
    );
  }
}
