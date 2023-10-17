//
//  RealmBusStationStorage.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/17.
//

import Foundation

final class RealmBusStationStorage {

    private let realmStorage: RealmStorage

    init(realmStorage: RealmStorage) {
        self.realmStorage = realmStorage
    }

}

extension RealmBusStationStorage: BusStationStorage {

    func enrollStation(station: BusDTO) {
        guard let user = try? realmStorage.readData(UserEntity.self).first
        else {
            debugPrint("User Entity is missing!")
            return
        }
        realmStorage.updateData(data: station) { realm, station in
            if let index = user.recentBusList.firstIndex(where: { busDTO in
                busDTO.stationName == station.stationName &&
                busDTO.busRouteName == station.busRouteName &&
                busDTO.stationID == station.stationID
            }) {
                let record = user.recentSubwayList[index]
                user.recentBusList.remove(at: index)
                realm.delete(record)
            }

            if user.recentBusList.count >= Constants.Policy.maximumStation {
                user.recentBusList.removeFirst()
            }

            user.recentBusList.append(station)
        }
    }

    func readStationList() -> [BusDTO] {
        do {
            let user = try realmStorage.readData(UserEntity.self).first
            return user?.recentBusList.map { $0 }.reversed() ?? []
        } catch {
            print("🙅‍♂️", error)
            return []
        }
    }

    func deleteStation(station: BusDTO) {
        guard let user = try? realmStorage.readData(UserEntity.self).first,
              let station = try? realmStorage.readData(BusDTO.self, primaryKey: station.id)
        else {
            debugPrint("User Entity is missing!")
            return
        }

        realmStorage.updateData(data: station) { station in
            if let index = user.recentBusList.firstIndex(where: { $0.id == station.id }) {
                user.recentBusList.remove(at: index)
            }
        }
        realmStorage.deleteData(data: station)
    }

    // MARK: - Favorite

    func enrollFavoriteBus(favorite: FavoriteBusDTO) throws {
        guard let user = try? realmStorage.readData(UserEntity.self).first
        else {
            debugPrint("User Entity is missing!")
            return
        }

        // 최대 갯수 초과시 에러 throw
        if user.recentSubwayList.count >= Constants.Policy.maximumStation {
            throw RealmCRUDError.createLimitError
        }

        realmStorage.updateData(data: favorite) { realm, favorite in
            // 중복체크
            if let index = user.favoriteBusList.firstIndex(where: { favoriteBus in
                favoriteBus.stationName == favorite.stationName &&
                favoriteBus.busRouteName == favorite.busRouteName &&
                favoriteBus.stationID == favorite.stationID
            }) {
                let item = user.favoriteBusList[index]
                user.favoriteBusList.remove(at: index)
                realm.delete(item)
            }

            user.favoriteBusList.append(favorite)
        }
    }

    func readFavoriteBus() -> [FavoriteBusDTO] {
        do {
            let user = try realmStorage.readData(UserEntity.self).first
            return user?.favoriteBusList.map { $0 }.reversed() ?? []
        } catch {
            print("🙅‍♂️", error)
            return []
        }
    }

    func deleteFavoriteBus(favorite: FavoriteBusDTO) {
        guard let user = try? realmStorage.readData(UserEntity.self).first,
              let favoriteItem = try? realmStorage.readData(
                FavoriteBusDTO.self,
                primaryKey: favorite.id
              )
        else {
            debugPrint("User Entity is missing!")
            return
        }

        realmStorage.updateData(data: favoriteItem) { favorite in
            if let index = user.favoriteBusList.firstIndex(where: { $0.id == favorite.id }) {
                user.favoriteBusList.remove(at: index)
            }
        }
        realmStorage.deleteData(data: favoriteItem)
    }

    func updateFavoriteBus(favorite: FavoriteBusDTO) {
        guard let favoriteItem = try? realmStorage.readData(
                FavoriteBusDTO.self,
                primaryKey: favorite.id
              )
        else {
            debugPrint("User Entity is missing!")
            return
        }

        realmStorage.updateData(data: favoriteItem) { favoriteItem in
            favoriteItem.isAlarm = favorite.isAlarm
        }
    }

}
