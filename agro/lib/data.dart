import 'dart:convert';

class Data {
  final String? timestamp;
  final int? mois;
  final double? temp;
  final double? humd;
  final int? motorstate;
  final int? index;

  const Data({
     this.index,
     this.timestamp,
     this.motorstate,
     this.mois,
     this.temp,
     this.humd,
  });

  factory Data.fromJson(Map<String, dynamic> json, int index) {

    List<String> dataArray = json["con"].toString()
        .replaceAll('[', '') // Remove leading [
        .replaceAll(']', '') // Remove trailing ]
        .split(',') // Split by comma
        .map((String element) => element.trim()) // Remove leading and trailing whitespace
        .toList();

    if (dataArray.length != 4)
      {
        return Data(index: 0, timestamp: json["ct"].toString(), motorstate: 0, humd: 0, temp: 0, mois: 0);
      }

    return Data(index: index, timestamp: json["ct"].toString(), motorstate: int.parse(dataArray[0]), mois: int.parse(dataArray[1]), temp: double.parse(dataArray[2]), humd: double.parse(dataArray[3]));

  //   return switch (json) {
  //     {
  //     'userId': int userId,
  //     'id': int id,
  //     'title': String title,
  //     } =>
  //         Album(
  //           userId: userId,
  //           id: id,
  //           title: title,
  //         ),
  //     _ => throw const FormatException('Failed to load album.'),
  //   };
  }
}