//
//  Extensions.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 10/7/2564 BE.
//

import Foundation
import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var right: CGFloat {
        return frame.origin.x + width
    }
    var bottom: CGFloat {
        return frame.origin.y + height
    }
    var left: CGFloat {
        return frame.origin.x
    }
}
