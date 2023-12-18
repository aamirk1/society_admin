import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CircularNotice extends StatefulWidget {
  
  const CircularNotice({super.key});

  @override
  State<CircularNotice> createState() => _CircularNoticeState();
}

class _CircularNoticeState extends State<CircularNotice> {
  final date = DateFormat('dd-MM-yyyy ').format(DateTime.now());
  @override
  void initState() {
    print(date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Circular Notice'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addNotice');
              },
              icon: const Icon(Icons.add),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
            )
          ],
        ),
        body: Center(
          child: Text('Circular/Notice \n Module'),
        ));
  }
}
