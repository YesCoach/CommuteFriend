//
//  BaseInOutViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/10.
//

import Foundation

protocol BaseInOutViewModel {
    associatedtype Input
    associatedtype Output

    func transform(from input: Input) -> Output
}
