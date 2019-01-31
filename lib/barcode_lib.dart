import 'dart:async';

import 'package:barcode_lib/barcode_lib_viewmodel.dart';
import 'package:barcode_lib/barcode_manual_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class BarcodeLib extends StatefulWidget {
  static const MethodChannel _channel = const MethodChannel('barcode_lib');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  State<StatefulWidget> createState() => new _BarcodeLibState();
}

class _BarcodeLibState extends State<BarcodeLib> with WidgetsBindingObserver {
  bool camState = true;
  String qr;
  BarcodeLibViewModel viewModel;
  ProgressHUD _progressHUD;

  _BarcodeLibState() {
    viewModel = new BarcodeLibViewModel();
  }

  @override
  void initState() {
    super.initState();

    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Loading...',
    );
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _progressHUD.state.dismiss());

    viewModel.dialogShouldAppear.listen(_showInactivityDialog);
    viewModel.backendCheckResult.listen(_processResult);
    viewModel.networkRequestInProgress.listen(_showNetworkProgress);
    viewModel.startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = new AppBar(
      title: new Text(
        "Position the bar code within this box",
      ),
      elevation: 4.0,
    );
    BottomAppBar bottomAppBar = BottomAppBar(
      child: new FlatButton(
        padding: EdgeInsets.all(16.0),
        onPressed: _openScreen3,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("OR "),
            new Image(
              image: AssetImage('assets/barcode.png', package: 'barcode_lib'),
              width: 40,
              height: 40,
            ),
            Text(" Type in Bar Code"),
          ],
        ),
      ),
    );
    return new Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomAppBar,
      body: new Stack(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              camState
                  ? new Center(
                      child: new SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            96,
                        child: new QrCamera(
                          onError: (context, error) => Text(
                                error.toString(),
                                style: TextStyle(color: Colors.red),
                              ),
                          qrCodeCallback: (code) {
                            viewModel.stopTimer();
                            viewModel.checkCode(code);
                            setState(() {
                              camState = false;
                            });
                          },
                        ),
                      ),
                    )
                  : new Center(child: new Text("Camera inactive")),
            ],
          ),
          _progressHUD,
        ],
      ),
    );
  }

  void _openScreen3() async {
    viewModel.stopTimer();
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => BarcodeManualInputScreen()));
    viewModel.startTimer();
  }

  void _showInactivityDialog(bool event) async {
    setState(() {
      camState = false;
    });
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Inactivity"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Retry"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openScreen3();
                },
                child: new Text("Enter code manually"),
              ),
            ],
          );
        }).then((_) {
      setState(() {
        camState = true;
      });
      viewModel.startTimer();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("app lifecycle change");
    if (state.index == 0) {
      viewModel.startTimer();
    } else {
      viewModel.stopTimer();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _processResult(String result) {
    if (result != null) {
      _showResultDialog(result == null ? "" : result);
    }
  }

  void _showResultDialog(String message) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Result code:"),
            content: new Text(message),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Retry"),
                onPressed: () {
                  setState(() {
                    camState = true;
                  });
                  Navigator.of(context).pop();
                  viewModel.startTimer();
                },
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openScreen3();
                },
                child: new Text("Enter code manually"),
              ),
            ],
          );
        });
  }

  void _showNetworkProgress(bool networkIsActive) {
    if (networkIsActive != null) {
      if (networkIsActive) {
        _progressHUD.state.show();
      } else {
        _progressHUD.state.dismiss();
      }
    }
  }
}
