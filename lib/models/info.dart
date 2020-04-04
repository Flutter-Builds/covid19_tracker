import 'dart:convert';
import 'package:http/http.dart' as http;

String latestapi = 'https://corona.lmao.ninja/all';
String contapi = 'https://corona.lmao.ninja/countries';

class Info {
  String cases;
  String deaths;
  String recovered;
  String country;
  String todayCases;
  String todayDeaths;
  String active;
  String critical;
  String flag;

  Info({this.cases, this.deaths, this.recovered, this.country, 
  this.todayCases, this.todayDeaths, this.active, this.critical,
  this.flag});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      cases: json['cases'].toString(),
      deaths: json['deaths'].toString(),
      recovered: json['recovered'].toString(),
      country: json['country'].toString(),
      todayCases: json['todayCases'].toString(),
      todayDeaths: json['todayDeaths'].toString(),
      active: json['active'].toString(),
      critical: json['critical'].toString(),
      flag: json['countryInfo']['flag'].toString()
    );
  }
}

class Latest {
  int cases;
  int deaths;
  int active;
  int recovered;
  int affectedCountries;

  Latest({this.cases, this.deaths, 
  this.active, this.recovered, this.affectedCountries});

  Map<String, dynamic> toJson() => {
      'cases': cases,
      'deaths': deaths,
      'active' : active,
      'recovered': recovered,
    };

  factory Latest.fromJson(Map<String, dynamic> json) {
    return Latest(
      cases: json['cases'],
      deaths: json['deaths'],
      recovered: json['recovered'],
      active: json['active'],
      affectedCountries: json['affectedCountries']
    );
  }
}

List<String> countriess = new List<String>();
List<Info> info = new List<Info>();

Future<Latest> getLatest() async {
  final response = await http.get(latestapi);
  final responseJson = json.decode(response.body);
  return Latest.fromJson(responseJson);
}

Future<List<Info>> getInfo() async {
  final response = await http.get(contapi);

  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    if(responseJson.length>0){
      for(int i=0; i<responseJson.length; i++){
        if(responseJson[i] != null){
          Map<String,dynamic> map = responseJson[i];
          info.add(Info.fromJson(map));
        }
      }
    }
    return info;
  } else {
    throw Exception('Failed to load post');
  }
}

// Future<Latest> getInfo(Country country) async {
//   final response = await http.get(api+contAPi+country.code);
//   if (response.statusCode == 200) {
//     var responseJson = json.decode(response.body);
//     responseJson = responseJson['locations'];
//     if(responseJson.length>0){
//       for(int i=0; i<responseJson.length; i++){
//         if(responseJson[i] != null && responseJson['province'] == country.province){
//           Map<String,dynamic> map = responseJson[i];
//           countries.add(Country.fromJson(map));
//         }
//       }
//     }
//     return null;
//   } else {
//     throw Exception('Failed to load post');
//   }
// }