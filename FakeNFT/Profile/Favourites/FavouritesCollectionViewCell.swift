
import UIKit

protocol FavouritesCollectionCellDelegate: AnyObject {
    func deleteFromFav(indexPath: IndexPath)
}

final class FavouritesCollectionViewCell: UICollectionViewCell {
    
    var id: String = ""
    
    var indexPath: IndexPath?
    
    weak var delegate: FavouritesCollectionCellDelegate?
    
    lazy var nftCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 0
        return view
    }()
    private lazy var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.layer.cornerRadius = 12
        nftImage.clipsToBounds = true
        nftImage.isUserInteractionEnabled = true
        nftImage.image = UIImage(systemName: "person.crop.circle.fill")
        nftImage.backgroundColor = .lightGray
        return nftImage
    }()
    
    private lazy var nftLikeButton: UIButton = {
        let nftLikeButton = UIButton()
        nftLikeButton.translatesAutoresizingMaskIntoConstraints = false
        nftLikeButton.clipsToBounds = true
        nftLikeButton.isUserInteractionEnabled = true
        nftLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        nftLikeButton.tintColor = .red
        nftLikeButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        return nftLikeButton
    }()
    
    private lazy var stackViewStarImage: UIStackView = {
        let stackViewStarImage = UIStackView()
        stackViewStarImage.translatesAutoresizingMaskIntoConstraints = false
        stackViewStarImage.axis = .horizontal
        stackViewStarImage.distribution = .fillEqually
        stackViewStarImage.alignment = .fill
        stackViewStarImage.spacing = 0
        stackViewStarImage.backgroundColor = .white
        return stackViewStarImage
    }()

    private lazy var nftTitle: UILabel = {
        let nftTitle = UILabel()
        nftTitle.translatesAutoresizingMaskIntoConstraints = false
        nftTitle.textColor = .black
        nftTitle.font = UIFont(name: "SFProText-Bold", size: 17)
        return nftTitle
    }()
    
    private lazy var nftPrice: UILabel = {
        let nftPrice = UILabel()
        nftPrice.translatesAutoresizingMaskIntoConstraints = false
        nftPrice.textColor = .black
        nftPrice.font = UIFont(name: "SFProText-Regular", size: 15)
        return nftPrice
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for subview in stackViewStarImage.arrangedSubviews{
            stackViewStarImage.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    @objc private func heartButtonTapped(){
        guard let indexPath = indexPath else { return }
        delegate?.deleteFromFav(indexPath: indexPath)
    }
    
    func configure(with nftFav: MyFavNFT){
        addSubview()
        setupConstraint()
        nftImage.image = nftFav.image
        nftTitle.text = nftFav.title
        if let price = nftFav.price{
            nftPrice.text = "\(price)" + " ETH"
        }
        addStarRating(from: nftFav.rating ?? 0)
        id = nftFav.id ?? ""
    }
    
    func addStarRating(from rating: Int){
        for index in 0...4 {
            stackViewStarImage.addArrangedSubview(UIImageView(image: UIImage(systemName:"star.fill")))
            stackViewStarImage.arrangedSubviews[index].tintColor = UIColor(hexString: "#e1e3e6")
        }
        for index in 0..<rating {
            stackViewStarImage.arrangedSubviews[index].tintColor = UIColor.yellow
        }
    }
    
    private func addSubview() {
        contentView.addSubview(nftCellView)
        nftCellView.addSubview(nftImage)
        nftImage.addSubview(nftLikeButton)
        nftCellView.addSubview(nftTitle)
        nftCellView.addSubview(nftPrice)
        nftCellView.addSubview(stackViewStarImage)

    }
    private func setupConstraint(){
        NSLayoutConstraint.activate([
            nftCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCellView.heightAnchor.constraint(equalToConstant: 80),
            nftCellView.widthAnchor.constraint(equalToConstant: 168),
            
            nftImage.leadingAnchor.constraint(equalTo: nftCellView.leadingAnchor),
            nftImage.topAnchor.constraint(equalTo: nftCellView.topAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            
            nftLikeButton.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 5.81),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: -5.82),
            nftLikeButton.heightAnchor.constraint(equalToConstant: 18),
            nftLikeButton.widthAnchor.constraint(equalToConstant: 21),
            
            nftTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            nftTitle.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            
            stackViewStarImage.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 4),
            stackViewStarImage.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            stackViewStarImage.heightAnchor.constraint(equalToConstant: 12),
            stackViewStarImage.widthAnchor.constraint(equalToConstant: 68),

            nftPrice.topAnchor.constraint(equalTo: stackViewStarImage.bottomAnchor, constant: 8),
            nftPrice.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12)
        ])
    }

}


