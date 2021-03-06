import UIKit
import EventSource

fileprivate func basicAuth(_ username: String, password: String) -> String {
    let authString = "\(username):\(password)"
    let authData = authString.data(using: String.Encoding.utf8)
    let base64String = authData!.base64EncodedString(options: [])

    return "Basic \(base64String)"
}

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var status: UILabel!
    @IBOutlet fileprivate weak var dataLabel: UILabel!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var idLabel: UILabel!
    @IBOutlet fileprivate weak var squareConstraint: NSLayoutConstraint!
    var eventSource: EventSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        let server = "http://127.0.0.1:8080/sse"
        let username = "fe8b0af5-1b50-467d-ac0b-b29d2d30136b"
        let password = "ae10ff39ca41dgf0a8"

        let basicAuthAuthorization = basicAuth(username, password: password)

        self.eventSource = EventSource(url: server, headers: ["Authorization" : basicAuthAuthorization])

        self.eventSource?.onOpen {
            self.status.backgroundColor = UIColor(red: 166/255, green: 226/255, blue: 46/255, alpha: 1)
            self.status.text = "CONNECTED"
        }

        self.eventSource?.onError { (error) in
            self.status.backgroundColor = UIColor(red: 249/255, green: 38/255, blue: 114/255, alpha: 1)
            self.status.text = "DISCONNECTED"
        }

        self.eventSource?.onEventDispatched { event in
            self.updateLabels(event.lastEventId, event: event.type, data: event.data)
        }

        self.eventSource?.addListenerForEvent(withType: "user-connected") { event in
            self.updateLabels(event.lastEventId, event: event.type, data: event.data)
        }

//        eventSource.close()
    }

    func updateLabels(_ id: String?, event: String?, data: String?) -> Void {
        self.idLabel.text = ""
        self.idLabel.text = ""
        self.idLabel.text = ""

        if let eventID = id {
            self.idLabel.text = eventID
        }

        if let eventName = event {
            self.nameLabel.text = eventName
        }

        if let eventData = data {
            self.dataLabel.text = eventData
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let finalPosition = self.view.frame.size.width - 50

        self.squareConstraint.constant = 0
        self.view.layoutIfNeeded()

        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [UIViewKeyframeAnimationOptions.repeat, UIViewKeyframeAnimationOptions.autoreverse], animations: { () in
            self.squareConstraint.constant = finalPosition
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
