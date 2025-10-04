//
//  NetworkMonitor.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import Combine
import Network

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published private(set) var isConnected: Bool = false
    
    private init() {
        let path = monitor.currentPath
        self.isConnected = path.status == .satisfied
        
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
