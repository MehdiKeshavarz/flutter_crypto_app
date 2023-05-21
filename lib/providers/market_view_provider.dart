
import 'package:flutter/material.dart';
import 'package:flutter_application_crypto/data/data_source/api_provider.dart';
import 'package:flutter_application_crypto/data/data_source/response_model.dart';

import '../data/models/CryptoModel/AllCryptoModel.dart';

class MarketViewProvider extends ChangeNotifier{
  ApiProvider apiProvider = ApiProvider();

  late ResponseModel state;
  late AllCryptoModel dataFuture;

  var response ;

  getAllCryptoData()async {
    state = ResponseModel.loading("is Loading ...");

    try {
      response = await apiProvider.getAllCryptoData();
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