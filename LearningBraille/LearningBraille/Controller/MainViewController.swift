//
//  ViewController.swift
//  LearningBraille
//
//  Created by George Gomes on 09/03/18.
//  Copyright © 2018 George Gomes. All rights reserved.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController{
    

    
    var stBraille: String!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        stBraille = "AA a aA a2 2a G2 GG2"
     
        let sttt = stBraille.convertToBraille()
        
        for words in sttt.words{
            if(words == [false,false,false,false,false,false,]){
                print("")
                print("")
            }else{
                
                print(words)
            }
        }
        
    }


}


