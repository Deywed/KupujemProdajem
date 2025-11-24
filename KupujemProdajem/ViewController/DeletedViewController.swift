import UIKit

class DeletedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.background
        view.addSubview(deletedView)
        setupNavigationBar()
        setupUI()
    }

    private let deletedView = AdSummaryDeleted()
    private lazy var footerLabel: UILabel = self.createFooterLabel()

    private func setupUI() {
        view.addSubview(deletedView)
        deletedView.translatesAutoresizingMaskIntoConstraints = false
        deletedView.addSubview(footerLabel)

        NSLayoutConstraint.activate([
            
            deletedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            deletedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deletedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            footerLabel.topAnchor.constraint(equalTo: deletedView.bottomAnchor, constant: 40),
            footerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }
}
