import 'package:flore/common/widget/random-color-block.dart';
import 'package:flutter/material.dart';

class TableDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyTable();
  }
}

class MyTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Table(
          border: TableBorder.all(color: Colors.black, width: 1),
          children: [
            TableRow(children: [Text("d"), Text("d")]),
            TableRow(children: [Text("d"), Text("d")]),
          ],
        ),
      ),
    );
  }
}
