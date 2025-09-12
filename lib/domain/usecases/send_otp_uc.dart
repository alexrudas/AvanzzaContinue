import 'package:avanzza/domain/repositories/auth_repository.dart';

class SendOtpUC {
  final AuthRepository repo;
  SendOtpUC(this.repo);
  Future<SendOtpResult> call(String phone) => repo.sendOtp(phone);
}
