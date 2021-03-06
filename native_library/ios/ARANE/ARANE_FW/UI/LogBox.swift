/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
import UIKit

internal class LogBox: UITextView {

    convenience init(frame: CGRect, displayLogging: Bool) {
        self.init(frame: frame)
        self.isEditable = false
        self.isSelectable = false
        self.backgroundColor = UIColor.clear
        self.textColor = UIColor.green
        self.text = "Logging:"
        self.isHidden = !displayLogging
        self.isUserInteractionEnabled = false
    }
    
    func setText(value: String) {
        self.text.append("\n" + value)
        let bottom = self.contentSize.height - self.bounds.size.height
        self.setContentOffset(CGPoint(x: 0, y: bottom), animated: false)
    }
    
}
