//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 26.03.2024.
//
import Foundation
final class CatalogPresenter: CatalogPresenterProtocol,
                              CatalogPresenterDelegate {
    weak var view: CatalogViewControllerProtocol?
    private var catalogServiceObserver: NSObjectProtocol?
    private let catalogService = CatalogNetWorkService.shared
    private var collections: [Collection] = []
    private var likes: [String] = []
    private var sortedCollections: [Collection] = []

    init() {
            catalogServiceObserver = NotificationCenter.default.addObserver(
                forName: CatalogNetWorkService.didChangeNotificationCatalog,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let self = self
                else { return }
                if let body = notification.userInfo?["collections"] {
                    collections = body as! [Collection]
                    sortedCollections = collections
                } else {
                    return
                }
                self.view?.updateTableViewAnimated()
                fetchLikes()
            }

            catalogServiceObserver = NotificationCenter.default.addObserver(
                forName: CatalogNetWorkService.didNetWorkErrorDetected,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                guard let self = self
                else { return }
                if let error = notification.userInfo?["error"] {
                    self.showConnectError(message: "\(error)")
                } else {
                    self.showConnectError(message: "Проблемы сети")
                }
                UIBlockingProgressHUD.dismiss()
            }
        }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewDidLoad() {
        catalogService.resetCollections()
        if sortedCollections.count == 0 {
            catalogService.fetchCollections()
        }
    }

    func getCollectionsElement(index: Int) -> Collection? {
        guard index < sortedCollections.count else { return nil }
        return sortedCollections[index]
    }

    func getLabelText(index: Int) -> String {
        guard index < sortedCollections.count else { return "" }
        let text = "\(sortedCollections[index].name)(\(sortedCollections[index].nfts.count))"
        return text
    }
    
    func getValueCount() -> Int {
        return sortedCollections.count
    }
    
    func showSortAlert() {
        
        let sortNameAlert = AlertActionEvent(actionTitle: NSLocalizedString("catalogView.sortName",
                                                                            comment: "Text displayed like sort alert description"),
                                             actionStyle: .default,
                                             handler: {_ in
            self.sortByName()
            self.view?.sortCollection()
        })

        let sortNFTAlert = AlertActionEvent(actionTitle: NSLocalizedString("catalogView.sortNFT",
                                                                           comment: "Text displayed like sort alert description"),
                                            actionStyle: .default,
                                            handler: {_ in
            self.sortByCountNfts()
            self.view?.sortCollection()
        })
        let sortCloseAlert = AlertActionEvent(actionTitle: NSLocalizedString("catalogView.sortClose",
                                                                             comment: "Text displayed like sort alert description"),
                                              actionStyle: .cancel,
                                              handler: {_ in
            self.sortedCollections = self.collections
            self.view?.sortCollection()
        })

        let alert = AlertMessage(title: NSLocalizedString("catalogView.sortTitle",
                                                          comment: "Text displayed like sort alert description"),
                                 message: nil,
                                 preferredStyle: .actionSheet,
                                 action: [sortNameAlert, sortNFTAlert, sortCloseAlert])
        
        view?.showAlert(alert: alert)
    }
    
    func getLikes() -> [String] {
        return likes
    }

    func putLikes(nftId: String) {
        print(likes.count)
        if let index = likes.firstIndex(of: nftId) {
            likes.remove(at: index)
        } else {
            likes.append(nftId)
        }
        catalogService.putLikes(likes: likes ) { result in
            switch result {
            case .success(_):
                print(self.likes.count)
                break
            case .failure(let error):
                self.showConnectError(message: "\(error)")
            }
        }
    }

    private func sortByName() {
        var stringArray: [String] = []
        sortedCollections = []
        self.collections.forEach{
            stringArray.append($0.name)
        }
        var tmpArray = collections
        let sortedStringArray = stringArray.sorted()
        sortedStringArray.forEach{
            var count = 0
            for item in tmpArray {
                if item.name == $0 {
                    sortedCollections.append(item)
                    tmpArray.remove(at: count)
                    break
                }
                count += 1
            }
        }
    }

    private func sortByCountNfts() {
        var intArray: [Int] = []
        sortedCollections = []
        self.collections.forEach{
            intArray.append($0.nfts.count)
        }
        var tmpArray = collections
        let sortedIntArray = intArray.sorted()
        sortedIntArray.forEach{
            var count = 0
            for item in tmpArray {
                if item.nfts.count == $0 {
                    sortedCollections.append(item)
                    tmpArray.remove(at: count)
                    break
                }
                count += 1
            }
        }
    }

    private func showConnectError(message: String) {
        let action = AlertActionEvent(actionTitle: "Отмена",
                                      actionStyle: .destructive,
                                      handler: {_ in })
        
        
        let alert = AlertMessage(title: "Сетевая ошибка",
                                 message: message,
                                 preferredStyle: .alert,
                                 action: [action])
        
        view?.showAlert(alert: alert)
    }
    
    private func fetchLikes() {
        catalogService.fetchLikes() { likesResult in
            switch likesResult {
            case .success(let likes):
                self.likes = likes
            case .failure(let error):
                self.showConnectError(message: "\(error)")
            }
        }
    }
}
