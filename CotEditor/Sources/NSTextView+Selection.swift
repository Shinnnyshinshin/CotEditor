//
//  NSTextView+Selection.swift
//
//  CotEditor
//  https://coteditor.com
//
//  Created by 1024jp on 2018-02-22.
//
//  ---------------------------------------------------------------------------
//
//  © 2018 1024jp
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Cocoa

extension NSTextView {
    
    /// character just before the insertion or 0
    var characterBeforeInsertion: UnicodeScalar? {
        
        let location = self.selectedRange.location - 1
        
        guard location >= 0 else { return nil }
        
        guard let index = String.UTF16Index(encodedOffset: location).samePosition(in: self.string.unicodeScalars) else { return nil }
        
        return self.string.unicodeScalars[safe: index]
    }
    
    
    /// character just after the insertion
    var characterAfterInsertion: UnicodeScalar? {
        
        let location = self.selectedRange.location
        
        guard let index = String.UTF16Index(encodedOffset: location).samePosition(in: self.string.unicodeScalars) else { return nil }
        
        return self.string.unicodeScalars[safe: index]
    }
    
    
    /// location of the beginning of the current visual line considering indent
    func locationOfBeginningOfLine(for range: NSRange) -> Int {
        
        let string = self.string as NSString
        let currentLocation = range.location
        let lineRange = string.lineRange(for: range)
        
        if let layoutManager = self.layoutManager, currentLocation > 0 {
            // beginning of current visual line
            let visualLineLocation = layoutManager.lineFragmentRange(at: currentLocation - 1).location
            
            if lineRange.location < visualLineLocation {
                return visualLineLocation
            }
        }
        
        // column just after indent of paragraph line
        let indentLocation = string.range(of: "^[\t ]*", options: .regularExpression, range: lineRange).upperBound
        
        return (indentLocation < currentLocation) ? indentLocation : lineRange.location
    }
    
}
