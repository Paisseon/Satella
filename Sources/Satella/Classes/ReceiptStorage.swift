//
//  File.swift
//  
//
//  Created by Lilliana on 27/12/2022.
//

final class ReceiptStorage {
    static let shared: ReceiptStorage = .init()
    var currentProductID: String = "a.little.bit.of.satella.in.my.life"
    
    private init() {}
}
