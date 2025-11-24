import UIKit

class AdSummaryView: UIView {
    
    private let adImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let favoriteImage: UIImageView = {
        let iv = UIImageView()

        // Ovde sam koristio sistemsku zvezdu jer iz nekog razloga nije hteo
        // da prikaze onu koja se nalazi u figmi

        iv.image = UIImage(systemName: "star")
        iv.tintColor = AppStyle.Colors.blue
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let adTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = AppStyle.Fonts.customFont
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adPrice: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = AppStyle.Fonts.customBoldFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private let adLocation: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = AppStyle.Fonts.customFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        backgroundColor = .white
        addSubview(adImage)
        addSubview(favoriteImage)
        addSubview(adTitle)
        addSubview(adPrice)
        addSubview(adLocation)

        let imageBottomConstraint = adImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        imageBottomConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            adImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            adImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            adImage.widthAnchor.constraint(equalToConstant: 96),
            adImage.heightAnchor.constraint(equalToConstant: 90),
            imageBottomConstraint,

            favoriteImage.topAnchor.constraint(equalTo: adImage.topAnchor),
            favoriteImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            favoriteImage.widthAnchor.constraint(equalToConstant: 30),
            favoriteImage.heightAnchor.constraint(equalToConstant: 30),

            adTitle.leadingAnchor.constraint(equalTo: adImage.trailingAnchor, constant: 10),
            adTitle.topAnchor.constraint(equalTo: adImage.topAnchor, constant: -2),
            adTitle.trailingAnchor.constraint(equalTo: favoriteImage.leadingAnchor, constant: -8),

            adLocation.leadingAnchor.constraint(equalTo: adTitle.leadingAnchor),
            adLocation.topAnchor.constraint(equalTo: adTitle.bottomAnchor, constant: 4),
            adLocation.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            adPrice.leadingAnchor.constraint(equalTo: adTitle.leadingAnchor),
            adPrice.bottomAnchor.constraint(equalTo: adImage.bottomAnchor),
        ])
    }


    func loadData(_ ad: AdSummary) {
        adTitle.text = ad.title
        let time = ad.posted.calculateTime()
        adLocation.text = "\(ad.location), \(time)"

        let adCurrency = ad.currency
        let formatedAdCurrency: String
        let formatedAdPrice: String

        if adCurrency == "eur" {
            formatedAdCurrency = "€"
            formatedAdPrice = ad.price.replacingOccurrences(of: ".", with: ",")
        } else {
            formatedAdCurrency = "din"
            formatedAdPrice = ad.price.replacingOccurrences(of: ",", with: ".")
        }

        adPrice.text = "\(formatedAdPrice) \(formatedAdCurrency)"

        let isFollowing = ad.isFollowingAd ?? false

        if isFollowing {
            favoriteImage.image = UIImage(systemName: "star.fill")
        } else {
            favoriteImage.image = UIImage(systemName: "star")
        }

        let imagePath = "https://kupujemprodajem.com\(ad.thumbnailPath!)"

        Task {
            await getServerImage(urlString: imagePath)
        }
    }

    private func getServerImage(urlString: String) async {
        let url = URL(string: urlString)

        do {
            let (data, response) = try await URLSession.shared.data(from: url!)

            guard
                let http = response as? HTTPURLResponse,
                (200 ... 299).contains(http.statusCode),
                let image = UIImage(data: data)
            else {
                await MainActor.run { self.setupPlaceholderPhoto() }
                return
            }

            await MainActor.run {
                self.adImage.image = image
                self.adImage.contentMode = .scaleAspectFill
            }

        } catch {
            await MainActor.run { self.setupPlaceholderPhoto() }
        }
    }
    

    private func setupPlaceholderPhoto() {
        let cameraIcon = UIImage(systemName: "camera")
        adImage.image = cameraIcon
        adImage.tintColor = AppStyle.Colors.missingPhotoOutline
        adImage.backgroundColor = AppStyle.Colors.missingPhotoBackground
        adImage.contentMode = .scaleAspectFit
    }
}

extension String {
    private static let AdDateFormmater: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }()

    func calculateTime() -> String {

        guard let postedDate = String.AdDateFormmater.date(from: self) else {
            return "unknwow date"
        }

        let now = Date()
        let calendar = Calendar.current

        let components = calendar.dateComponents([.year, .month, .day], from: postedDate, to: now)

        if let years = components.year, years > 0 {
            return years == 1 ? "pre godinu dana" : "pre \(years) godina"
        }

        if let months = components.month, months > 0 {
            return months == 1 ? "pre mesec dana" : "pre \(months) meseci"
        }

        if let days = components.day, days > 0 {
            return days == 1 ? "juce" : "pre \(days) dana"
        }

        return "danas"
    }
}
