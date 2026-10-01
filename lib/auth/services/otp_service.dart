class OtpService {
  Future<bool> sendOtp(String phone) async {
    // OTP provider will be connected here.
    return true;
  }

  Future<bool> verifyOtp(
      String phone,
      String otp,
      ) async {
    // OTP verification will be connected here.
    return true;
  }
}