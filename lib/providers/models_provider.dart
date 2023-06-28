import 'package:flutter/material.dart';
import 'package:nanen_stot/models/models_model.dart';
import 'package:nanen_stot/services/api_services.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "gpt-3.5-turbo";
  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  // do not using but if you need
  List<ModelsModel> modelsList = [];
  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
