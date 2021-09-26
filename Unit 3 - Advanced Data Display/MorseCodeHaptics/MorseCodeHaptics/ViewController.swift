
import UIKit

class ViewController: UIViewController {
    
    enum PlayerMode: Int {
        case both, haptic, visual
    }
    
    @IBOutlet var playerModeSegmentedControl: UISegmentedControl!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var playButton: UIButton!
    
    var visualPlayerView: VisualMorseCodePlayerView {
        return view as! VisualMorseCodePlayerView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.text = "sos"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func playerModeSegmentedControlValueChanged(_ sender: UISegmentedControl) {

    }
    
    @IBAction func playMessage(_ sender: Any) {
        let text = messageTextField.text!
        if let message = MorseCodeMessage(message: text) {
            do {
                try visualPlayerView.play(message: message)
            } catch {
                presentErrorAlert(title: "no message", message: error.localizedDescription)
            }
            
        }
    }
    
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // hiding keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

