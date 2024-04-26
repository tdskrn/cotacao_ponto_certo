class ResponsePresentation {
  final bool success;
  final dynamic body;
  final String? message;

  ResponsePresentation({
    required this.success,
    required this.body,
    required this.message,
  });
}
