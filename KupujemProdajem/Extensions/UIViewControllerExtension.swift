import UIKit

extension UIViewController {
    func setupNavigationBar() {
        let logoImage = UIImage(named: "KupujemProdajem_logo_RGB")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = imageView
    }

    func createFooterLabel() -> UILabel {
        let lbl = UILabel()
        lbl.text = "KupujemProdajem © 2022 All rights reserved"
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.heightAnchor.constraint(equalToConstant: 60).isActive = true

        return lbl
    }
}
