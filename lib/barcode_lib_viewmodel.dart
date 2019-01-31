import 'dart:async';

class BarcodeLibViewModel {
  static const interval = Duration(seconds: 30);

  Timer _timer;
  StreamController<bool> _timerFinished;
  StreamController<bool> _networkRequestInProgress;
  StreamController<String> _backendCheck;

  BarcodeLibViewModel() {
    _timerFinished = new StreamController();
    _backendCheck = new StreamController();
    _networkRequestInProgress = new StreamController();
  }

  Stream<bool> get dialogShouldAppear => _timerFinished.stream;
  Stream<String> get backendCheckResult => _backendCheck.stream;
  Stream<bool> get networkRequestInProgress => _networkRequestInProgress.stream;

  void _tick() {
    _timerFinished.add(true);
  }

  void startTimer() {
    stopTimer();
    print("starting timer");
    _timer = Timer(interval, _tick);
    print("success");
  }

  void stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void checkCode(String code) {
    _backendCheck.add(code);
  }

  /*Future<http.Response> postRequest(String str) async {
    var url = 'http://192.168.88.110:4567/barcodeLookup';
    var body = jsonEncode({'barcodeNum': str});

    print("Body: " + body);
    http
        .post(url, headers: {"Content-Type": "application/json"}, body: body)
        .then((http.Response response) {
      if (response.statusCode == 200) {
        if (response.body.contains("ok")) {
          _backendCheck.add("ok");
        } else {
          _backendCheck.add("Bad barcode, try again");
        }
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.contentLength}");
        print(response.headers);
        print(response
            .body); //{"result":{"message":"Bad barcode, try again","failed":true}}
      }
      _networkRequestInProgress.add(false);
    });
  }*/
}
