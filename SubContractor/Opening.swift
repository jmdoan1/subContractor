//
//  Opening.swift
//  SubContractor
//
//  Created by Justin Doan on 6/29/17.
//  Copyright © 2017 Justin Doan. All rights reserved.
//

import Foundation

struct Opening {
    var id: Int
    var contractor_id: Int
    var time: TimeInterval
    var title: String
    var description: String
    var type: String //.emplyment, .contract, .subContract
    var scope: String // .hours, .weeks, .months, .years
    var structure: String // .hourly, .fixed
    var rate: Double
    var showRate: Bool
    var open: Bool
}
