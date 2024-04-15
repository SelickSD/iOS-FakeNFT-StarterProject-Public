import UIKit

class MyNFTViewController: UIViewController {

    private var nftService: NetworkNFTServiceProtocol

    var idArray: [String] = []

    private var nftArray: [MyNFT] = []

    private lazy var myNftTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        profileTableView.rowHeight = 140
        profileTableView.isScrollEnabled = true
        profileTableView.delegate = self
        profileTableView.separatorColor = .white
        profileTableView.dataSource = self
        profileTableView.register(MyNFTTableViewCell.self, forCellReuseIdentifier: "MyNFTTableViewCell")
        return profileTableView
    }()
    private lazy var myNftPlaceHolderTitle: UILabel = {
        let nftPlaceHolderTitle = UILabel()
        nftPlaceHolderTitle.translatesAutoresizingMaskIntoConstraints = false
        nftPlaceHolderTitle.textColor = .black
        nftPlaceHolderTitle.text = "У Вас ещё нет NFT"
        nftPlaceHolderTitle.font = UIFont(name: "SFProText-Bold", size: 17)
        nftPlaceHolderTitle.isHidden = true
        return nftPlaceHolderTitle
    }()

    init(nftService: NetworkNFTServiceProtocol) {
        self.nftService = nftService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.tabBarController?.tabBar.isHidden = true
        setupNavBar()
        addSubviews()
        setupConstraints()
        updatePlaceHolderNaf()
        addMyNFTArray()
    }

    private func addSubviews() {
        view.addSubview(myNftTableView)
        view.addSubview(myNftPlaceHolderTitle)
    }

    private func updatePlaceHolderNaf() {
        if nftArray.count != 0 {
            myNftTableView.isHidden = false
            myNftPlaceHolderTitle.isHidden = true
        } else {
            myNftTableView.isHidden = true
            myNftPlaceHolderTitle.isHidden = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            myNftTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            myNftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myNftTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            myNftPlaceHolderTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myNftPlaceHolderTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }
    private func setupNavBar() {
        navigationItem.title = "Мои NFT"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(dismissNav))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify.left"), style: .plain, target: self, action: #selector(filter))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    private func sortByPrice() {
        UIBlockingProgressHUD.show()
        self.nftArray = self.nftArray.sorted { $0.price ?? 0 > $1.price ?? 0 }
        self.myNftTableView.reloadData()
        self.updatePlaceHolderNaf()
        UIBlockingProgressHUD.dismiss()
    }
    private func sortByRating() {
        UIBlockingProgressHUD.show()
        self.nftArray = self.nftArray.sorted { $0.rating ?? 0 > $1.rating ?? 0 }
        self.myNftTableView.reloadData()
        self.updatePlaceHolderNaf()
        UIBlockingProgressHUD.dismiss()
    }
    private func sortByName() {
        UIBlockingProgressHUD.show()
        self.nftArray = self.nftArray.sorted { $1.title ?? "" > $0.title ?? "" }
        self.myNftTableView.reloadData()
        self.updatePlaceHolderNaf()
        UIBlockingProgressHUD.dismiss()
    }
    @objc private func dismissNav() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func filter() {
        let alertController = UIAlertController(title: "Cортировка", message: .none, preferredStyle: .actionSheet)

        let priceFilter = UIAlertAction(title: "По цене", style: .default) { _ in
            self.sortByPrice()
            SortingMethod.sortMethod = .sortByPrice
        }
        let ratingFilter = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.sortByRating()
            SortingMethod.sortMethod = .sortByRating
        }
        let nameFilter = UIAlertAction(title: "По названию", style: .default) { _ in
            self.sortByName()
            SortingMethod.sortMethod = .sortByName
        }

        let cancel = UIAlertAction(title: "Закрыть", style: .cancel)

        alertController.addAction(priceFilter)
        alertController.addAction(ratingFilter)
        alertController.addAction(nameFilter)
        alertController.addAction(cancel)

        self.present(alertController, animated: true)
    }
    private func addMyNFTArray() {
        UIBlockingProgressHUD.show()
        if idArray.count == 0 {UIBlockingProgressHUD.dismiss()
        } else {
            nftService.fetchMyNFT(from: idArray) { nftResult in

                switch nftResult {
                    case .success(let nftFav):
                    DispatchQueue.main.async {
                        self.nftArray.append(nftFav)
                        self.myNftTableView.reloadData()
                        self.updatePlaceHolderNaf()
                        if self.idArray.count == self.nftArray.count {
                            switch SortingMethod.sortMethod {
                            case .sortByPrice:
                                self.sortByPrice()
                            case .sortByRating:
                                self.sortByRating()
                            case .sortByName:
                                self.sortByName()
                            }
                            UIBlockingProgressHUD.dismiss()
                            }
                    }
                    case .failure:
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
        }
    }
extension MyNFTViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNFTTableViewCell", for: indexPath) as? MyNFTTableViewCell
        guard let cell = cell else {return UITableViewCell()}
        if nftArray.count == 0 {print("массив данных пуст")}
        let currentNft = nftArray[indexPath.row]
        cell.configure(with: currentNft)
        return cell
    }
}
