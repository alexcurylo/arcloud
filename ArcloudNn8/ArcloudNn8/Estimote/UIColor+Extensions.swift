//
// Please report any problems with this app template to contact@estimote.com
//

import Foundation
import UIKit

// Adds support for Estimote Colors to UIColor class.
extension UIColor {
    
    class func colorForEstimoteColor(_ estimoteColor: ESTColor) -> UIColor {
        
        switch estimoteColor {
        case ESTColor.icyMarshmallow:
            return UIColor(colorLiteralRed: 109/255.0, green: 170/255.0, blue: 199/255.0, alpha: 1.0)
            
        case ESTColor.blueberryPie:
            return UIColor(colorLiteralRed: 36/255.0, green: 24/255.0, blue: 93/255.0, alpha: 1.0)
            
        case ESTColor.candyFloss:
            return UIColor(colorLiteralRed: 219/255.0, green: 122/255.0, blue: 167/255.0, alpha: 1.0)
            
        case ESTColor.mintCocktail:
            return UIColor(colorLiteralRed: 155/255.0, green: 186/255.0, blue: 160/255.0, alpha: 1.0)
            
        case ESTColor.sweetBeetroot:
            return UIColor(colorLiteralRed: 84/255.0, green: 0/255.0, blue: 61/255.0, alpha: 1.0)
            
        case ESTColor.lemonTart:
            return UIColor(colorLiteralRed: 195/255.0, green: 192/255.0, blue: 16/255.0, alpha: 1.0)
            
        case ESTColor.coconutPuff:
            return UIColor.white
            
        default:
            return UIColor(colorLiteralRed: 160/255.0, green: 169/255.0, blue: 172/255.0, alpha: 1.0)
        }
    }
}
