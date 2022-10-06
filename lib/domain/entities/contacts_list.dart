import 'package:flutter/cupertino.dart';
import 'package:test_task/domain/entities/contact.dart';

class BaseResponse {
  final List<Contact> contacts;
  final String? seed;
  final int? page;
  final int? count;

  BaseResponse({required this.contacts, this.seed, this.page, this.count});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>;
    return BaseResponse(
      contacts: results.map((e) => Contact.fromJson(e)).toList(),
      seed: info['seed'],
      page: info['page'],
      count: info['results'],
    );
  }
}
