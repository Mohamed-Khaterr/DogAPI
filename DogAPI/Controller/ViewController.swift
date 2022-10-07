//
//  ViewController.swift
//  DogAPI
//
//  Created by Khater on 10/5/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func loadImageButtonPressed(_ sender: UIButton) {
        DogAPI.shared.fetchData(compeletionHandler: handleFetchingData(url:error:))
    }
    
    
    func handleFetchingData(url: URL?, error: Error?){
        if error != nil { print(error!); return }
        
        guard let url = url else { return }
        
        DogAPI.shared.downoladImage(with: url, compeletionHandler: self.handleDownloadedImage(data:error:))
    }
    
    func handleDownloadedImage(data: Data?, error: Error?){
        if error != nil{ print(error!); return }
        
        guard let downloadedImage = data else { return }
        
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: downloadedImage)
        }
    }
    
}

