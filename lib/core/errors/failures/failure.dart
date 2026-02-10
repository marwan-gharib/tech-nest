interface class Failure {
  final List<String> messages;

  const Failure({required this.messages});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.messages});
}
