//
//  UIImageView+Ext.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/25.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}
