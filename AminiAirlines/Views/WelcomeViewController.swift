//
//  WelcomeViewController.swift
//  AminiAirlines
//
//  Created by Rose Maina on 17/06/2019.
//  Copyright © 2019 rose maina. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var welcomeImageView: UIImageView!
    @IBOutlet weak var welcomeMessageView: UIView!
    @IBOutlet weak var loginBottomConstraint: NSLayoutConstraint!
    
    let baseURL = URL(string: "https://api.lufthansa.com/v1")
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateViews()
    }
}

extension WelcomeViewController {
    //    IBActions and Methods
    @IBAction func login(_ sender: Any) {
        self.loginActivityIndicator.isHidden = false
        self.loginActivityIndicator.startAnimating()
        
        let header = ["Content-Type": "application/x-www-form-urlencoded"]
        
        // Can be refactored and abstracted
        ClientService.standard.post(url: "/oauth/token",
                                    headers: header,
                                    data: nil) { status, data in
                                        if status {
                                            if let data = data {
                                                print("Test data: \(data)", "type of: \(type(of: data))")
                                                let credDecoder = JSONDecoder()
                                                do {
                                                    let credResults = try credDecoder.decode(Credencials.self, from: data)
                                                    self.defaults.set(credResults.accessToken, forKey: "token")
                                                    DispatchQueue.main.async {
                                                        self.loginActivityIndicator.stopAnimating()
                                                        self.loginActivityIndicator.hidesWhenStopped = true
                                                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                                    }
                                                } catch {
                                                    print("Failed to decode!")
                                                }
                                            }
                                        }
        }
    }
    
    func animateViews() {
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       options: .curveEaseOut,
                       animations: {
                        self.welcomeImageView.transform = CGAffineTransform.identity
                        self.loginButton.isHidden = false
                        self.view.layer.layoutIfNeeded()
        },
                       completion: nil)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0.9,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseInOut,
                       animations: {
                        self.loginBottomConstraint.constant = 36
                        self.view.layer.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    func setupViews() {
        self.loginActivityIndicator.isHidden = true
        self.loginButton.isHidden = true
        self.loginBottomConstraint.constant = -45
        self.welcomeMessageView.layer.cornerRadius = welcomeMessageView.frame.size.width/2
        self.welcomeMessageView.clipsToBounds = true
        self.welcomeImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
}
