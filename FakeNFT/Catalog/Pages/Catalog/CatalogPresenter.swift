//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 26.03.2024.
//
import Foundation
final class CatalogPresenter: CatalogPresenterProtocol {
    weak var view: CatalogViewControllerProtocol?
    private var catalogServiceObserver: NSObjectProtocol?
    private let catalogService = CatalogNetWorkService.shared
    private var collections: [Collection] = []
    private var likes: [String] = []
    
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
        if collections.count == 0 {
            catalogService.fetchCollections()
        }
    }
    
    func getCollectionsElement(index: Int) -> Collection? {
        guard index <= collections.count else { return nil}
        return collections[index]
    }
    
    func getImagesForCell(index: Int) -> Collection {
        return collections[index]
    }
    
    func getLabelText(index: Int) -> String {
        let text = "\(collections[index].name)(\(collections[index].nfts.count))"
        return text
    }
    
    func getValueCount() -> Int {
        return collections.count
    }
    
    func showSortAlert() {
        
        let sortNameAlert = AlertActionEvent(actionTitle: NSLocalizedString("catalogView.sortName",
                                                                            comment: "Text displayed like sort alert description"),
                                             actionStyle: .default,
                                             handler: {_ in })
        
        let sortNFTAlert = AlertActionEvent(actionTitle: NSLocalizedString("catalogView.sortNFT",
                                                                           comment: "Text displayed like sort alert description"),
                                            actionStyle: .default,
                                            handler: {_ in })
        let sortCloseAlert = AlertActionEvent(actionTitle: NSLocalizedString("catalogView.sortClose",
                                                                             comment: "Text displayed like sort alert description"),
                                              actionStyle: .cancel,
                                              handler: {_ in })
        
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
