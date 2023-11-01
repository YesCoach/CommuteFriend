//
//  SubwaySearchSelectionViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/13.
//

import Foundation
import RxSwift
import RxRelay

protocol SubwaySearchSelectionViewModelInput {
    func didSelectDirection(direction: UpDownDirection, stationName: String)
    func viewDidLoad()
}

protocol SubwaySearchSelectionViewModelOutput {
    var station: SubwayStation { get }
    var upStation: BehaviorRelay<SubwayStation?> { get }
    var downStation: BehaviorRelay<SubwayStation?> { get }
    var splitStation: BehaviorRelay<SubwayStation?> { get }
}

protocol SubwaySearchSelectionViewModel: SubwaySearchSelectionViewModelInput,
                                               SubwaySearchSelectionViewModelOutput { }

final class DefaultSubwaySearchSelectionViewModel: SubwaySearchSelectionViewModel {

    let station: SubwayStation
    private let localSubwayRepository: LocalSubwayRepository

    init(
        station: SubwayStation,
        localSubwayRepository: LocalSubwayRepository
    ) {
        self.station = station
        self.localSubwayRepository = localSubwayRepository
    }

    deinit {
        print("🗑️ - \(String(describing: type(of: self)))")
    }

    var upStation: BehaviorRelay<SubwayStation?> = BehaviorRelay(value: nil)
    var downStation: BehaviorRelay<SubwayStation?> = BehaviorRelay(value: nil)
    var splitStation: BehaviorRelay<SubwayStation?> = BehaviorRelay(value: nil)

}

// MARK: - SubwaySearchDirectionSelectViewModelInput

extension DefaultSubwaySearchSelectionViewModel {

    func didSelectDirection(direction: UpDownDirection, stationName: String) {
        let subwayTarget = SubwayTarget(
            name: station.name,
            lineNumber: station.lineNumber,
            destinationName: stationName,
            upDownDirection: direction,
            latPos: station.latPos,
            lonPos: station.lonPos
        )
        localSubwayRepository.enrollStation(subwayTarget: subwayTarget)
        NotificationCenter.default.post(name: .homeUpdateNotification, object: nil)
    }

    func viewDidLoad() {
        if let upStationCode = station.upStation,
           let upStation = localSubwayRepository.stationDictionary[upStationCode] {
            self.upStation.accept(upStation)
        }

        if let downStationCode = station.downStation,
            let downStation = localSubwayRepository.stationDictionary[downStationCode] {
            self.downStation.accept(downStation)
        }

        if let splitStation = station.splitStation,
           let splitStation = localSubwayRepository.stationDictionary[splitStation] {
            self.splitStation.accept(splitStation)
        }
    }

}
