//
//  SubwaySearchSelectionViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/13.
//

import Foundation

protocol SubwaySearchDirectionSelectViewModelInput {
    func didSelectDirection(direction: UpDownDirection)
}

protocol SubwaySearchDirectionSelectViewModelOutput { }

protocol SubwaySearchDirectionSelectViewModel: SubwaySearchDirectionSelectViewModelInput,
                                               SubwaySearchDirectionSelectViewModelOutput { }

final class DefaultSubwaySearchDirectionSelectViewModel: SubwaySearchDirectionSelectViewModel {

    private let station: SubwayStation

    init(
        station: SubwayStation
    ) {
        self.station = station
    }

    deinit {
        print("🗑️ - \(String(describing: type(of: self)))")
    }

}

// MARK: - SubwaySearchDirectionSelectViewModelInput

extension DefaultSubwaySearchDirectionSelectViewModel {

    func didSelectDirection(direction: UpDownDirection) {

    }

}
