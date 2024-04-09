
import UIKit

final class MyNFTTableViewCell: UITableViewCell {
    
    var id: String = ""
    
    private lazy var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.layer.cornerRadius = 12
        nftImage.clipsToBounds = true
        nftImage.image = UIImage(systemName: "person.crop.circle.fill")
        nftImage.backgroundColor = .lightGray
        return nftImage
    }()
    
    private lazy var nftLikeButton: UIButton = {
        let nftLikeButton = UIButton()
        nftLikeButton.translatesAutoresizingMaskIntoConstraints = false
        nftLikeButton.clipsToBounds = true
        nftLikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        nftLikeButton.tintColor = .white
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
    
    private lazy var nftAuthorOT: UILabel = {
        let nftAuthorOT = UILabel()
        nftAuthorOT.translatesAutoresizingMaskIntoConstraints = false
        nftAuthorOT.textColor = .black
        nftAuthorOT.text = "от"
        nftAuthorOT.font = UIFont(name: "SFProText-Regular", size: 15)
        return nftAuthorOT
    }()
    
    private lazy var nftAuthor: UILabel = {
        let nftAuthor = UILabel()
        nftAuthor.translatesAutoresizingMaskIntoConstraints = false
        nftAuthor.textColor = .black
        nftAuthor.font = UIFont(name: "SFProText-Regular", size: 13)
        return nftAuthor
    }()
    
    private lazy var nftPriceName: UILabel = {
        let nftPriceName = UILabel()
        nftPriceName.translatesAutoresizingMaskIntoConstraints = false
        nftPriceName.textColor = .black
        nftPriceName.text = "Цена"
        nftPriceName.font = UIFont(name: "SFProText-Regular", size: 13)
        return nftPriceName
    }()
    
    private lazy var nftPrice: UILabel = {
        let nftPrice = UILabel()
        nftPrice.translatesAutoresizingMaskIntoConstraints = false
        nftPrice.textColor = .black
        nftPrice.font = UIFont(name: "SFProText-Bold", size: 17)
        return nftPrice
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupTableCellConstraints()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        for subview in stackViewStarImage.arrangedSubviews{
            stackViewStarImage.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with nft: MyNFT){
        nftTitle.text = nft.title
        if let price = nft.price{
            nftPrice.text = "\(price)" + " ETH"
        }
        nftAuthor.text = nft.author
        let likeColor: UIColor = nft.isLike == false ?  .white :  .red
        nftLikeButton.tintColor = likeColor
        addStarRating(from: nft.rating ?? 0)
    }
    
    func addStarRating(from rating: Int){
        for index in 0...4 {
            stackViewStarImage.addArrangedSubview(UIImageView(image: UIImage(systemName:"star.fill")))
            stackViewStarImage.arrangedSubviews[index].tintColor = UIColor(hexString: "#e1e3e6")
            print(index)
        }
        for index in 0..<rating {
            stackViewStarImage.arrangedSubviews[index].tintColor = UIColor.yellow
        }
    }
    
    private func setupContentView(){
        contentView.addSubview(nftImage)
        nftImage.addSubview(nftLikeButton)
        contentView.addSubview(stackViewStarImage)
        contentView.addSubview(nftTitle)
        contentView.addSubview(nftAuthorOT)
        contentView.addSubview(nftAuthor)
        contentView.addSubview(nftPriceName)
        contentView.addSubview(nftPrice)
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        
    }
    private func setupTableCellConstraints(){
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            
            nftLikeButton.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 12),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: -11.36),
            nftLikeButton.heightAnchor.constraint(equalToConstant: 18),
            nftLikeButton.widthAnchor.constraint(equalToConstant: 21),
            
            nftTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            nftTitle.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            stackViewStarImage.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 4),
            stackViewStarImage.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            stackViewStarImage.heightAnchor.constraint(equalToConstant: 12),
            stackViewStarImage.widthAnchor.constraint(equalToConstant: 68),
            
            nftAuthorOT.topAnchor.constraint(equalTo: stackViewStarImage.bottomAnchor, constant: 4),
            nftAuthorOT.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            nftAuthor.topAnchor.constraint(equalTo: stackViewStarImage.bottomAnchor, constant: 4),
            nftAuthor.leadingAnchor.constraint(equalTo: nftAuthorOT.trailingAnchor, constant: 4),
            
            nftPriceName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33),
            nftPriceName.leadingAnchor.constraint(equalTo: nftPrice.leadingAnchor),
            
            nftPrice.topAnchor.constraint(equalTo: nftPriceName.bottomAnchor, constant: 4),
            nftPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39)
        ])
    }
    
}
