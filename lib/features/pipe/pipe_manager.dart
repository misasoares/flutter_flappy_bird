import 'pipe_component.dart';

class PipePool {
  final List<Pipe> _availablePipes = [];

  Pipe acquire(bool isInverted, double height) {
    if (_availablePipes.isEmpty) {
      return Pipe(isInverted: isInverted, height: height);
    } else {
      final pipe = _availablePipes.removeLast();
      pipe.updateDimensions(isInverted, height);
      return pipe;
    }
  }

  void release(Pipe pipe) {
    // Reset position or other state if necessary
    _availablePipes.add(pipe);
  }
}

class PipeFactory {
  static final PipeFactory _instance = PipeFactory._internal();
  final PipePool _pool = PipePool();

  factory PipeFactory() {
    return _instance;
  }

  PipeFactory._internal();

  Pipe createPipe(bool isInverted, double height) {
    return _pool.acquire(isInverted, height);
  }

  void returnPipe(Pipe pipe) {
    _pool.release(pipe);
  }
}
