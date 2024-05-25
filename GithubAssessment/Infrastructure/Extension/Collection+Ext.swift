//
//  Collection+Ext.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/25.
//

import Foundation

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
