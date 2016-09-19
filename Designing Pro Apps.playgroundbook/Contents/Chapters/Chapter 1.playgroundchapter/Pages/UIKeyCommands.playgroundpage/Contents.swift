//#-hidden-code
import PlaygroundSupport
import UIKit
//#-end-hidden-code
class KeyController: BaseViewController {
/*:
`UIKit` will call `keyCommands` on all objects in the responder chain.
We need to make sure that our ViewController is in there.
*/
    override var canBecomeFirstResponder: Bool {
        return true
    }
/*:
Overriding `keyCommands` to add our key command to the available commands
*/
    override var keyCommands: [UIKeyCommand]? {
        return [
/*:
We tell the controller to trigger `keyPressed:` when `⌘K` is being pressed

*Note: In an app the keyboard shortcut sheet would display "Toggle" next to the key command. This is a limitation of Swift Playgrounds.*
*/
            UIKeyCommand(input: "K", modifierFlags: .command, action: #selector(keyPressed(key:)), discoverabilityTitle: "Toggle")
        ]
    }

    func keyPressed(key: UIKeyCommand) {
        counter += 1
    }
}

let controller = KeyController()
let navController = UINavigationController(rootViewController: controller)

PlaygroundPage.current.liveView = navController