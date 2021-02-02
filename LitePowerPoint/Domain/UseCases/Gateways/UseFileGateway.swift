//
//  SaveToFileGateway.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 02.02.2021.
//

import Foundation
import PromiseKit

protocol UseFileGateway {
    func saveToFileGateway(_ filename: String) -> Promise<Void>
    func openFile(_ filename: String) -> Promise<[Shape]>
}
