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
 
 Additional Terms
 No part, or derivative of this Air Native Extensions's code is permitted
 to be sold as the basis of a commercially packaged Air Native Extension which
 undertakes the same purpose as this software. That is an ARKit wrapper for iOS.
 All Rights Reserved. Tua Rua Ltd.
 */

import Foundation
import ARKit

public extension SCNText {
    convenience init?(_ freObject: FREObject?) {
        guard
            let rv = freObject,
            let string = String(rv["string"]),
            let extrusionDepth = CGFloat(rv["extrusionDepth"]),
            let flatness = CGFloat(rv["flatness"]),
            let subdivisionLevel = Int(rv["subdivisionLevel"]),
            let chamferRadius = CGFloat(rv["chamferRadius"])
            else {
                return nil
        }
        self.init()
        self.string = string
        self.extrusionDepth = extrusionDepth
        self.flatness = flatness
        self.chamferRadius = chamferRadius
        self.subdivisionLevel = subdivisionLevel
        applyMaterials(rv["materials"])
    }
    
    func applyMaterials(_ value:FREObject?) {
        guard let freMaterials = value else { return }
        let freArray:FREArray = FREArray.init(freMaterials)
        guard freArray.length > 0 else { return }
        var mats = [SCNMaterial](repeating: SCNMaterial(), count: Int(freArray.length))
        for i in 0..<freArray.length {
            if let mat = SCNMaterial.init(freArray[i]) {
                mats[Int(i)] = mat
            }
        }
        self.materials = mats
    }
    
    func setProp(name:String, value:FREObject) {
        switch name {
        case "string":
            self.string = String(value) ?? self.string
            break
        case "extrusionDepth":
            self.extrusionDepth = CGFloat(value) ?? self.extrusionDepth
            break
        case "flatness":
            self.flatness = CGFloat(value) ?? self.flatness
            break
        case "chamferRadius":
            self.chamferRadius = CGFloat(value) ?? self.chamferRadius
            break
        case "subdivisionLevel":
            self.subdivisionLevel = Int(value) ?? self.subdivisionLevel
            break
        case "materials":
            applyMaterials(value)
            break
        default:
            break
        }
    }
    
    func toFREObject(nodeName:String?) -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.arane.shapes.Text")
            try ret?.setProp(name: "extrusionDepth", value: self.extrusionDepth.toFREObject())
            try ret?.setProp(name: "chamferRadius", value: self.chamferRadius.toFREObject())
            try ret?.setProp(name: "flatness", value: self.flatness.toFREObject())
            if let string = self.string as? String {
                try ret?.setProp(name: "string", value: string.toFREObject())
            }
            try ret?.setProp(name: "subdivisionLevel", value: self.subdivisionLevel.toFREObject())
            if materials.count > 0 {
                try ret?.setProp(name: "materials", value: materials.toFREObject(nodeName: nodeName))
            }
            //make sure to set this last as it triggers setANEvalue otherwise
            try ret?.setProp(name: "nodeName", value: nodeName)
            return ret
        } catch {
        }
        return nil
    }
    
}
