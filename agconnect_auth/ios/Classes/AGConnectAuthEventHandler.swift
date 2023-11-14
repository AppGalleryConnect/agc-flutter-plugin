/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2021. All rights reserved.
 */

import Foundation
import AGConnectAuth

class AGConnectAuthEventHandler: NSObject, FlutterStreamHandler {

    private var _eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self._eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self._eventSink = nil
        return nil
    }

    @objc func  showData(_ tokenSnapshot: AGCTokenSnapshot) {
        guard let _eventSink = _eventSink else {
            return
        }
        _eventSink(FlutterUtils.tokenSnapshotToDic(tokenSnapshot: tokenSnapshot))
    }
}
