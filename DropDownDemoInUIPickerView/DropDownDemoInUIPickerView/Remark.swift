//
//  Remark.swift
//  DropDownDemoInUIPickerView
//
//  Created by Mac on 31/08/23.
//


import Foundation
struct Remark: Codable {
    let id: Int
    let remark: String
    let status: Int
}

struct APIResponse: Codable {
    let status: String
    let data: [Remark]
    let message: String
}

