
import UIKit

class MyNFTViewController: UIViewController {
    
    private var nftService = NetworkNFTService()
    
    private var idArray: [String] = []
    
    private var nftArray: [MyNFT] = [
//        MyNFT(author: "Jonh", image: UIImage(systemName: "person.crop.circle.fill"), title: "Pixi", rating: 0, isLike: true, price: 3.54),
//        MyNFT(author: "Elsa", image: UIImage(systemName: "person.crop.circle.fill"), title: "Archie", rating: 2, isLike: false, price: 5.64),
//        MyNFT(author: "Piter", image: UIImage(systemName: "person.crop.circle.fill"), title: "Melissa", rating: 3, isLike: true, price: 7.54),
//        MyNFT(author: "Sarah", image: UIImage(systemName: "person.crop.circle.fill"), title: "April", rating: 4, isLike: false, price: 1.54),
//        MyNFT(author: "Sarah", image: UIImage(systemName: "person.crop.circle.fill"), title: "Lilo", rating: 3, isLike: false, price: 12.54),
//        MyNFT(author: "Sarah", image: UIImage(systemName: "person.crop.circle.fill"), title: "Daisy", rating: 2, isLike: false, price: 14.54),
//        MyNFT(author: "Sarah", image: UIImage(systemName: "person.crop.circle.fill"), title: "Stiphe", rating: 5, isLike: false, price: 20.54),
//        MyNFT(author: "Jonh", image: UIImage(systemName: "person.crop.circle.fill"), title: "Pixi", rating: 0, isLike: true, price: 3.54),
//        MyNFT(author: "Elsa", image: UIImage(systemName: "person.crop.circle.fill"), title: "Archie", rating: 2, isLike: false, price: 5.64),
//        MyNFT(author: "Piter", image: UIImage(systemName: "person.crop.circle.fill"), title: "Melissa", rating: 3, isLike: true, price: 7.54),
//        MyNFT(author: "Sarah", image: UIImage(systemName: "person.crop.circle.fill"), title: "April", rating: 4, isLike: false, price: 1.54),
//        MyNFT(author: "Sarah", image: UIImage(systemName: "person.crop.circle.fill"), title: "Lilo", rating: 3, isLike: false, price: 12.54),
//        MyNFT(author: "Sarah", image: UIImage(systemName: "person.crop.circle.fill"), title: "Daisy", rating: 2, isLike: false, price: 14.54),
//        MyNFT(author: "Sarah", image: UIImage(systemName: "person.crop.circle.fill"), title: "Stiphe", rating: 5, isLike: false, price: 20.54)
    ]
    
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
    
    private func addSubviews(){
        view.addSubview(myNftTableView)
        view.addSubview(myNftPlaceHolderTitle)
    }
    
    private func updatePlaceHolderNaf(){
        if nftArray.count != 0 {
            myNftTableView.isHidden = false
            myNftPlaceHolderTitle.isHidden = true
        } else {
            myNftTableView.isHidden = true
            myNftPlaceHolderTitle.isHidden = false
        }
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            myNftTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            myNftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myNftTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            myNftPlaceHolderTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myNftPlaceHolderTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    private func setupNavBar(){
        navigationItem.title = "Мои NFT"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(dismissNav))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.justify.left"), style: .plain, target: self, action: #selector(filter))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    @objc private func dismissNav(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func filter(){
        let alertController = UIAlertController(title: "Cортировка", message: .none,  preferredStyle: .actionSheet)
        
        let priceFilter = UIAlertAction(title: "По цене", style: .default) { _ in
            
        }
        let ratingFilter = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            
        }
        let nameFilter = UIAlertAction(title: "По названию", style: .default) { _ in
            
        }
        
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alertController.addAction(priceFilter)
        alertController.addAction(ratingFilter)
        alertController.addAction(nameFilter)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true)
    }
    private func addMyNFTArray(){
        UIBlockingProgressHUD.show()
        if idArray.count == 0 {UIBlockingProgressHUD.dismiss()
        } else {
            nftService.fetchMyNFT(from: idArray){ nftResult in
                switch nftResult {
                case .success(let nftFav):
                    DispatchQueue.main.async {
                        self.nftArray.append(nftFav)
                        self.myNftTableView.reloadData()
                        self.updatePlaceHolderNaf()
                        if self.idArray.count == self.nftArray.count{UIBlockingProgressHUD.dismiss()}
                    }
                case .failure(_ ):
                    UIBlockingProgressHUD.dismiss()
                    break
                }
            }
        }
    }
}
extension MyNFTViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNFTTableViewCell", for: indexPath) as! MyNFTTableViewCell
        if nftArray.count == 0{print("массив данных пуст")}
        let currentNft = nftArray[indexPath.row]
        cell.configure(with: currentNft)
        return cell
    }
}
