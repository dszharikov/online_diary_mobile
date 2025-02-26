// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class NetworkFailure extends Failure {}

class ServerDeclineFailure extends Failure {}

class CacheFailure extends Failure {}
