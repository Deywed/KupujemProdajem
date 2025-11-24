import UIKit

class OglasTableViewCell: UITableViewCell {
    static let identifier = "OglasTableViewCell"

    private let summaryView = AdSummaryView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadData(_ ad: AdSummary) {
        summaryView.loadData(ad)
    }
}
