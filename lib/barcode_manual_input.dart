import 'package:barcode_lib/barcode_lib_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';

class BarcodeManualInputScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BarcodeManualInputScreenState();
}

class _BarcodeManualInputScreenState extends State<BarcodeManualInputScreen> {
  BarcodeLibViewModel viewModel;
  final myController = TextEditingController();
  ProgressHUD _progressHUD;

  _BarcodeManualInputScreenState() {
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

    viewModel.networkRequestInProgress.listen(_showNetworkProgress);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text("Type in Bar code"),
          elevation: 4.0,
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: myController,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    textAlign: TextAlign.center,
                  ),
                  new Text("You can type your bar code here"),
                  new FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(Icons.check),
                        new Text("Confirm"),
                      ],
                    ),
                  ),
                  new FlatButton(
                    onPressed: _back,
                    color: Colors.black,
                    textColor: Colors.white,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Icon(Icons.arrow_back_ios),
                          new Text("Back"),
                        ]),
                  ),
                ],
              ),
            ),
            _progressHUD,
          ],
        ),
      );

  void _back() {
    Navigator.pop(context);
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
