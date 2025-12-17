import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';

typedef ResultFuture<T> = Either<Failure, T>;
typedef ResultVoid = ResultFuture<void>;
