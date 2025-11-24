import UIKit

extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            self.init(white: 0.5, alpha: 1.0)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}


enum AppStyle {
    enum Colors {
        static let red = UIColor(hex: "#CC0000")
        static let blue = UIColor(hex: "#003368")

        static let textPrimary = UIColor(hex: "#003368")
        static let textSecondary = UIColor(hex: "#666666")

        static let backgroundLight = UIColor(hex: "#FFFFFF")
        static let backgroundDark = UIColor(hex: "#DDDDDD")
        static let background = UIColor(hex: "#F3F4F7")

        static let separator = UIColor(hex: "#A2A2A2")
        static let missingPhotoBackground = UIColor(#colorLiteral(red: 0.9492147565, green: 0.9493945241, blue: 0.9686219096, alpha: 1))
        static let missingPhotoOutline = UIColor(#colorLiteral(red: 0.7803739309, green: 0.7804554701, blue: 0.7996302247, alpha: 1))
        
    }

    enum Fonts {
        static let customFont = UIFont(name: "PTSans-Regular", size: 16)
        static let customBoldFont = UIFont(name: "PTSans-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
    }
}
