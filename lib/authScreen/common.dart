import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const Color primaryColor = Color.fromARGB(255, 49, 80, 255);
const Color white = Colors.white;
const Color textColor = Colors.black;

const buttonColor = Color.fromARGB(255, 3, 38, 240);
const buttonTextColor = Color.fromARGB(255, 255, 255, 255);
const lightBlueColor = Colors.lightBlueAccent;
const blueColor = Colors.blueAccent;

Future<void> sendNotification(String token, String title, String body) async {
    final url = Uri.parse('http://localhost:3000/not');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'title': title,
          'message': body,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Notification sent successfully: ${response.body}');
      } else {
        // Handle error response
        print('Failed to send notification: ${response.body}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }


  Future<void> sendNoticeNotification(List<String> token, String title, String body) async {
    final url = Uri.parse('http://localhost:3000/not');
    for (var element in token) {
      try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        
        body: json.encode({
          'token': element,
          'title': title,
          'message': body,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Notification sent successfully: ${response.body}');
      } else {
        // Handle error response
        print('Failed to send notification: ${response.body}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
    }

    
  }
