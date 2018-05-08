//
//  TextBraille.swift
//  LearningBraille
//
//  Created by George Gomes on 19/03/18.
//  Copyright © 2018 George Gomes. All rights reserved.
//

import Foundation

typealias LetterBraille = (Bool,Bool,Bool,Bool,Bool,Bool)

struct StringBraille{

    var a : String!
    
    var letters: [LetterBraille]!
    
    init(a: String) {
        self.a = a
    }
    
//    init(_ letters: [LetterBraille]) {
//
//    }

    init(_ dict: [Bool]){
        var o: LetterBraille = LetterBraille(dict[0], dict[1], dict[2], dict[3], dict[4], dict[5] )
        self.letters = [o]
    }
    
}


extension StringBraille{
 
    func brailleConvert() -> String{
        let i = "asda"
        return i
    }
    
    func typeToProcess(_ word: Any) -> WordType {
        return .numeral
    }
    
    
}