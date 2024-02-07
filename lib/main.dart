import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'dart:async';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sunmi Printer',
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  void initState() {
    super.initState();
    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });
      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });
      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });
      setState(() {
        printBinded = isBind!;
      });
    });
  }
  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('MMIT Invoice'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await SunmiPrinter.initPrinter();
                          await SunmiPrinter.startTransactionPrint(true);
                          await SunmiPrinter.setAlignment(
                              SunmiPrintAlign.CENTER);
                          await SunmiPrinter.line();
                          await SunmiPrinter.printText('Payment receipt');
                          await SunmiPrinter.line();
                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'Name',
                                width: 12,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: 'Qty',
                                width: 6,
                                align: SunmiPrintAlign.CENTER),
                            ColumnMaker(
                                text: 'price',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                          ]);

                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'MMit softer',
                                width: 12,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: '10',
                                width: 6,
                                align: SunmiPrintAlign.CENTER),
                            ColumnMaker(
                                text: '50000',
                                width: 6,
                                align: SunmiPrintAlign.RIGHT),
                          ]);

                          await SunmiPrinter.line();
                          await SunmiPrinter.printRow(cols: [
                            ColumnMaker(
                                text: 'TOTAL',
                                width: 25,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: 'BDT : 5000.00',
                                width: 5,
                                align: SunmiPrintAlign.RIGHT),
                          ]);
                        },

                        child: const Text('Invoice')),
                  ]),
            ),

          ],
        ));
  }
}

Future<Uint8List> readFileBytes(String path) async {
  ByteData fileData = await rootBundle.load(path);
  Uint8List fileUnit8List = fileData.buffer
      .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
  return fileUnit8List;
}
