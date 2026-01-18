import '../models/converter.model.dart';

class ConverterController {
  final ConverterModel model;

  // 1 km = 0.621371 mi
  static const double _kmToMilesFactor = 0.621371;

  ConverterController(this.model);

  void updateKilometers(String value) {
    model.kilometers = double.tryParse(value) ?? 0;
  }

  void convertKmToMiles() {
    model.error = null;
    model.miles = model.kilometers * _kmToMilesFactor;
  }

  String getMilesText({int decimals = 4}) {
    if (model.error != null) return model.error!;
    return model.miles.toStringAsFixed(decimals);
  }
}
