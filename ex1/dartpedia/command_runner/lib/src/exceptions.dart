class ArgumentException extends FormatException {
  /// Lệnh đang được xử lý khi xảy ra lỗi.
  final String? command;

  /// Tên của đối số (argument) gây ra lỗi.
  final String? argumentName;

  ArgumentException(
    super.message, [
    this.command,
    this.argumentName,
    super.source,
    super.offset,
  ]);

  @override
  String toString() {
    return 'ArgumentException: $message';
  }
}