//
//  NetworkingMonitoringService.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import Foundation
import Network
import OSLog

private let logger = Logger(subsystem: "PromovaTestProject", category: "NetworkMonitoringService")

final class NetworkMonitoringService {

    var isNetworkAvailable: Bool = true

    private var lastPath: String?
    private var status: NWPath.Status = .satisfied

    init() {
        let monitor = NWPathMonitor()

        let pathUpdateHandler = { [weak self] (path:NWPath) in
            let availableInterfaces = path.availableInterfaces

            if !availableInterfaces.isEmpty {
                let _ = availableInterfaces.map { $0.debugDescription }.joined(separator: "\n")
            }

            guard self?.status != path.status else {
                return
            }

            self?.status = path.status

            switch path.status {
            case .requiresConnection:
                self?.lastPath = "requires connection"
            case .satisfied:
                DispatchQueue.main.async {
                    self?.isNetworkAvailable = true
                }
                self?.lastPath = "satisfied"
            case .unsatisfied where self?.lastPath != "requires connection":
                DispatchQueue.main.async {
                    self?.isNetworkAvailable = false
                }
                self?.lastPath = "unsatisfied"
                logger.error("Check Connection unsatisfied")
            default:
                break
            }
        }

        monitor.pathUpdateHandler = pathUpdateHandler

        let queue = DispatchQueue.init(label: "monitor queue", qos: .userInitiated)

        monitor.start(queue: queue)
    }
}
