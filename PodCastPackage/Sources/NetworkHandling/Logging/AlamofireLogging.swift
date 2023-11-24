//
//  File.swift
//  
//
//  Created by Naif Alrashed on 08/11/2022.
//

import Alamofire
import Pulse
import Foundation

public var loggingEventMonitor: EventMonitor {
    PulseLoggingForAlamofire(logger: logger)
}

fileprivate struct PulseLoggingForAlamofire: EventMonitor {
    let logger: NetworkLogger

    func request(_ request: Request, didCreateTask task: URLSessionTask) {
        logger.logTaskCreated(task)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        logger.logDataTask(dataTask, didReceive: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        logger.logTask(task, didFinishCollecting: metrics)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        logger.logTask(task, didCompleteWithError: error)
    }
}
