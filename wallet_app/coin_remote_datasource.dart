import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:starcoin/common/api_result.dart';
import 'package:starcoin/models/coin_model.dart';

class CoinRemoteDataSource {
  Dio dio;

  CoinRemoteDataSource(this.dio);

  Future<ApiResult<List<CoinModel>>> getCoinList() async {
    try {
      var raw = await dio.get("/wallet/coins");
      var response = BaseResponse.fromMap(raw.data);
      if (response.isSuccess) {
        var result = CoinModel.fromJson(raw.data);
        return ApiResult.success(result);
      } else
        return ApiResult.apiError(response.errors.first);
    } catch (error) {
      return ApiResult.networkError(error);
    }
  }

  Future<ApiResult> setFavoriteCoin(int coinId) async {
    try {
      Response raw = await dio.post(
        "/coins/set-favorite",
        data: {"id": coinId},
      );
      var response = BaseResponse.fromMap(raw.data);
      if (response.isSuccess) {
        return ApiResult.success(response.isSuccess);
      } else
        return ApiResult.apiError(response.errors.first);
    } catch (error) {
      return ApiResult.networkError(error);
    }
  }
}
