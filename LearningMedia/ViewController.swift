//
//  ViewController.swift
//  LearningMedia
//
//  Created by Tiến Việt Trịnh on 05/07/2023.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        queryData()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        requestAuthorzation()
    }
    
    func requestAuthorzation() {
        MPMediaLibrary.requestAuthorization { status in
            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                    let url = URL(string:UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url)
                }
            case .denied:
                DispatchQueue.main.async {
                    let url = URL(string:UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url)
                }
            case .restricted:
                break
            case .authorized:
                print("DEBUG: get Authorzation")
            @unknown default:
                return
            }
        }
    }
    
    func queryData() {
        let query = MPMediaQuery()
        let data = query.items
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
