
import UIKit

class MyNFTTableViewCell: UITableViewCell {
    
    private lazy var nftImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 12
        profileImage.clipsToBounds = true
        profileImage.image = UIImage(systemName: "person.crop.circle.fill")
        return profileImage
    }()
    private lazy var nftLikeImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
        profileImage.image = UIImage(systemName: "heart")
        return profileImage
    }()
    private lazy var starImage1: UIImageView = {
        let starImage = UIImageView()
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.clipsToBounds = true
        starImage.image = UIImage(systemName: "star.fill")
        return starImage
    }()
    private lazy var starImage2: UIImageView = {
        let starImage = UIImageView()
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.clipsToBounds = true
        starImage.image = UIImage(systemName: "star.fill")
        return starImage
    }()
    private lazy var starImage3: UIImageView = {
        let starImage = UIImageView()
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.clipsToBounds = true
        starImage.image = UIImage(systemName: "star.fill")
        return starImage
    }()
    private lazy var starImage4: UIImageView = {
        let starImage = UIImageView()
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.clipsToBounds = true
        starImage.image = UIImage(systemName: "star.fill")
        return starImage
    }()
    private lazy var starImage5: UIImageView = {
        let starImage = UIImageView()
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.clipsToBounds = true
        starImage.image = UIImage(systemName: "star.fill")
        return starImage
    }()
    lazy var nftTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    lazy var nftAuthorOT: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "от"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    lazy var nftAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    lazy var nftPriceName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Цена"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    lazy var nftPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupTableCellConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupContentView(){
        contentView.addSubview(nftImage)
        nftImage.addSubview(nftLikeImage)
        contentView.addSubview(starImage1)
        contentView.addSubview(starImage2)
        contentView.addSubview(starImage3)
        contentView.addSubview(starImage4)
        contentView.addSubview(starImage5)
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
            
            nftLikeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftLikeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftLikeImage.heightAnchor.constraint(equalToConstant: 42),
            nftLikeImage.widthAnchor.constraint(equalToConstant: 42),
            
            nftTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            nftTitle.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            starImage1.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 4),
            starImage1.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            starImage1.heightAnchor.constraint(equalToConstant: 12),
            starImage1.widthAnchor.constraint(equalToConstant: 12),
            
            starImage2.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 4),
            starImage2.leadingAnchor.constraint(equalTo: starImage1.trailingAnchor),
            starImage2.heightAnchor.constraint(equalToConstant: 12),
            starImage2.widthAnchor.constraint(equalToConstant: 12),
            
            starImage3.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 4),
            starImage3.leadingAnchor.constraint(equalTo: starImage2.trailingAnchor),
            starImage3.heightAnchor.constraint(equalToConstant: 12),
            starImage3.widthAnchor.constraint(equalToConstant: 12),
            
            starImage4.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 4),
            starImage4.leadingAnchor.constraint(equalTo: starImage3.trailingAnchor),
            starImage4.heightAnchor.constraint(equalToConstant: 12),
            starImage4.widthAnchor.constraint(equalToConstant: 12),
            
            starImage5.topAnchor.constraint(equalTo: nftTitle.bottomAnchor, constant: 4),
            starImage5.leadingAnchor.constraint(equalTo: starImage4.trailingAnchor),
            starImage5.heightAnchor.constraint(equalToConstant: 12),
            starImage5.widthAnchor.constraint(equalToConstant: 12),
            
            nftAuthorOT.topAnchor.constraint(equalTo: starImage1.bottomAnchor, constant: 4),
            nftAuthorOT.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            nftAuthor.topAnchor.constraint(equalTo: starImage1.bottomAnchor, constant: 4),
            nftAuthor.leadingAnchor.constraint(equalTo: nftAuthorOT.trailingAnchor, constant: 4),
            
            nftPriceName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 33),
            nftPriceName.leadingAnchor.constraint(equalTo: nftPrice.leadingAnchor),
            
            nftPrice.topAnchor.constraint(equalTo: nftPriceName.bottomAnchor, constant: 4),
            nftPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39)
        ])
    }
    
}
