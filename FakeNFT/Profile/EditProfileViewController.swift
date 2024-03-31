
import UIKit

protocol EditProfileViewControllerDelegate: AnyObject {
    func updateProfile(from profile: Profile)
}

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    private var activeTextField: UITextField?
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    private let network = NetworkNFTService()
    
    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        profileImage.layer.cornerRadius =  profileImage.frame.width / 2
        profileImage.isUserInteractionEnabled = true
        profileImage.clipsToBounds = true
        return profileImage
    }()
    
    private lazy var editChangeImageLabel: UILabel = {
        let editDescriptionTextView = UILabel()
        editDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        editDescriptionTextView.font = .systemFont(ofSize: 10, weight: .medium)
        editDescriptionTextView.textColor = .white
        editDescriptionTextView.numberOfLines = 2
        editDescriptionTextView.textAlignment = .center
        editDescriptionTextView.lineBreakMode = .byWordWrapping
        editDescriptionTextView.text = """
           Сменить
           фото
           """
        editDescriptionTextView.layer.cornerRadius = editDescriptionTextView.frame.width / 2
        editDescriptionTextView.layer.borderWidth = 0
        editDescriptionTextView.layer.masksToBounds = true
        editDescriptionTextView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loadingNewImage))
        editDescriptionTextView.addGestureRecognizer(tapGesture)
        return editDescriptionTextView
    }()
    
    private lazy var editNameTitle: UILabel = {
        let profileNameTitle = UILabel()
        profileNameTitle.translatesAutoresizingMaskIntoConstraints = false
        profileNameTitle.font = .systemFont(ofSize: 22, weight: .bold)
        profileNameTitle.textColor = .black
        profileNameTitle.text = "Имя"
        return profileNameTitle
    }()
    
    private lazy var editNameTextField: UITextField = {
        let editNameTextField = UITextField()
        editNameTextField.translatesAutoresizingMaskIntoConstraints = false
        editNameTextField.placeholder = "Информация отсутствует"
        editNameTextField.backgroundColor = UIColor(hexString: "#F7F7F8")
        editNameTextField.font = .systemFont(ofSize: 17, weight: .medium)
        editNameTextField.textColor = .black
        editNameTextField.layer.cornerRadius = 12
        editNameTextField.layer.borderWidth = 0
        editNameTextField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: editNameTextField.frame.height))
        editNameTextField.leftView = paddingView
        editNameTextField.leftView = paddingView
        editNameTextField.leftViewMode = .always
        editNameTextField.rightView = clearButton
        
        editNameTextField.rightViewMode = .whileEditing
        editNameTextField.delegate = self
        return editNameTextField
    }()
    
    private lazy var editDescriptionTitle: UILabel = {
        let profileNameTitle = UILabel()
        profileNameTitle.translatesAutoresizingMaskIntoConstraints = false
        profileNameTitle.font = .systemFont(ofSize: 22, weight: .bold)
        profileNameTitle.textColor = .black
        profileNameTitle.text = "Описание"
        return profileNameTitle
    }()
    
    private lazy var editDescriptionTextView: UITextView = {
        let editDescriptionTextView = UITextView()
        editDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        editDescriptionTextView.backgroundColor = UIColor(hexString: "#F7F7F8")
        editDescriptionTextView.font = .systemFont(ofSize: 17, weight: .medium)
        editDescriptionTextView.isScrollEnabled = true
        editDescriptionTextView.textColor = .black
        editDescriptionTextView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        editDescriptionTextView.layer.cornerRadius = 12
        editDescriptionTextView.layer.borderWidth = 0
        editDescriptionTextView.layer.masksToBounds = true
        return editDescriptionTextView
    }()
    
    private lazy var editSiteTitle: UILabel = {
        let profileNameTitle = UILabel()
        profileNameTitle.translatesAutoresizingMaskIntoConstraints = false
        profileNameTitle.font = .systemFont(ofSize: 22, weight: .bold)
        profileNameTitle.textColor = .black
        profileNameTitle.text = "Сайт"
        return profileNameTitle
    }()
    
    private lazy var editSiteTextField: UITextField = {
        let editSiteTextField = UITextField()
        editSiteTextField.translatesAutoresizingMaskIntoConstraints = false
        editSiteTextField.placeholder = "Информация отсутствует"
        editSiteTextField.backgroundColor = UIColor(hexString: "#F7F7F8")
        editSiteTextField.font = .systemFont(ofSize: 17, weight: .medium)
        editSiteTextField.textColor = .black
        editSiteTextField.layer.cornerRadius = 12
        editSiteTextField.layer.borderWidth = 0
        editSiteTextField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: editSiteTextField.frame.height))
        editSiteTextField.leftView = paddingView
        editSiteTextField.leftViewMode = .always
        editSiteTextField.rightView = clearButton
        editSiteTextField.rightViewMode = .whileEditing
        editSiteTextField.delegate = self
        return editSiteTextField
    }()
    
    private lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .gray
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        return clearButton
    }()
    init(state: Profile) {
        super.init(nibName: nil, bundle: nil)
        profileImage.image = state.profileImage
        editNameTextField.text = state.profileName
        editDescriptionTextView.text = state.profileDescription
        editSiteTextField.text = state.profileSite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        addSubviews()
        setupConstraints()
        addGesture()
        addGestureLoadingNewImage()
    }
    
    private func setupNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissController))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc private func dismissController(){
        if editNameTextField.text != "", editDescriptionTextView.text != "", editSiteTextField.text != ""{
            delegate?.updateProfile(from: Profile(profileImage: profileImage.image,
                                                  profileName: editNameTextField.text,
                                                  profileDescription: editDescriptionTextView.text,
                                                  profileSite: editSiteTextField.text))
            dismiss(animated: true)
        }
  
    }
    
    @objc func clearTextField(_ textField: UITextField) {
        activeTextField?.text = ""
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    private func addGestureLoadingNewImage(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loadingNewImage))
        tapGesture.cancelsTouchesInView = false
        editChangeImageLabel.addGestureRecognizer(tapGesture)
     
    }
    
    @objc private func loadingNewImage(){
        print("загрузить изображение")
        let alertController = UIAlertController(title: .none, message: "Хотите загрузить новое изображение?", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите url изображение .jpg"
        }
        let downloadImage = UIAlertAction(title: "Загрузить новое изображение?", style: .default) { _ in
            UIBlockingProgressHUD.show()
            guard let textField = alertController.textFields?.first else {return}
            if let text = textField.text{
                DispatchQueue.main.async {
                    self.network.loadImageFromUrl(from: text){ imageView in
                        self.profileImage.image = imageView?.image ?? UIImage(systemName: "")
                        UIBlockingProgressHUD.dismiss()
//                    https://beautyhack.ru/assets/images/2019/10/phoenix_txt.jpg
                    }
                }}
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .destructive)
        
        alertController.addAction(downloadImage)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true)
    }
    
    private func addGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewShouldReturn))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func textViewShouldReturn(){
        editDescriptionTextView.resignFirstResponder()
        print("сброс")
    }
    
    private func addSubviews(){
        view.addSubview(profileImage)
        profileImage.addSubview(editChangeImageLabel)
        view.addSubview(editNameTitle)
        view.addSubview(editNameTextField)
        view.addSubview(editDescriptionTitle)
        view.addSubview(editDescriptionTextView)
        view.addSubview(editSiteTitle)
        view.addSubview(editSiteTextField)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            
            editNameTitle.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            editNameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            editNameTextField.topAnchor.constraint(equalTo: editNameTitle.bottomAnchor, constant: 8),
            editNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            editDescriptionTitle.topAnchor.constraint(equalTo: editNameTextField.bottomAnchor, constant: 24),
            editDescriptionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            editDescriptionTextView.topAnchor.constraint(equalTo: editDescriptionTitle.bottomAnchor, constant: 8),
            editDescriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editDescriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editDescriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            
            editSiteTitle.topAnchor.constraint(equalTo: editDescriptionTextView.bottomAnchor, constant: 24),
            editSiteTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            editSiteTextField.topAnchor.constraint(equalTo: editSiteTitle.bottomAnchor, constant: 8),
            editSiteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editSiteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editSiteTextField.heightAnchor.constraint(equalToConstant: 44),
            
            editChangeImageLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 23),
            editChangeImageLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 12),
            editChangeImageLabel.heightAnchor.constraint(equalToConstant: 24),
            editChangeImageLabel.widthAnchor.constraint(equalToConstant: 45),
            
        ])
    }
}
