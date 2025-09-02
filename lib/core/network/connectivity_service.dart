import 'dart:async';

class ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  bool _online = true;
  Timer? _timer;

  ConnectivityService() {
    // Fallback stub: toggles to true every 5 seconds to trigger sync attempts
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setOnline(true);
    });
  }

  Stream<bool> get online$ => _controller.stream;

  void setOnline(bool online) {
    if (_online != online) {
      _online = online;
      _controller.add(_online);
    } else if (_online) {
      // push a heartbeat
      _controller.add(true);
    }
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
