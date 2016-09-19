// This is the preamble that is shared among all the pages within this chapter.
import UIKit
import PlaygroundSupport

open class BaseViewController: UIViewController {
    public var counter: Int {
      didSet {
        self.label.text = String(counter)
      }
    }

    public var labelText: String {
        set {
            self.label.text = labelText
        }
        get {
            return label.text ?? ""
        }
    }

    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public init() {
        self.counter = 0
        super.init(nibName: nil, bundle: nil)
    }

    public init(labelText: String) {
        self.counter = 0
        super.init(nibName: nil, bundle: nil)
        self.label.text = labelText
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(label)
        setupConstraints()
    }

    func setupConstraints() {
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

public protocol DetailViewable {}
public var DEFAULT_LABEL_TEXT: String {
  return "This page intentionally left blank"
}

public class DetailViewController: BaseViewController, DetailViewable {
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
    }
}

public class MainViewController: UITableViewController {
    let array: [String] = ["one", "two", "three", "four", "five"]

    override public  func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let value = array[indexPath.row]
        cell.textLabel?.text = value
        return cell
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = array[indexPath.row]
        let detailViewController = DetailViewController(labelText: value)
        splitViewController?.showDetailViewController(detailViewController, sender: self)
    }
}