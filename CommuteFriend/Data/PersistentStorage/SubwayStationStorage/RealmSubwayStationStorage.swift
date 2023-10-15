//
//  RealmSubwayStationStorage.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation

final class RealmSubwayStationStorage {

    private let realmStorage: RealmStorage

    init(realmStorage: RealmStorage) {
        self.realmStorage = realmStorage
    }

}

extension RealmSubwayStationStorage: SubwayStationStorage {

    func enrollStation(station: SubwayEntity) {
        guard let user = try? realmStorage.readData(UserEntity.self).first
        else {
            debugPrint("User Entity is missing!")
            return
        }
        realmStorage.updateData(data: station) { realm, station in
            // 중복체크
            if let index = user.recentSubwayList.firstIndex(where: { subwayEntity in
                subwayEntity.subwayName == station.subwayName &&
                subwayEntity.subwayLineNumber == station.subwayLineNumber &&
                subwayEntity.subwayUpDownDirection == station.subwayUpDownDirection
            }) {
                let entity = user.recentSubwayList[index]
                user.recentSubwayList.remove(at: index)
                realm.delete(entity)
            }

            // 최대 갯수 초과시 가장 마지막에 추가된 데이터 삭제
            if user.recentSubwayList.count >= Constants.Policy.maximumStation {
                user.recentSubwayList.removeFirst()
            }

            user.recentSubwayList.append(station)
        }
    }

    func readStation() -> SubwayEntity? {
        do {
            let user = try realmStorage.readData(UserEntity.self).first
            return user?.recentSubwayList.last
        } catch {
            print("🙅‍♂️", error)
            return nil
        }
    }

    func readStationList() -> [SubwayEntity] {
        do {
            let user = try realmStorage.readData(UserEntity.self).first
            return user?.recentSubwayList.map { $0 }.reversed() ?? []
        } catch {
            print("🙅‍♂️", error)
            return []
        }
    }

    func deleteStation(station: SubwayEntity) {
        guard let user = try? realmStorage.readData(UserEntity.self).first,
              let station = try? realmStorage.readData(SubwayEntity.self, primaryKey: station.id)
        else {
            debugPrint("User Entity is missing!")
            return
        }

        realmStorage.updateData(data: station) { station in
            if let index = user.recentSubwayList.firstIndex(where: { $0.id == station.id }) {
                user.recentSubwayList.remove(at: index)
            }
        }
        realmStorage.deleteData(data: station)
    }

}
