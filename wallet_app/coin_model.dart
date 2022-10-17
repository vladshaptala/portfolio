import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:starcoin/models/transaction_model.dart';

class CoinModel {
  final String name;
  final String description;
  final bool isFavorite;
  final String address;
  final int balance;
  final List<TransactionModel> transactions;
  
  CoinModel({
    required this.name,
    required this.description,
    this.isFavorite = false,
    required this.address,
    required this.balance,
    required this.transactions,
  });

  CoinModel copyWith({
    String? name,
    String? description,
    bool? isFavorite,
    String? address,
    int? balance,
    List<TransactionModel>? transactions,
  }) {
    return CoinModel(
      name: name ?? this.name,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      address: address ?? this.address,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'description': description});
    result.addAll({'isFavorite': isFavorite});
    result.addAll({'address': address});
    result.addAll({'balance': balance});
    result
        .addAll({'transactions': transactions.map((x) => x.toMap()).toList()});

    return result;
  }

  factory CoinModel.fromMap(Map<String, dynamic> map) {
    return CoinModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      address: map['address'] ?? '',
      balance: map['balance']?.toInt() ?? 0,
      transactions: List<TransactionModel>.from(
          map['transactions']?.map((x) => TransactionModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CoinModel.fromJson(String source) =>
      CoinModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CoinModel(name: $name, description: $description, isFavorite: $isFavorite, address: $address, balance: $balance, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoinModel &&
        other.name == name &&
        other.description == description &&
        other.isFavorite == isFavorite &&
        other.address == address &&
        other.balance == balance &&
        listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        isFavorite.hashCode ^
        address.hashCode ^
        balance.hashCode ^
        transactions.hashCode;
  }
}
