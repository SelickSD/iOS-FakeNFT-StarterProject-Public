
import UIKit

class FavouritesViewController: UIViewController {
    
    
    private var nftFavArray: [MyFavNFT] = [
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melisa", rating: 0, isLike: true, price: "3,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Piter", rating: 2, isLike: false, price: "5,64"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Pixi", rating: 3, isLike: true, price: "7,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melissa", rating: 4, isLike: false, price: "10,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "April", rating: 4, isLike: false, price: "12,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Lilo", rating: 4, isLike: false, price: "15,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Daisy", rating: 4, isLike: false, price: "1,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melisa", rating: 0, isLike: true, price: "3,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Piter", rating: 2, isLike: false, price: "5,64"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Pixi", rating: 3, isLike: true, price: "7,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melissa", rating: 4, isLike: false, price: "1,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "April", rating: 4, isLike: false, price: "54,10"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Lilo", rating: 4, isLike: false, price: "10,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Daisy", rating: 4, isLike: false, price: "11,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melisa", rating: 0, isLike: true, price: "3,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Piter", rating: 2, isLike: false, price: "5,64"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Pixi", rating: 3, isLike: true, price: "7,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Melissa", rating: 4, isLike: false, price: "14,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "April", rating: 4, isLike: false, price: "12,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Lilo", rating: 4, isLike: false, price: "10,54"),
        MyFavNFT(image: UIImage(systemName: "person.crop.circle.fill"), title: "Daisy", rating: 4, isLike: false, price: "10,54"),]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews(){
        view.addSubview(nftCollectionView)
        
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
            nftCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
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
