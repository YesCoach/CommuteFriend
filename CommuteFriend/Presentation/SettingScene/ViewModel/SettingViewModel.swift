//
//  SettingViewModel.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/11/10.
//

import Foundation
import RxSwift
import RxRelay

final class SettingViewModel: BaseInOutViewModel {

    struct Input {
        let cellSelected: Observable<IndexPath>
    }

    struct Output {
        let settingItems: BehaviorRelay<[Setting]> = BehaviorRelay<[Setting]>(
            value: Setting.allCases
        )
        let selectedItem: PublishRelay<SettingItem>
    }

    private let disposeBag = DisposeBag()

    init() {
        versionCheck()
    }

    func transform(from input: Input) -> Output {
        let selectedItem = PublishRelay<SettingItem>()

        input.cellSelected
            .map { Setting.allCases[$0.section].items[$0.row] }
            .bind(with: self) { owner, item in
                selectedItem.accept(item)
            }
            .disposed(by: disposeBag)

        return Output(selectedItem: selectedItem)
    }

    private func versionCheck() {
        // MARK: App 버전 체크

        VersionCheckManager.shared.isAppVersionUpToDate { result in
            switch result {
            case .success(let isAppUpToDate):
                UserDefaultsManager.isAppUpToDate = isAppUpToDate
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

}
