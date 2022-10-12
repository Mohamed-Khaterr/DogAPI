//
//  DogAPI.swift
//  DogAPI
//
//  Created by Khater on 10/5/22.
//

import Foundation


class DogAPI {
    static let shared = DogAPI()
    
    enum Endpoint{
        case randomImages
        case randomImagesWithBreed(String)
        case breedsList
        
        var randomImageURLString: String{
            switch self{
            case .randomImages:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImagesWithBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .breedsList:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
        
        var url: URL?{
            return URL(string: self.randomImageURLString)
        }
    }
    
    private func errorDescription(with message: String) -> Error{
        return NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    public func fetchingBreedsList(compeletionHandler: @escaping ([String]?, Error?) -> Void){
        
        guard let url = Endpoint.breedsList.url else {
            compeletionHandler(nil, errorDescription(with: "guard let is Faild, URL is nil"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                compeletionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                compeletionHandler(nil, self.errorDescription(with: "Data is nil"))
                return
            }
            
            do {
                let breeds = try JSONDecoder().decode(BreedsList.self, from: data)
                
                if breeds.status == "error" {
                    compeletionHandler(nil, self.errorDescription(with: "There is an error in BreedsList data"))
                    return
                }
                
                let breedsList = breeds.message.keys.map({ $0 })
                compeletionHandler(breedsList, nil)
                
            }catch{
                compeletionHandler(nil, error)
            }
            
        }.resume()
    }
    
    public func fetchData(breed: String? = nil,compeletionHandler: @escaping (URL?, Error?) -> Void){
                                        // Breed = nil                  Breed != nil
        guard let url = (breed == nil) ? Endpoint.randomImages.url : Endpoint.randomImagesWithBreed(breed!).url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                compeletionHandler(nil, error!)
                return
            }
            
            guard let data = data else {
                compeletionHandler(nil, self.errorDescription(with: "Fetching Data error: data is nil"))
                return
            }
            
            
//            let imageURL = self.serializeJSON(with: data)
            
            do{
                let dogModel = try JSONDecoder().decode(DogModel.self, from: data)
                
                let status = dogModel.status
                
                if status == "error"{
                    compeletionHandler(nil, self.errorDescription(with: "There is an error in BreedsList data"))
                    return
                }
                
                let imageURL = dogModel.url
                
                compeletionHandler(imageURL, nil)
                
            }catch{
                compeletionHandler(nil, error)
            }
            
        }.resume()
    }
    
    private func serializeJSON(with data: Data) -> URL? {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonData = json as? [String: Any] else { return nil }
            
            if let status = jsonData["status"] as? String, status == "error"{
                return nil
            }
            
            guard let imageURLString = jsonData["message"] as? String else { return nil }
                
            return URL(string: imageURLString)
            
        }catch{
            return nil
        }
    }
    
    public func downoladImage(with url: URL, compeletionHandler: @escaping (Data?, Error?)-> Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                compeletionHandler(nil, error!)
                return
            }
            
            guard let downloadedImage = data else { return }
            
            compeletionHandler(downloadedImage, nil)
            
        }.resume()

    }
}
