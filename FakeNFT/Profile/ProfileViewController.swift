
import UIKit
import WebKit

class ProfileViewController: UIViewController {
    
    private let profile: Profile = .init(profileImage: UIImage(systemName: "person.crop.circle.fill"), profileName: "Alex",
                                         profileDescription: "В правом верхнем углу экрана находится кнопка редактирования профиля. Нажав на нее, пользователь видит всплывающий экран, на котором может отредактировать имя пользователя, описание, сайт и ссылку на изображение. Загружать само изображение через приложение не нужно, обновляется только ссылка на изображение.", profileSite: "https://github.com/yandex-practicum-ios/fakenft")
    private let categories = ["Мои NFT (112)","Избранные NFT","О разработчике"]
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius =  profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        profileImage.image = UIImage(systemName: "person.crop.circle.fill")
        return profileImage
    }()
    
    private lazy var profileNameTitle: UILabel = {
        let profileNameTitle = UILabel()
        profileNameTitle.translatesAutoresizingMaskIntoConstraints = false
        profileNameTitle.font = .systemFont(ofSize: 22, weight: .bold)
        profileNameTitle.textColor = .black
        profileNameTitle.text = "Joaquin Phoenix"
        return profileNameTitle
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.text = "Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."
        descriptionTextView.font = .systemFont(ofSize: 13, weight: .medium)
        descriptionTextView.textColor = .black
        descriptionTextView.backgroundColor = .white
        return descriptionTextView
    }()
    
    private lazy var profileWebTitle: UILabel = {
        let profileWebTitle = UILabel()
        profileWebTitle.translatesAutoresizingMaskIntoConstraints = false
        profileWebTitle.textColor = .blue
        profileWebTitle.font = .systemFont(ofSize: 15, weight: .bold)
        profileWebTitle.text = "https://ru.pinterest.com/pin/799811215061781948/"
        
        profileWebTitle.isUserInteractionEnabled = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileWebTitleTapped))
        profileWebTitle.addGestureRecognizer(tapGesture)
        
        return profileWebTitle
    }()
    
    private lazy var profileTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        profileTableView.rowHeight = 54
        profileTableView.isScrollEnabled = false
        profileTableView.delegate = self
        profileTableView.separatorColor = .white
        profileTableView.dataSource = self
        profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        return profileTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        addSubviews()
        setupConstraints()
    }
    
    @objc private func editProfileInfo(){
        let editProfileInfoNav = EditProfileViewController(state: .init(
            profileImage: profileImage.image,
            profileName: profileNameTitle.text,
            profileDescription: descriptionTextView.text,
            profileSite: profileWebTitle.text))
        editProfileInfoNav.delegate = self
        let navController = UINavigationController(rootViewController: editProfileInfoNav)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func profileWebTitleTapped() {
        
        let profileWebView = ProfileWebViewController()
        profileWebView.profileWebText = profileWebTitle.text
        self.navigationController?.pushViewController(profileWebView, animated: true)
    }
    
    private func setupNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editProfileInfo))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func addSubviews(){
        view.addSubview(profileImage)
        view.addSubview(profileNameTitle)
        view.addSubview(descriptionTextView)
        view.addSubview(profileWebTitle)
        view.addSubview(profileTableView)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 105),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            
            profileNameTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 129),
            profileNameTitle.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            
            descriptionTextView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 72),
            descriptionTextView.widthAnchor.constraint(equalToConstant: 341),
            
            profileWebTitle.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 12),
            profileWebTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileTableView.topAnchor.constraint(equalTo: profileWebTitle.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 304)
            
        ])
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.title.text = categories[indexPath.row]
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .black
        cell.accessoryView = chevronImageView
        return cell
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath), let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            return !cell.frame.contains(tableView.rectForRow(at: indexPathForSelectedRow).origin)
        }
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let NFTNav = MyNFTViewController()
            self.navigationController?.pushViewController(NFTNav, animated: true)
            
        }
        if indexPath.row == 1 {
            let favouritesNav = FavouritesViewController()
            self.navigationController?.pushViewController(favouritesNav, animated: true)
            
        }
        if indexPath.row == 2 {
            let profileWebView = ProfileWebViewController()
            profileWebView.profileWebText = profileWebTitle.text
            self.navigationController?.pushViewController(profileWebView, animated: true)
        }
    }
}
extension ProfileViewController: EditProfileViewControllerDelegate {
    func updateProfile(from profile: Profile) {
        profileImage.image = profile.profileImage
        profileNameTitle.text = profile.profileName
        descriptionTextView.text = profile.profileDescription
        profileWebTitle.text = profile.profileSite
    }
}
