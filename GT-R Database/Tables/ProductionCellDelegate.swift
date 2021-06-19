//
//  ProductionCellDelegate.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 14/12/20.
//

import Foundation
import UIKit

protocol ProductionCellDelegate {
    func didTapProductionCell(at point: CGPoint)
    func didTapTopHeaderCell(at point: CGPoint)
    func didTapLeftHeaderCell(at point: CGPoint)
}
