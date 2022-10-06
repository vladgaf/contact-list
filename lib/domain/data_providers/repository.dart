import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task/domain/entities/contact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:test_task/domain/entities/contacts_list.dart';

int seed = Random().nextInt(100);

class Repository {
  final String url = "https://randomuser.me/api";

  Future<BaseResponse> generateContactList(int page, {int? count}) async {
    String link = '$url?page=$page&results=$count&seed=$seed';
    print(link);
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      //print(jsonResponse);
      BaseResponse contactList = BaseResponse.fromJson(jsonResponse);
      //print(contactList.contacts);
      return contactList;
    } else {
      throw Exception("Status Code Is Not 200");
    }
  }
}
