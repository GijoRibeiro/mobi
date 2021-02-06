
import Foundation
import UIKit

extension LoginController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        //fetch sizes after orientation change
        DispatchQueue.main.async { [self] in
            
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                
            } else {
                print("Portrait")
            }
            
            configSliders()
        }
    }
}
