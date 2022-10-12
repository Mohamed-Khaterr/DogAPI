//
//  ByBreedViewController.swift
//  DogAPI
//
//  Created by Khater on 10/10/22.
//

import UIKit

class ByBreedViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    private var breeds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        
        DogAPI.shared.fetchingBreedsList(compeletionHandler: handleFetchingBreedsList(breedsList:error:))
    }

    
    func handleFetchingBreedsList(breedsList: [String]?, error: Error?){
        if error != nil {
            print(error!)
            return
        }
        
        if let breedsList = breedsList {
            self.breeds = breedsList
            
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    func handleFetchingData(imageURL: URL?, error: Error?){
        if error != nil{ print(error!); return }
        
        guard let imageURL = imageURL else { return }
        
        DogAPI.shared.downoladImage(with: imageURL, compeletionHandler: self.handleDownloadingImage(data:error:))
    }
    
    func handleDownloadingImage(data: Data?, error: Error?){
        if error != nil { print(error!); return }
        
        guard let data = data else { return }
        
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
}


// MARK: - UIPickerView
extension ByBreedViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        DogAPI.shared.fetchData(breed: breeds[row], compeletionHandler: handleFetchingData(imageURL:error:))
    }
}
