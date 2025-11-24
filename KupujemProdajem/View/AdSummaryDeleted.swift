import UIKit

class AdSummaryDeleted: UIView {
    private let deletedImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "imageDeleted")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let adTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Oglas je obrisan"
        label.font = AppStyle.Fonts.customFont
        label.textColor = AppStyle.Colors.separator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let favoriteIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star")
        iv.tintColor = AppStyle.Colors.separator
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }


    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(deletedImage)
        addSubview(adTitle)
        addSubview(favoriteIcon)

        NSLayoutConstraint.activate([
            deletedImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            deletedImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            deletedImage.widthAnchor.constraint(equalToConstant: 96),
            deletedImage.heightAnchor.constraint(equalToConstant: 90),
            deletedImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),

            favoriteIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            favoriteIcon.topAnchor.constraint(equalTo: deletedImage.topAnchor),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 24),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 24),

            adTitle.leadingAnchor.constraint(equalTo: deletedImage.trailingAnchor, constant: 12),
            adTitle.trailingAnchor.constraint(lessThanOrEqualTo: favoriteIcon.leadingAnchor, constant: -8),
            adTitle.topAnchor.constraint(equalTo: deletedImage.topAnchor),

        ])
    }
}
