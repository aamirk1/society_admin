import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddNotice extends StatefulWidget {
  static const id = "/addNotice";
  AddNotice({super.key});

  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _uniqueController = TextEditingController();
  final TextEditingController societyNameController = TextEditingController();
  List<String> searchedList = [];
  @override
  void dispose() {
    _uniqueController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getUserdata('siddivision');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      child: Container(
                    padding: const EdgeInsets.all(8),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: societyNameController,
                          decoration: const InputDecoration(
                              labelText: 'Search Society',
                              border: OutlineInputBorder())),
                      suggestionsCallback: (pattern) async {
                        return await getUserdata(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.toString()),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        societyNameController.text = suggestion.toString();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => societyDetails(
                        //         societyNames: suggestion.toString()),
                        //   ),
                        // );
                      },
                    ),
                  )),
                ],
              ),
              Row(children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _uniqueController,
                      decoration: const InputDecoration(
                        labelText: 'Unique Id',
                      ),
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('society').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    print(searchedList.length);
    return searchedList;
  }
}
