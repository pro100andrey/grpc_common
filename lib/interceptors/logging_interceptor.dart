import 'package:grpc/grpc.dart';
import 'package:logging/logging.dart';

class LoggingInterceptor {
  LoggingInterceptor({
    required String name,
    this.headers = true,
    this.clientMetadata = true,
    this.trailers = true,
  }) : _logger = Logger(name);

  final Logger _logger;
  final bool headers;
  final bool clientMetadata;
  final bool trailers;

  Future<GrpcError?> call(
    ServiceCall call,
    ServiceMethod method,
  ) async {
    final msg = StringBuffer('method: ${method.name}\n');

    if (headers) {
      msg.add('headers:');
      call.headers?.forEach(msg.addKVShift);
    }

    if (clientMetadata) {
      msg.add('clientMetadata:');
      call.clientMetadata?.forEach(msg.addKVShift);
    }

    if (trailers) {
      msg.add('trailers:');
      call.trailers?.forEach(msg.addKVShift);
    }

    msg
      ..addKV('deadline', call.deadline)
      ..addKV('isTimedOut', call.isTimedOut);

    _logger.info(msg.toString());

    return null;
  }
}

extension _StringBufferExt on StringBuffer {
  void addKV(String key, Object? v) {
    writeln('$key: $v');
  }

  void addKVShift(String key, Object? v) {
    writeln('   $key: $v');
  }

  void add(Object? v) {
    writeln('$v');
  }
}
