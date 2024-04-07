
import UIKit
import Foundation

class FavouritesViewController: UIViewController {
    
    private let nftService: NetworkNFTServiceProtocol
    
    var idFavArray: [String] = []
    
    var newIdFavArray: (([String]) -> Void)?
    
    private var nftFavArray: [MyFavNFT] = [
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melisa", rating: 0, isLike: true, price: 3.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Piter", rating: 2, isLike: true, price: 5.64),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Pixi", rating: 3, isLike: true, price: 7.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melissa", rating: 4, isLike: true, price: 10.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "April", rating: 4, isLike: true, price: 1.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Lilo", rating: 4, isLike: true, price: 15.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Daisy", rating: 4, isLike: true, price: 1.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melisa", rating: 0, isLike: true, price: 3.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Piter", rating: 2, isLike: true, price: 5.64),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Pixi", rating: 3, isLike: true, price: 7.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melissa", rating: 4, isLike: true, price: 1.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "April", rating: 4, isLike: true, price: 54.10),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Lilo", rating: 4, isLike: true, price: 10.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Daisy", rating: 4, isLike: true, price: 11.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melisa", rating: 0, isLike: true, price: 3.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Piter", rating: 2, isLike: true, price: 5.64),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Pixi", rating: 3, isLike: true, price: 7.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melissa", rating: 4, isLike: true, price: 14.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "April", rating: 4, isLike: true, price: 12.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Lilo", rating: 4, isLike: true, price: 10.54),
//        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Daisy", rating: 4, isLike: true, price: 10.54),
    ]
    
    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let nftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        nftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        nftCollectionView.register(FavouritesCollectionViewCell.self, forCellWithReuseIdentifier: "\(FavouritesCollectionViewCell.self)")
        nftCollectionView.backgroundColor = .white
        nftCollectionView.delegate = self
        nftCollectionView.dataSource = self
        return nftCollectionView
    }()
    
    private lazy var myFavNftPlaceHolderTitle: UILabel = {
        let myFavNftPlaceHolderTitle = UILabel()
        myFavNftPlaceHolderTitle.translatesAutoresizingMaskIntoConstraints = false
        myFavNftPlaceHolderTitle.textColor = .black
        myFavNftPlaceHolderTitle.text = "У Вас ещё нет избранных NFT"
        myFavNftPlaceHolderTitle.font = UIFont(name: "SFProText-Bold", size: 17)
        myFavNftPlaceHolderTitle.isHidden = true
        return myFavNftPlaceHolderTitle
    }()
    
    init(nftService: NetworkNFTServiceProtocol) {
        self.nftService = nftService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationController?.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        addSubviews()
        setupConstraints()
        updatePlaceHolderNaf()
        addFavInArray()
    }
    
    private func addFavInArray(){
        UIBlockingProgressHUD.show()
        if idFavArray.count == 0 {UIBlockingProgressHUD.dismiss()
        } else {
            nftService.fetchMyFavNFT(from: idFavArray){ nftResult in
                switch nftResult {
                case .success(let nftFav):
                    DispatchQueue.main.async {
                        self.nftFavArray.append(nftFav)
                        self.nftCollectionView.reloadData()
                        self.updatePlaceHolderNaf()
                        if self.nftFavArray.count == self.idFavArray.count{UIBlockingProgressHUD.dismiss()}
                    }
                case .failure(_ ):
                    UIBlockingProgressHUD.dismiss()
                    break
                }
            }
        }
    }
    
    private func updatePlaceHolderNaf(){
        if nftFavArray.count != 0 {
            nftCollectionView.isHidden = false
            myFavNftPlaceHolderTitle.isHidden = true
        } else {
            nftCollectionView.isHidden = true
            myFavNftPlaceHolderTitle.isHidden = false
        }
    }
    
    private func addSubviews(){
        view.addSubview(nftCollectionView)
        view.addSubview(myFavNftPlaceHolderTitle)
        
    }
    
    private func setupNavBar(){
        navigationItem.title = "Избранные NFT"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(dismissNav))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
    }
    @objc private func dismissNav(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            myFavNftPlaceHolderTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myFavNftPlaceHolderTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nftFavArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FavouritesCollectionViewCell.self)", for: indexPath) as? FavouritesCollectionViewCell else{return FavouritesCollectionViewCell()}
        cell.configure(with: nftFavArray[indexPath.row])
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}
extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}

extension FavouritesViewController: FavouritesCollectionCellDelegate {
    func deleteFromFav(indexPath: IndexPath) {
        let id = nftFavArray[indexPath.row].id
        nftFavArray.removeAll(where: {$0.id == id})
        idFavArray.removeAll(where: {$0 == id})
        nftCollectionView.reloadData()
        nftService.updateArrayFav(from: .init(likesArray: idFavArray)){_ in}
        newIdFavArray?(idFavArray)
        print("Удалить из избранного")
        updatePlaceHolderNaf()
    }
}
