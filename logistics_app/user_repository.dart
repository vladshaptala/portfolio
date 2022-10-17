import 'package:logistics/datasources/user/user_local_datasource.dart';
import 'package:logistics/datasources/user/user_remote_datasource.dart';
import 'package:logistics/models/network/export.dart';
import 'package:logistics/models/user/driver.model.dart';
import 'package:logistics/repositories/file/file_repository.dart';
import 'package:logistics/utyls/connectivity.dart';

class UserRepository {
  static Future<DriverModel?> driverProfile() async {
    print('UserRepository: driver Profile...');
    if (Conection.connected) {
      return UserRemoteDatasource.driverProfile();
    } else {
      return UserLocalDatasource.driverProfile();
    }
  }

  static Future<AppResponse<bool?>> userDelete() async {
    print('UserRepository: userDelete...');
    return UserRemoteDatasource.userDelete();
  }

  static Future<AppResponse<bool?>> logout() async {
    print('UserRepository: logout...');
    return UserRemoteDatasource.logout();
  }

  static Future<AppResponse<bool?>> userSetPusherToken(String token) async {
    print('UserRepository: fcmTokenAdd...');
    return UserRemoteDatasource.userSetPusherToken(token);
  }
}
