import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_admin/Provider/nocManagementProvider.dart';

int globalSelectedIndex = 0;

class TypeOfNoc extends StatefulWidget {
  TypeOfNoc(
      {super.key,
      required this.nocTypeList,
      required this.society,
      required this.flatNo,
      required this.userId});
  List<dynamic> nocTypeList;
  String society;
  String flatNo;
  String userId;

  @override
  State<TypeOfNoc> createState() => _TypeOfNocState();
}

class _TypeOfNocState extends State<TypeOfNoc> {
  // bool isLoading = true;

  @override
  void initState() {
    // getTypeOfNoc(widget.society, widget.flatNo);
    super.initState();
  }

  List<dynamic> colors = [
    const Color.fromARGB(255, 233, 87, 76),
    const Color.fromARGB(255, 102, 174, 233),
    const Color.fromARGB(255, 7, 141, 12),
    const Color.fromARGB(255, 216, 109, 235),
    const Color.fromARGB(255, 243, 103, 150),
    const Color.fromARGB(255, 167, 92, 49),
    const Color.fromARGB(255, 23, 48, 163),
    const Color.fromARGB(255, 82, 72, 212),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.nocTypeList.length,
          itemBuilder: (context, index) {
            return Card(
              color: colors[index % colors.length],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  minVerticalPadding: 0.3,
                  title: Text(
                    widget.nocTypeList[index]['nocType'],
                    style: TextStyle(color: Colors.white),
                  ),
                  // subtitle: Text(data.docs[index]['city']),
                  onTap: () {
                    globalSelectedIndex = index;
                    print('globalIndex - ${globalSelectedIndex}');
                    final provider = Provider.of<NocManagementProvider>(context,
                        listen: false);
                    provider.setLoadWidget(true); // NocManagementProvider();
                  },
                ),
              ),
            );
          },
        ),
      ]),
    ));
  }

  
}
