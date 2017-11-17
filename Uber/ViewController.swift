//
//  ViewController.swift
//  Uber
//
//  Created by Michael Roloff on 11/15/17.
//  Copyright © 2017 michaelroloff. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var riderDriverSwitch: UISwitch!
    
    @IBOutlet var topButton: UIButton!
    
    @IBOutlet var bottomButton: UIButton!
    
    @IBOutlet var riderLabel: UILabel!
    
    @IBOutlet var driverLabel: UILabel!
    
    var signUpMode = true
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.blue
    }
    
    @IBAction func topTapped(_ sender: Any) {
        
        if emailTextField.text == "" ||  passwordTextField.text == "" {
            displayAlert(title: "missing information", message: "you must provide both and email and password ")
            
            
            
            
        } else {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    
                    
                    
                    
                    if signUpMode {
                        //SIGNUP
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                                
                                
                            } else {
                                if self.riderDriverSwitch.isOn {
                                    //Driver
                                    let req =  Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Driver"
                                    
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                    
                                    
                                    
                                } else {
                                    //RIDER
                                    let req =  Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Rider"
                                    
                                    req?.commitChanges(completion: nil)
                                    
                                    
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                        })
                        
                        
                    } else {
                        //LOGIN
                        
                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                                
                                
                            } else {
                                if user?.displayName == "Driver" {
                                    //driver
                                    
                                    self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                    
                                }else {
                                    //rider/
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                    
                                }
                                
                            }
                            
                        })
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
        
    }
    
    func displayAlert(title: String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    
    
    
    @IBAction func bottomTapped(_ sender: Any) {
        
        if signUpMode {
            
            topButton.setTitle("Log in", for: .normal)
            bottomButton.setTitle("Switch to Sign up", for: .normal)
            
            riderLabel.isHidden = true
            driverLabel.isHidden = true
            riderDriverSwitch.isHidden = true
            signUpMode = false
            
            
        } else {
            topButton.setTitle("Sign up", for: .normal)
            bottomButton.setTitle("Switch to Log in", for: .normal)
            
            riderLabel.isHidden = false
            driverLabel.isHidden = false
            riderDriverSwitch.isHidden = false
            
            signUpMode = true
            
            
        }
        
        
    }
    
    
    
}
