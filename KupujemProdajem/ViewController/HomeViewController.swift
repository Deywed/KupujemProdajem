import UIKit

class HomeViewController: UIViewController {

    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var allAdsSource: [AdSummary] = []
    private var displayedAds: [AdSummary] = []
    
    
    private var validDetailIDs: Set<String> = []
    
    private var isLoading = false
    private let itemsPerPage = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTable()
        loadData()
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .white

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110
        
        tableView.register(OglasTableViewCell.self, forCellReuseIdentifier: OglasTableViewCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func loadData() {
        if let data = JsonService.loadData() {
            
            self.allAdsSource = data.listaOglasa.flatMap { $0.ads }
            self.validDetailIDs = Set(data.detaljiOglasa.map { $0.id })
            
            loadNextBatch()
        }
    }
    
    private func loadNextBatch() {

        guard !isLoading, displayedAds.count < allAdsSource.count else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let startIndex = self.displayedAds.count
            let endIndex = min(startIndex + self.itemsPerPage, self.allAdsSource.count)
            
            let newItems = Array(self.allAdsSource[startIndex..<endIndex])
            self.displayedAds.append(contentsOf: newItems)
            
            self.tableView.reloadData()
            self.isLoading = false
            self.updateFooter()
            
        }
    }
    
    private func updateFooter() {
        if displayedAds.count >= allAdsSource.count {
            tableView.tableFooterView = nil
        } else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.center = footerView.center
            spinner.startAnimating()
            footerView.addSubview(spinner)
            tableView.tableFooterView = footerView
        }
    }
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedAds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OglasTableViewCell.identifier, for: indexPath) as? OglasTableViewCell else {
            return UITableViewCell()
        }
        let ad = displayedAds[indexPath.row]
        cell.loadData(ad)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == displayedAds.count - 1 {
            loadNextBatch()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pageVC = AdPageViewController(
            ads: allAdsSource,
            initialIndex: indexPath.row,
            validDetailIDs: validDetailIDs
        )
        navigationController?.pushViewController(pageVC, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
