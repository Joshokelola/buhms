import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Failed extends Equatable {
  Failed({
    required this.code,
    required this.message,
  });
  Object? code;
  String message;

  @override
  List<Object?> get props => [
        code,
        message,
      ];
}
