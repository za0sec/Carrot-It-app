import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteResponse({required this.status, required this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    var predictionsJson = json['predictions'] as List;
    List<AutocompletePrediction> predictions = predictionsJson != null
        ? predictionsJson
            .map((predictionJson) =>
                AutocompletePrediction.fromJson(predictionJson))
            .toList()
        : [];
    return PlaceAutocompleteResponse(
      status: json['status'],
      predictions: predictions,
    );
  }

  static PlaceAutocompleteResponse parseAutocompleteResponse(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}

class AutocompletePrediction {
  final String? description;
  final Map<String, dynamic>? structuredFormatting;
  final String? placeId;
  final String? reference;

  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeId,
    this.reference,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      structuredFormatting:
          json['structured_formatting'] as Map<String, dynamic>?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
    );
  }
}
