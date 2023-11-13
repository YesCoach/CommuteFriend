//
//  SettingViewController.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MessageUI

final class SettingViewController: BaseViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(
            SettingViewCell.self,
            forCellReuseIdentifier: SettingViewCell.reuseIdentifier
        )
        tableView.estimatedRowHeight = .zero
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<Setting> = {
        let dataSource = RxTableViewSectionedReloadDataSource<Setting> {
            datasource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingViewCell.reuseIdentifier,
                for: indexPath
            ) as? SettingViewCell else { return UITableViewCell() }
            cell.configure(with: item)
            return cell
        }

        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }

        return dataSource
    }()

    private let viewModel: SettingViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Init

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .mainBackgroundColor
    }

    override func configureLayout() {
        super.configureLayout()
        [
            tableView
        ].forEach { view.addSubview($0) }

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureNavigationItem() {
        super.configureNavigationItem()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "설정"
    }

    // MARK: - Methods

    private func bind() {
        let cellSelected: ControlEvent<IndexPath> = tableView.rx.itemSelected

        let input = SettingViewModel.Input(cellSelected: cellSelected.asObservable())
        let output = viewModel.transform(from: input)
        output.settingItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        output.selectedItem
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, item in
                print(item.description)
                switch item.kind {
                case .appstore: owner.appUpdate()
                case .webView:
                    let viewController = SettingModalWebViewController(
                        viewModel: .init(settingItem: item)
                    )
                    owner.present(viewController, animated: true)
                case .mail: owner.presentEmail()
                case .share: owner.shareAppURL()
                }
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - 앱스토어 이동하기

extension SettingViewController {

    func appUpdate() {
        guard UserDefaultsManager.isAppUpToDate == false else { return }

        DispatchQueue.main.async {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/6470272313"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

}

// MARK: - Mail 문의하기

extension SettingViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        self.dismiss(animated: true, completion: nil)
    }

    private func presentEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self

            let bodyString = """
                             문의하시려는 내용을 아래에 작성해주세요.

                             -------------------

                             Device Model : \(Setting.currentDeviceModel())
                             Device OS : \(UIDevice.current.systemVersion)
                             App Version : \(Setting.currentAppVersion())

                             -------------------
                             """

            composeViewController.setToRecipients(["yescoach1020@gmail.com"])
            composeViewController.setSubject("<출퇴근메이트> 문의")
            composeViewController.setMessageBody(bodyString, isHTML: false)

            self.present(composeViewController, animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController(
                title: "메일 전송 실패",
                message: "문의를 보내려면 메일 앱이 필요해요. 앱스토에서 해당 앱을 다운로드받거나 이메일 설정을 확인하고 다시 시도해주세요.",
                preferredStyle: .alert
            )
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)

            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }

}

// MARK: - 앱 공유하기

private extension SettingViewController {

    func shareAppURL() {

        let objectToShare = [NSURL(string: "http://bit.ly/commutemate")]

        let activityVC = UIActivityViewController(
            activityItems: objectToShare,
            applicationActivities: nil
        )

        // 공유하기 기능 중 제외할 기능이 있을 때 사용
        //activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }

}
