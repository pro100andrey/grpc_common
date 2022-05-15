import 'package:grpc/grpc.dart';

extension LimitInterceptor on Interceptor {
  Interceptor limitTo(Set<String> endpoints) => (call, method) {
        // Skip the check if we don't care about the method.
        if (!endpoints.contains(method.name)) {
          return null;
        }
        // Invoke the regular interceptor otherwise
        return this(call, method);
      };
}
