import 'package:flutter/material.dart';
import 'package:flutter_application_crypto/data/data_source/api_provider.dart';
import 'package:flutter_application_crypto/data/data_source/response_model.dart';
import 'package:flutter_application_crypto/data/models/CryptoModel/AllCryptoModel.dart';

class CryptoDataProvider extends ChangeNotifier {
  ApiProvider apiProvider = ApiProvider();

  late AllCryptoModel dataFuture;
  late ResponseModel state;
  var response;

  getTopMarketCapData() async {
    state = ResponseModel.loading('is Loading...');

    try {
      response = await apiProvider.getTopMarketCapData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.completed(dataFuture);
      } else {
        state = ResponseModel.error('something wrong...');
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error("Please check your connection");
      notifyListeners();
    }
  }

  getTopGainersData() async {
    state = ResponseModel.loading('is Loading...');

    try {
      response = await apiProvider.getTopGainersData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.completed(dataFuture);
      } else {
        state = ResponseModel.error('something wrong...');
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error("Please check your connection");
      notifyListeners();
    }
  }

  getTopLosersData() async {
    state = ResponseModel.loading('is Loading...');

    try {
      response = await apiProvider.getTopLosersData();
      if (response.statusCode == 200) {
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.completed(dataFuture);
      } else {
        state = ResponseModel.error('something wrong...');
      }
      notifyListeners();
    } catch (e) {
      state = ResponseModel.error("Please check your connection");
      notifyListeners();
    }
  }
}
