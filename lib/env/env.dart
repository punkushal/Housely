import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'SERVER_CLIENT_ID', obfuscate: true)
  static final String googleServerClientId = _Env.googleServerClientId;

  @EnviedField(varName: 'APP_WRITE_PROJECT_ID', obfuscate: true)
  static final String appWriteProjectId = _Env.appWriteProjectId;

  @EnviedField(varName: 'APP_WRITE_BUCKET_ID', obfuscate: true)
  static final String appWriteBucketId = _Env.appWriteBucketId;

  @EnviedField(varName: 'ESEWA_CLIENT_ID', obfuscate: true)
  static final String esewaClientId = _Env.esewaClientId;

  @EnviedField(varName: 'ESEWA_SECRET_KEY', obfuscate: true)
  static final String esewaSecretKey = _Env.esewaSecretKey;

  @EnviedField(varName: 'SECRET_KEY', obfuscate: true)
  static final String secretKey = _Env.secretKey;
}
