//
//  UseFileGatewayImpl.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 02.02.2021.
//

import Foundation
import PromiseKit

class UseFileGatewayImpl {
    private let fileManager: FileManager
//    private let tempDirectory = NSTemporaryDirectory()
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
//        self.tempDirectory = tempDirectory
    }
    
}

extension UseFileGatewayImpl: UseFileGateway {
    func saveToFileGateway(_ filename: String) -> Promise<Void> {
        .value(())
    }
    
    func openFile(_ filename: String) -> Promise<[Shape]> {
//        return firstly {
//
//        }.remove { error in
//
//        }.done { response in
//
//        }
        .value([])
    }
    
    
}
