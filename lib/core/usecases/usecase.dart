import 'package:housely/core/utils/typedef.dart';

abstract interface class UseCase<T, Params> {
  ResultFuture<T> call(Params params);
}

abstract interface class UseCaseWithoutParams<T> {
  ResultFuture<T> call();
}

abstract interface class UseCaseWithStream<T> {
  ResultStream<T> call();
}

abstract interface class UseCaseStreamWithParam<T, Params> {
  ResultStream<T> call(Params param);
}
