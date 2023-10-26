# 출퇴근메이트

![출퇴근메이트 001](https://github.com/YesCoach/CommuteFriend/assets/59643667/7df899ce-4c9f-40f0-88d8-2f294168c6c4)

### 한 줄 소개

서울시 지하철과 버스의 실시간 도착 정보를 확인 할 수 있는 서비스

### 제공하는 기능

-   서울시 공공 API 기반 지하철, 버스 실시간 도착정보 제공
-   즐겨찾기 등록을 통해 사용자가 역 근처에 진입했을때, 푸시 알림 서비스 제공
-   라이브 액티비티를 활용한 실시간 도착정보 확인기능 제공

### 개발 기간

2023.09.25 ~ 2023.10.27

## 📚 기술스택

-   **UIKit, Codebase UI, AutoLayout**
-   **MVVM**, **Repository**, **DIContainer**
-   **DiffableDataSource**
-   **UserNotifications, CoreLocation, Background Mode(Location)**
-   **SPM**
-   **Realm**
-   **Alamofire**, **Kingfisher**
-   **SnapKit**
-   **RxSwift**
-   **SwiftLint**
-   **SwiftUI, WidgetExtension, ActivityKit**


## 🛎️ 회고

### **🙆‍♂️ 성취점**

-   **공공 API 데이터 처리와 DTO**

    서비스에서 제공하고자 하는 기능에 필요한 데이터를 공공API로 받아 처리하는 과정에서 많은 애로사항이 있었다. 

    1.   검색한 역의 다음 역에 관한 정보가 필요한데, API의 Response로 받아오는 데이터는 별도의 문자열 처리가 필요했다.

         ```swift
         "trainLineNm": "문산행 - 화전방면"
         ```

    2.   수도권 노선의 경우(ex. 수인분당선, 경의중앙선 등) 초단위 도착정보가 제공되지 않아서, 대신 보여줄 도착정보 텍스트를 사용해야하는데 이것도 문자열 가공이 필요했다.

         ```swift
         "arvlMsg2": "[5]번째 전역 (공덕)"
         ```

    도메인 계층과 데이터 계층의 분리, 서비스의 비즈니스 모델과 Network Response 모델의 분리를 위해 DTO 타입을 만들었고, 덕분에 외부 API에서 받아온 데이터에 대한 처리는 데이터 계층에서 하도록, 도메인 계층에서는 오로지 비즈니스 로직에만 책임을 갖도록 대응할 수 있었다.

    위의 문자열 처리는 도메인으로 데이터를 보내기 전, 데이터 레이어에서 수행하도록 구현했다.

    ```swift
    struct SubwayStationArrivalDTO: DTOMapping {
        typealias DomainType = SubwayArrival
    
        let line: String // @@행 - @@방면
        let arrivalMessage: String // 도착까지 남은 시간 or 전역 출발
        let remainTimeForSecond: String // 남은 시간(초)
        let currentStation: String // 현재 위치
        let subwayID: String // 호선 id
        let creationDate: String // 데이터 생성 시각
        let arrivalCode: String // 도착 코드
        let updnLine: String // 상하행 구분 - "상행" "하행"
        let ordkey: String // 도착 순서 코드
    
        enum CodingKeys: String, CodingKey {
            case line = "trainLineNm"
            case arrivalMessage = "arvlMsg2"
            case remainTimeForSecond = "barvlDt"
            case currentStation = "arvlMsg3"
            case subwayID = "subwayId"
            case creationDate = "recptnDt"
            case arrivalCode = "arvlCd"
            case updnLine
            case ordkey
        }
    
        func toDomain() -> DomainType {
            /// @@ 행
            let trimmedline = line.components(separatedBy: " ").first
            /// @@ 방면
            let destination = line.components(separatedBy: " ")[safe: 2]?
                .components(separatedBy: "방면").first
    
            // 남은 시간을 제공하지 않는 수도권 노선에 활용할 도착 메시지 구성
            var arrivalMessageFixed = arrivalMessage
                .replacingOccurrences(of: "[\\[\\]]", with: "", options: .regularExpression)
                .components(separatedBy: "(").first?
                .trimmingCharacters(in: .whitespaces)
    
            return DomainType(
                direction: trimmedline ?? line,
                arrivalMessage: arrivalMessageFixed ?? arrivalMessage,
                remainTimeForSecond: remainTimeForSecond,
                currentStation: currentStation,
                nextStation: destination ?? "",
                subwayLine: subwayID,
                creationDate: creationDate,
                arrivalCode: arrivalCode,
                upDownLine: updnLine,
                ordkey: ordkey
            )
        }
    }
    
    ```

-   **프로토콜과 의존성주입을 활용한 뷰컨트롤러 재사용**

    지하철과 버스 탭의 즐겨찾기 화면은 UI가 완전히 동일한 형태로 구성되어 있다. 따라서 하나의 뷰컨트롤러을 사용하되 내부적으로 동작하는 비즈니스 로직과 모델만 달라지도록 뷰모델을 인터페이스로 추상화했다.

    ```swift
    final class FavoriteViewController: BaseViewController {
    
        typealias DataSourceType = UITableViewDiffableDataSource<Int, FavoriteItem>
    
        enum BeginningFrom {
            case subway
            case bus
        }
    
        // 생략
    
        private var viewModel: FavoriteViewModel
        private let disposeBag = DisposeBag()
        private let beginningFrom: BeginningFrom
    
        // MARK: - Initializer
    
        init(viewModel: FavoriteViewModel, beginningFrom: BeginningFrom) {
            self.viewModel = viewModel
            self.beginningFrom = beginningFrom
            super.init(nibName: nil, bundle: nil)
        }
        
        // 생략
    }
    ```

    FavoriteViewController는 인터페이스로 추상화된 FavoriteViewModel 타입만 알고 있다.

    

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        enrollNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    @objc func updateFavoriteItemList(_ sender: NSNotification) {
        viewModel.viewWillAppear()
    }
    
    func bindViewModel() {
        viewModel.favoriteStationItems
            .bind(with: self) { owner, list in
                owner.updateSnapShot(data: list)
            }
            .disposed(by: disposeBag)
    }
    ```

    뷰컨트롤러는 추상화된 뷰모델의 Input 메서드와 Output 데이터 스트림만 알고 있고, 구체화된 뷰모델이 로직과 데이터 스트림을 구성하는 흐름으로 구성하여 의존성 주입의 장점을 활용할 수 있었다.

    

    ```swift
    protocol FavoriteViewModelInput {
        func viewWillAppear()
        func deleteFavoriteItem(item: FavoriteItem)
        func didAlarmButtonTouched(item: FavoriteItem)
        func didEnrollButtonTouched(completion: @escaping (Bool)-> Void)
    }
    
    protocol FavoriteViewModelOutput {
        var favoriteStationItems: BehaviorSubject<[FavoriteItem]> { get set }
    }
    
    protocol FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput { }
    ```

    이처럼 추상화한 인터페이스를 구현하고, 이에 대한 구체타입을 의존성주입을 통해 넣어주어 하나의 뷰컨트롤러를 재사용하는 이점을 얻을 수 있었다.

    ```swift
    final class SubwayFavoriteViewModel: FavoriteViewModel {
    
        let localSubwayRepository: LocalSubwayRepository
    
        init(localSubwayRepository: LocalSubwayRepository) {
            self.localSubwayRepository = localSubwayRepository
        }
    
        var favoriteStationItems: BehaviorSubject<[FavoriteItem]> = BehaviorSubject(value: [])
    }
    
    extension SubwayFavoriteViewModel {
    
        func viewWillAppear() {
            let favoriteStationList = localSubwayRepository.readFavoriteStationList()
            favoriteStationItems.onNext(favoriteStationList)
        }
    
        func deleteFavoriteItem(item: FavoriteItem) {
            localSubwayRepository.deleteFavoriteStation(item: item)
            let favoriteStationList = localSubwayRepository.readFavoriteStationList()
            favoriteStationItems.onNext(favoriteStationList)
        }
    
        func didAlarmButtonTouched(item: FavoriteItem) {
            let newItem = FavoriteItem(
                stationTarget: item.stationTarget,
                isAlarm: !item.isAlarm
            )
            localSubwayRepository.updateFavoriteStationList(item: newItem)
            viewWillAppear()
            if newItem.isAlarm {
                LocationManager.shared.registLocation(target: newItem.stationTarget)
            } else {
                LocationManager.shared.removeLocation(target: newItem.stationTarget)
            }
        }
    
        func didEnrollButtonTouched(completion: @escaping (Bool) -> Void) {
            if let count = try? favoriteStationItems.value().count {
                if count < 10 { completion(true) }
                else { completion(false) }
            }
            completion(false)
        }
    }
    
    final class BusFavoriteViewModel: FavoriteViewModel {
    
        let localBusRepository: LocalBusRepository
    
        init(localBusRepository: LocalBusRepository) {
            self.localBusRepository = localBusRepository
        }
    
        var favoriteStationItems: BehaviorSubject<[FavoriteItem]> = BehaviorSubject(value: [])
    }
    
    extension BusFavoriteViewModel {
    
        func viewWillAppear() {
            let favoriteStationList = localBusRepository.readFavoriteStationList()
            favoriteStationItems.onNext(favoriteStationList)
        }
    
        func deleteFavoriteItem(item: FavoriteItem) {
            localBusRepository.deleteFavoriteStation(item: item)
            LocationManager.shared.removeLocation(target: item.stationTarget)
            let favoriteStationList = localBusRepository.readFavoriteStationList()
            favoriteStationItems.onNext(favoriteStationList)
        }
    
        func didAlarmButtonTouched(item: FavoriteItem) {
            let newItem = FavoriteItem(
                stationTarget: item.stationTarget,
                isAlarm: !item.isAlarm
            )
            localBusRepository.updateFavoriteStationList(item: newItem)
            viewWillAppear()
            if newItem.isAlarm {
                LocationManager.shared.registLocation(target: newItem.stationTarget)
            } else {
                LocationManager.shared.removeLocation(target: newItem.stationTarget)
            }
        }
    
        func didEnrollButtonTouched(completion: @escaping (Bool) -> Void) {
            if let count = try? favoriteStationItems.value().count {
                if count < 10 { completion(true) }
                else { completion(false) }
            }
            completion(false)
        }
    
    }
    ```

    이외에도 비즈니스 로직에 대한 UnitTest나 UITest를 수행하는 경우, 추상화된 뷰모델을 통해 테스트하기 용이하다는 장점이 있다.

-   **새로운 기술의 학습(CLRegion과 Background Mode, ActivityKit)**

    사용자가 역에 도착하기 전에, 미리 도착정보를 확인할 수 있도록 유도하는 기능을 추가하고 싶어서 CLRegion이라는 개념을 학습했다. 위경도 값을 통해 Region을 생성하고, 이를 UserNotification의 trigger로 구성하며 기능을 구현했다. 특히 앱이 실행중이지 않거나 백그라운드 상태일때도 역 주변에 진입했는지에 따라 푸시 알림을 주고 싶었고, 백그라운드 모드 중 location update 모드를 추가하고 관련 개념을 학습하며 의도하는 기능을 구현할 수 있었다.

    iOS 16.2부터 사용가능한 Live Activity는, 특히 다이나믹 아일랜드를 활용한 실시간 현황 기능은 꼭 한번 사용해보고 싶었던 기술이였다. 마침 대중교통의 실시간 도착정보 제공이라는 서비스에서 활용하면 사용자로 하여금 유의미한 편리성을 제공할 것이라고 생각하여 공식문서를 참고하며 프로젝트에 적용하게 되었다. SwiftUI의 언어적 특성과 구현 방식에 대해 친숙해질 수 있었던 시간이였고, Widget Extension과 타깃 개념에 대해 좀 더 구체적으로 학습해야겠다는 목표를 가지게 되었다.

### **🤔 아쉬운 점**

-   **프로토콜과 제네릭을 활용한 구조체 다형성**

    지하철과 버스 모델 타입을 하나의 `Target` 프로토콜 타입으로 추상화하고, 비즈니스 로직과 UI에 사용할때 다형성을 통해 처리하려고 했지만 실패했다. 추상화된 뷰모델 인터페이스에서 associatedType으로 제네릭한 타입을 가지고 뷰컨트롤러에서 타입체크를 통해 구체화된 타입을 받아오게 하려고 했지만, 아직 스위프트에서 다형성을 어떻게 처리하는지, static dispatch와 dynamic dispatch의 원리에 대해 제대로 이해하지 못하며 구현에 어려움을 겪었다. 관련 키워드인 `some`과 `any`, `static dispatch`와 `dynamic dispatch`를 공부하고 추후 리팩토링에 적용해야겠다.

    프로젝트에서는 다형성 대신 enum의 연관값으로 구현했는데, Static Dispatch에서 오는 성능상의 이점이 있고 상대적으로 구현이 쉽다는 장점을 배울 수 있었다. 반면 다형성의 경우 동일한 인터페이스로 여러 타입과 상호작용 할 수 있고 enum의 case 처리에서 오는 부가적인 코드를 줄일 수 있다는 장점이 있지만, Dynamic Dispatch로 동작하기 때문에 성능적인 측면에서 단점이 된다는 것을 알았다.

    두가지 방법 모두 장단점이 존재하는 `trade off` 이기 때문에, 기술적으로 이해하고 왜 이 방법을 선택했는지 설명할 수 있도록 자세히 정리해야겠다.

