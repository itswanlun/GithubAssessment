//
//  Optional+Ext.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/26.
//

import Foundation

extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }
}
