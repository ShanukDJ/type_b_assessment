import 'dart:async';

abstract class NetworkInfoService {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
  void dispose();
}

class NetworkInfoServiceImpl implements NetworkInfoService {
  final _controller = StreamController<bool>.broadcast();
  bool _isConnected = true;

  NetworkInfoServiceImpl({bool initialConnected = true})
    : _isConnected = initialConnected;

  @override
  Future<bool> get isConnected async => _isConnected;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  void setConnectivity(bool isConnected) {
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _controller.add(_isConnected);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
