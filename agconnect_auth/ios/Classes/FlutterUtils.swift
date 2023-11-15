/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

import Foundation
import AGConnectAuth
class FlutterUtils {

  static func verifyCodeToDic(result: AGCVerifyCodeResult?) -> [String: String] {
    var map: [String: String] = [String: String]()
    map["shortestInterval"] = result?.shortestInterval
    map["validityPeriod"] =  result?.validityPeriod
    return map
  }

  static func userToDic(user: AGCUser?) -> [String: Any] {
    var map: [String: Any] = [String: Any]()
    map["displayName"] = user?.displayName
    map["emailVerified"] = user?.emailVerified
    map["email"] = user?.email
    map["isAnonymous"] = user?.isAnonymous
    map["passwordSetted"] = user?.passwordSetted
    map["phoneNumber"] = user?.phone
    map["photoUrl"] = user?.photoUrl
    map["providerId"] = user?.providerId.rawValue
    map["uid"] = user?.uid
    map["providerInfo"] = user?.providerInfo
    return map
  }

  static func tokenToDic(token: AGCToken?) -> [String: Any] {
    var map: [String: Any] = [String: Any]()
    map["token"] = token?.tokenString
    map["expirePeriod"] = token?.expiration
    return map
  }

  static func tokenSnapshotToDic(tokenSnapshot: AGCTokenSnapshot?) -> [String: Any] {
    var map: [String: Any] = [String: Any]()
    map["state"] = tokenSnapshot?.state.rawValue
    map["token"] = tokenSnapshot?.token
    return map
  }

  static func userExtraToDic(userExtra: AGCUserExtra?) -> [String: Any] {
    var map: [String: Any] = [String: Any]()
    map["createTime"] = userExtra?.createTime
    map["lastSignInTime"] = userExtra?.lastSignInTime
    return map
  }

}
