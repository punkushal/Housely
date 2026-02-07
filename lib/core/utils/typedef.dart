import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef ResultStream<T> = Stream<Either<Failure, T>>;
