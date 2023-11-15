/*
 * Copyright 2020-2023. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


enum AuthExceptionCode  {


  /// The AccessToken is empty. You are advised to log in again.
  nullToken(1),

  /// Obtaining AccessToken Information When You Have Not Logged In
  notSignIn(2),

  /// The user has been associated with the provider.
  userLinked(3),

  /// The user is not associated with the provider.
  userUnlinked(4),

  /// A user has logged in to the system and has logged in to the system without logout.
  alreadySignInUser(5),

  /// The email verification code is empty.
  emailVerificationIsEmpty(6),

  /// The phone verification code is empty.
  phoneVerificationIsEmpty(7),

  /// Alipay Error
  alipayAccountReturnError(115),

  /// Twitter Error
  twitterAccountReturnError(116),

  /// The email address is invalid.
  invalidEmail(0x0c260107),

  /// The entered mobile number is invalid.
  invalidPhone(0x0c260108),

  /// Failed to obtain the user ID.
  getUidError(0x0c260300),

  /// The user ID does not match the product ID.
  uidProductIDNotMatch(0x0c260301),

  /// Failed to obtain user information.
  getUserInfoError(0x0c260302),

  /// Currently, the Auth microservice is deployed at four sites. Each site supports different authentication modes.
  authMethodNotSupport(0x0c260304),

  /// The authentication service is not enabled for the product.
  productStatusError(0x0c260310),

  /// The number of password verification codes exceeds the upper limit.
  passwordVerificationCodeOverLimit(0x0c260353),

  /// The client token is unavailable.
  invalidToken(0x0c260400),

  /// The access token is unavailable.
  invalidAccessToken(0x0c260401),

  /// The refresh token is unavailable.
  invalidRefreshToken(0x0c260402),

  /// The token does not match the product ID.
  /// You are advised to check whether the agconnect-services file is consistent with the information applied for on the platform.
  tokenAndProductIdNotMatch(0x0c260403),

  /// Unsupported authentication mode
  /// You are advised to check whether the corresponding authentication mode is enabled on the platform, for example, whether Facebook login is enabled.
  authMethodIsDisabled(0x0c260404),

  /// Failed to obtain the third-party user information.
  failToGetThirdUserInfo(0x0c260405),

  /// Failed to obtain the third-party union ID.
  failToGetThirdUserUnionId(0x0c260406),

  /// The number of access tokens exceeds the limit.
  accessTokenOverLimit(0x0c260407),

  /// Failed to link the user.
  failToUserLink(0x0c260408),

  /// Failed to unlink the user.
  failToUserUnlink(0x0c260409),

  /// Anonymous user login exceeds the upper limit.
  anonymousSigninOverLimit(0x0c260423),

  /// The appid is unavailable.
  invalidAppID(0x0c260424),

  /// The app secret is unavailable.
  invalidAppSecret(0x0c260425),

  /// Failed to obtain the QQ third-party user information.
  getQQUserInfoError(0x0c260427),

  /// The returned value of QQInfo is null.
  qqInfoResponseIsNull(0x0c260428),

  /// The returned QQ UID is empty.
  getQQUidError(0x0c260429),

  /// Incorrect password or verification code.
  passwordVerifyCodeError(0x0c260430),

  /// The information returned by Google does not match the app ID.
  GoogleResponseNotEqualAppID(0x0c260431),

  /// The user is suspended by the CP.
  signInUserStatusError(0x0c260434),

  /// Incorrect user password.
  signInUserPasswordError(0x0c260435),

  /// The provider has been bound to another user.
  providerUserHaveBeenLinked(0x0c260436),

  /// The provider type has been bound to the account.
  providerHaveLinkedOneUser(0x0c260437),

  /// Failed to obtain the provider user.
  FailGetProviderUser(0x0c260438),

  /// The unlink operation cannot be performed on a single provider.
  CannotUnlinkOneProviderUser(0x0c260439),

  /// Send Verification Codes During Sending Interval
  verifyCodeIntervalLimit(0x0c260440),

  /// The verification code is empty.
  verifyCodeEmpty(0x0c260441),

  /// The verification code sending language is empty.
  verifyCodeLanguageEmpty(0x0c260442),

  /// The verification code receiver is empty.
  verifyCodeReceiverEmpty(0x0c260443),

  /// The verification code type is empty.
  verifyCodeActionError(0x0c260444),

  /// The number of times that the verification code is sent exceeds the upper limit. It is recommended to try in an hour
  verifyCodeTimeLimit(0x0c260445),

  /// The user name and password are the same.
  accountPasswordSame(0x0c260450),

  /// password strength too low
  passwordStrengthLow(0x0c260451),

  /// Failed to update the password.
  updatePasswordError(0x0c260452),

  /// The password is the same as the old password.
  passwordSameAsBefore(0x0c260453),

  /// The password is empty.
  passwordIsEmpty(0x0c260454),

  /// The password is too long.
  passwordTooLong(0x0c260457),

  /// The latest login time for sensitive operations times out.
  sensitiveOperationTimeout(0x0c260461),

  /// The account has been registered.
  accountHaveBeenRegistered(0x0c260462),

  /// Failed to update the account.
  updateAccountError(0x0c260464),

  /// The user is not registered.
  userNotRegistered(0x0c260467),

  /// Incorrect verification code.
  verifyCodeError(0x0c260491),

  /// The user has been registered.
  userHaveBeenRegistered(0x0c260492),

  /// The registered account is empty.
  registerAccountIsEmpty(0x0c260494),

  /// Incorrect verification code format.
  verifyCodeFormatError(0x0c260496),

  /// Both the verification code and password are empty.
  verifyCodeAndPasswordBothNull(0x0c260497),

  /// Failed to send the email.
  sendEmailFail(0x0c260500),

  /// 发送短信失败
  sendMessageFail(0x0c260501),

  /// Setting the maximum number of password/verification code attempts or freezing errors frequently occur.
  configLockTimeError(0x0c260515);

  const AuthExceptionCode(this.value);
  final num value;
}

class AGCAuthException implements Exception {
  AGCAuthException(this.code, int? exceptionCode, this.message) {
    if (exceptionCode != null &&
        exceptionCode >= 0 &&
        exceptionCode < AuthExceptionCode.values.length) {
      this.exceptionCode = AuthExceptionCode.values[exceptionCode];
    }
  }

  /// Error Code
  int? code;

  /// Error Code Enumeration
  AuthExceptionCode? exceptionCode;

  /// Error Description
  String? message;

  @override
  String toString() {
    return "AGCAuthException code: ${exceptionCode ?? code}, message: $message.";
  }
}
