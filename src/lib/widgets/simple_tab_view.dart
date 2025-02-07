import 'package:flutter/material.dart';

class SimpleTabView extends StatefulWidget {
  const SimpleTabView(
      {Key? key,
      required this.itemCount,
      required this.tabBuilder,
      required this.pageBuilder,
      this.contentHeight})
      : super(key: key);
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final double? contentHeight;
  @override
  State<SimpleTabView> createState() => _SimpleTabViewState();
}

class _SimpleTabViewState extends State<SimpleTabView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: widget.itemCount, // length of tabs
        initialIndex: 0,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
              Container(
                height: 25,
                child: TabBar(
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black,
                  tabs: List.generate(
                    widget.itemCount,
                    (index) => widget.tabBuilder(context, index),
                  ),
                  // List.generate(
                  //   resultadosPDF.length,
                  //   (index) => Tab(
                  //     text: resultadosPDF[index].titulo,
                  //   ),
                  // ),
                ),
              ),
              Container(
                  height: widget.contentHeight ?? 400, //height of TabBarView
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey, width: 0.5))),
                  child: TabBarView(
                    children: List.generate(
                      widget.itemCount,
                      (index) => widget.pageBuilder(context, index),
                    ),
                    // List.generate(
                    //     resultadosPDF.length,
                    //     (index) => PdfViewer(
                    //           pathPDF: resultadosPDF[index].fileName,
                    //           titulo: resultadosPDF[index].titulo,
                    //         )),
                  ))
            ]));
  }
}
