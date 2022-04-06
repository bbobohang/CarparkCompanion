// To parse this JSON data, do
//
//     final carpark = carparkFromJson(jsonString);

import 'dart:convert';

DGCarparkAvailability dgCarparkAvailabilityFromJson(String str) =>
    DGCarparkAvailability.fromJson(json.decode(str));

String dgCarparkAvailabilityToJson(DGCarparkAvailability data) =>
    json.encode(data.toJson());

class DGCarparkAvailability {
  DGCarparkAvailability({
    required this.items,
  });

  List<Item> items;

  factory DGCarparkAvailability.fromJson(Map<String, dynamic> json) =>
      DGCarparkAvailability(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.timestamp,
    required this.carparkData,
  });

  DateTime timestamp;
  List<CarparkDatum> carparkData;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        timestamp: DateTime.parse(json["timestamp"]),
        carparkData: List<CarparkDatum>.from(
            json["carpark_data"].map((x) => CarparkDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp.toIso8601String(),
        "carpark_data": List<dynamic>.from(carparkData.map((x) => x.toJson())),
      };
}

class CarparkDatum {
  CarparkDatum({
    required this.carparkInfo,
    required this.carparkNumber,
    required this.updateDatetime,
  });

  List<CarparkInfo> carparkInfo;
  String carparkNumber;
  DateTime updateDatetime;

  factory CarparkDatum.fromJson(Map<String, dynamic> json) => CarparkDatum(
        carparkInfo: List<CarparkInfo>.from(
            json["carpark_info"].map((x) => CarparkInfo.fromJson(x))),
        carparkNumber: json["carpark_number"],
        updateDatetime: DateTime.parse(json["update_datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "carpark_info": List<dynamic>.from(carparkInfo.map((x) => x.toJson())),
        "carpark_number": carparkNumber,
        "update_datetime": updateDatetime.toIso8601String(),
      };
}

class CarparkInfo {
  CarparkInfo({
    required this.totalLots,
    required this.lotType,
    required this.lotsAvailable,
  });

  int totalLots;
  String lotType;
  int lotsAvailable;

  factory CarparkInfo.fromJson(Map<String, dynamic> json) => CarparkInfo(
        totalLots: int.parse(json["total_lots"]),
        lotType: json["lot_type"],
        lotsAvailable: int.parse(json["lots_available"]),
      );

  Map<String, dynamic> toJson() => {
        "total_lots": totalLots,
        "lot_type": lotType,
        "lots_available": lotsAvailable,
      };
}
