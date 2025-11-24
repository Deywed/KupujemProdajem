import UIKit

class DetailsViewController: UIViewController {
    let summary: AdSummary
    private var details: AdDetails?
    
    private lazy var footerLabel: UILabel = self.createFooterLabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()


    private let headerView = AdSummaryView()

    
    private let categoryContainer = UIView()
    private let categoryLabel = UILabel()
    private let categoryValueLabel = UILabel()

    
    private let descriptionContainer = UIView()
    private let descriptionLabel = UILabel()

    
    private let bigImageContainer = UIView()
    private let bigImageView = UIImageView()


    init(ad : AdSummary) {
        summary = ad
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppStyle.Colors.background
        

        setupLayout()
        setupData()
        setupNavigationBar()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])

        
        headerView.backgroundColor = .white
        headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 110).isActive = true
        
        stackView.addArrangedSubview(headerView)

        setupCategorySection()
        stackView.addArrangedSubview(categoryContainer)

        setupDescriptionSection()
        stackView.addArrangedSubview(descriptionContainer)

        setupBigImageSection()
        stackView.addArrangedSubview(bigImageContainer)

        stackView.addArrangedSubview(footerLabel)

        stackView.setCustomSpacing(40, after: bigImageContainer)
    }

    private func setupCategorySection() {
        categoryContainer.backgroundColor = .white
        categoryContainer.addSubview(categoryLabel)
        categoryContainer.addSubview(categoryValueLabel)

        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryValueLabel.translatesAutoresizingMaskIntoConstraints = false

        categoryLabel.text = "Kategorija:"
        categoryLabel.font = .systemFont(ofSize: 14)
        categoryLabel.textColor = .gray

        categoryValueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        categoryValueLabel.textColor = AppStyle.Colors.blue
        categoryValueLabel.numberOfLines = 0

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: categoryContainer.topAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: 16),
            categoryLabel.widthAnchor.constraint(equalToConstant: 80),

            categoryValueLabel.topAnchor.constraint(equalTo: categoryContainer.topAnchor, constant: 16),
            categoryValueLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 4),
            categoryValueLabel.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor, constant: -16),
            categoryValueLabel.bottomAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: -16),
        ])
    }

    private func setupDescriptionSection() {
        descriptionContainer.backgroundColor = .white

        descriptionContainer.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .black

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionContainer.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainer.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionContainer.bottomAnchor, constant: -16),
        ])
    }

    private func setupBigImageSection() {
        bigImageContainer.backgroundColor = .white

        bigImageContainer.addSubview(bigImageView)
        bigImageView.translatesAutoresizingMaskIntoConstraints = false
        bigImageView.contentMode = .scaleAspectFit
        bigImageView.backgroundColor = .white
        bigImageView.clipsToBounds = true

        NSLayoutConstraint.activate([
            bigImageView.topAnchor.constraint(equalTo: bigImageContainer.topAnchor, constant: 20),
            bigImageView.leadingAnchor.constraint(equalTo: bigImageContainer.leadingAnchor, constant: 20),
            bigImageView.trailingAnchor.constraint(equalTo: bigImageContainer.trailingAnchor, constant: -20),
            bigImageView.heightAnchor.constraint(equalToConstant: 300),
            bigImageView.bottomAnchor.constraint(equalTo: bigImageContainer.bottomAnchor, constant: -20),
        ])
    }

    private func setupData() {

        headerView.loadData(summary)

        guard let data = JsonService.loadData(),
              let foundDetails = data.detaljiOglasa.first(where: { $0.id == summary.idString }) else {
            return
        }

        details = foundDetails

        categoryValueLabel.text = "\(foundDetails.category) > \(foundDetails.group)"

        let customHTML = """
        <html>
        <head>
            <style>
                body {
                    font-family: 'PTSans-Regular', sans-serif;
                    font-size: 16px;
                }
                
                b, strong {
                    font-family: 'PTSans-Bold', sans-serif;
                    font-weight: normal;
                }
            </style>
        </head>
        <body>
            \(foundDetails.description)
        </body>
        </html>
        """

        descriptionLabel.attributedText = customHTML.htmlToAttributedString

        if let path = foundDetails.photosPath {

            let urlString = "https://kupujemprodajem.com/" + path

            guard let url = URL(string: urlString) else {
                bigImageContainer.isHidden = true
                return
            }

            Task {
                if let image = await loadImage(from: url) {
                    await MainActor.run {
                        self.bigImageView.image = image
                        self.bigImageContainer.isHidden = false
                    }
                } else {
                    await MainActor.run {
                        self.bigImageContainer.isHidden = true
                    }
                }
            }

        } else {
            bigImageContainer.isHidden = true
        }
    }

    private func loadImage(from url: URL) async -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard
                let http = response as? HTTPURLResponse,
                (200...299).contains(http.statusCode),
                let image = UIImage(data: data)
            else { return nil }

            return image
        } catch {
            return nil
        }
    }

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
}
