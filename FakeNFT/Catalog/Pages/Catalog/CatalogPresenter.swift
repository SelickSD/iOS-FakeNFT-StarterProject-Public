//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Сергей Денисенко on 26.03.2024.
//
import Foundation
final class CatalogPresenter: CatalogPresenterProtocol {
    weak var view: CatalogViewControllerProtocol?
    private let catalogService = CatalogNetWorkService.shared
    private var collections: [Collection] = []
    private var likes: [String] = []
    
    init() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewDidLoad() {
        catalogService.resetCollections()
        if collections.count == 0 {
            catalogService.fetchCollections(){ result in
                switch result {
                case .success(let body):
                    self.collections = body
                    self.view?.updateTableViewAnimated()
                    self.fetchLikes()
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    self.showConnectError(message: "\(error)")
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    func getCollectionsElement(index: Int) -> Collection? {
        guard index < collections.count else { return nil }
        return collections[index]
    }

    func getLabelText(index: Int) -> String {
        guard index < collections.count else { return "" }
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
