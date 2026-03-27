sealed class NetworkException implements Exception {
  const NetworkException();
}

class NoConnectivityException extends NetworkException {
  const NoConnectivityException();
}

class RequestTimeoutException extends NetworkException {
  const RequestTimeoutException();
}

/// HTTP 요청은 성공적으로 왕복했지만(응답 수신),
/// 서버가 실패 상태코드를 반환한 경우를 나타냅니다.
class HttpStatusException extends NetworkException {
  final int statusCode;

  const HttpStatusException(this.statusCode);
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException();
}

