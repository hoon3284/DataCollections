
import UIKit
import CoreHaptics

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
    
    var activeMorseCodePlayers: [MorseCodePlayer] = []
    var hapticsPlayer: HapticsMorseCodePlayer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.text = "sos"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CHHapticEngine.capabilitiesForHardware().supportsHaptics == true {
            do {
                hapticsPlayer = try HapticsMorseCodePlayer()
                configurePlayers(mode: .both)
            } catch {
                presentErrorAlert(title: "Haptics Error", message: "Failed to start haptics engine.")
                configurePlayers(mode: .visual)
            }
        } else {
            playerModeSegmentedControl.isHidden = /*false 책에 false로 되어 있지만 true가 맞는 것 같다.*/ true
            configurePlayers(mode: .visual)
        }
    }
    
    
    @IBAction func playerModeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        configurePlayers(mode: PlayerMode(rawValue: sender.selectedSegmentIndex)!)
    }
    
    @IBAction func playMessage(_ sender: Any) {
        let text = messageTextField.text!
        if let message = MorseCodeMessage(message: text) {
            do {
                try activeMorseCodePlayers.forEach { try $0.play(message: message) }
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
    
    func configurePlayers(mode: PlayerMode) {
        switch mode {
        case .both:
            if let hapticsPlayer = hapticsPlayer {
                activeMorseCodePlayers = [hapticsPlayer, visualPlayerView]
            } else {
                activeMorseCodePlayers = [visualPlayerView]
            }
        case .haptic:
            if let hapticsPlayer = hapticsPlayer {
                activeMorseCodePlayers = [hapticsPlayer]
            } else {
                activeMorseCodePlayers = [visualPlayerView]
            }
        case .visual:
            activeMorseCodePlayers = [visualPlayerView]
        }
    }
}

// 얼추 된거 같지만 코드가 굉장히 맘에 들지 않는다.
// 꼭 다시봐야할거같다.
