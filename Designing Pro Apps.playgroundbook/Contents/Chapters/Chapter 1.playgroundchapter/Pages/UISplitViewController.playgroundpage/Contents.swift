//#-hidden-code
import PlaygroundSupport
import UIKit
//#-end-hidden-code
class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    init() {
        super.init(nibName: nil, bundle: nil)
        let mainViewController = MainViewController()
        let mainNavController = UINavigationController(rootViewController: mainViewController)
/*:
We create an empty DetailViewController which conforms to `DetailViewable` an empty protocol. This is helpful, so we don't have to check for each individual class later when seperating view controllers into master and detail.
*/
        let detailController = DetailViewController(labelText: DEFAULT_LABEL_TEXT)
        let detailNavController = UINavigationController(rootViewController: detailController)

        delegate = self
        viewControllers = [mainNavController, detailNavController]
        preferredDisplayMode = .allVisible
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
/*:
This would modify the behaviour of `splitViewController?.show(vc, sender: self)` but we are ok with the default behaviour.
*/
    func splitViewController(_ splitViewController: UISplitViewController, show vc: UIViewController, sender: Any?) -> Bool {
        return false
    }
/*:
If the splitViewController is collapsed we do it like a navigation controller and just push the detail view controller

If the splitViewController is not collapsed we replace the existing detail view controller with the new one
*/
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        if splitViewController.isCollapsed == false {
            let navController = splitViewController.viewControllers[1] as! UINavigationController
            navController.setViewControllers([vc], animated: false)
        } else {
            let navController = splitViewController.viewControllers[0] as! UINavigationController
            navController.pushViewController(vc, animated: true)
        }
        return true
    }
/*:
This is called when the size class changed dramatically, i.e. going from landscape to portrait on iPhone 6 Plus.

We take all detail view controllers (if something meaningful is in them) and push them onto the main navigation controller.
*/
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        let primaryNavController = primaryViewController as! UINavigationController
        let secondaryNavController = secondaryViewController as! UINavigationController
        let secondaryViewController = secondaryNavController.viewControllers.first
        if let detailViewController = secondaryViewController as? DetailViewController {
            if detailViewController.labelText == DEFAULT_LABEL_TEXT {
                return true
            }
        }

        var newPrimaryViewControllers: [UIViewController] = primaryNavController.viewControllers
        newPrimaryViewControllers.append(contentsOf: secondaryNavController.viewControllers)
        primaryNavController.viewControllers = newPrimaryViewControllers

        return true
    }
/*:
This is called when the size class changed dramatically, i.e. going from portrait to landscape on iPhone 6 Plus.

We iterate over all view controllers on the main navigation controller and put all that conform to `DetailViewable`, an empty protocol, in the detail view of our split view controller
*/
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        let primaryNavigationController = primaryViewController as! UINavigationController
        var newPrimaryViewControllers = [UIViewController]()
        var newSecondaryViewControllers = [UIViewController]()

        primaryNavigationController.viewControllers.forEach { controller in
            if let _ = controller as? DetailViewable {
                newSecondaryViewControllers.append(controller)
            } else {
                newPrimaryViewControllers.append(controller)
            }
        }
/*:
If we don't have any detail view controllers in the main navigation controller we create an empty one.
*/
        if newSecondaryViewControllers.count == 0 {
            let detailController = DetailViewController(labelText: DEFAULT_LABEL_TEXT)
            let navController = UINavigationController(rootViewController: detailController)
            return navController
        }

        primaryNavigationController.viewControllers = newPrimaryViewControllers

        let detailNavController = UINavigationController()
        detailNavController.viewControllers = newSecondaryViewControllers
        return detailNavController
    }
}

let splitViewController = SplitViewController()
PlaygroundPage.current.liveView = splitViewController