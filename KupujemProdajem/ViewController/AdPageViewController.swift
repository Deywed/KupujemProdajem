import UIKit

class AdPageViewController: UIPageViewController {
    
    private let ads: [AdSummary]
    private let validDetailIDs: Set<String>
    
    private var currentIndex: Int

    init(ads: [AdSummary], initialIndex: Int, validDetailIDs: Set<String>) {
        self.ads = ads
        self.currentIndex = initialIndex
        self.validDetailIDs = validDetailIDs
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.background
        
        dataSource = self
        delegate = self

        if let initialVC = viewControllerAtIndex(currentIndex) {
            setViewControllers([initialVC], direction: .forward, animated: false)
        }

        setupNavigationBar()
    }

    private func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        guard index >= 0 && index < ads.count else { return nil }

        let ad = ads[index]
        
        let hasDetails = validDetailIDs.contains(ad.idString)

        let vc: UIViewController
        if !hasDetails {
            vc = DeletedViewController()
        } else {
            vc = DetailsViewController(ad: ad)
        }
        

        vc.view.tag = index
        
        return vc
    }
}

extension AdPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        return viewControllerAtIndex(index - 1)
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        return viewControllerAtIndex(index + 1)
    }
}

extension AdPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed, let visibleVC = pageViewController.viewControllers?.first {
            self.currentIndex = visibleVC.view.tag
        }
    }
}
