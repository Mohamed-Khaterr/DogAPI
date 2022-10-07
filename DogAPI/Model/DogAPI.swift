//
//  DogAPI.swift
//  DogAPI
//
//  Created by Khater on 10/5/22.
//

import Foundation


class DogAPI {
    static let shared = DogAPI()
    
    enum Endpoint: String{
        case randomImage = "https://dog.ceo/api/breeds/image/random"
        
        var url: URL?{
            return URL(string: self.rawValue)
        }
    }
    
    public func fetchData(compeletionHandler: @escaping (URL?, Error?) -> Void){
        guard let url = Endpoint.randomImage.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                compeletionHandler(nil, error!)
                return
            }
            
            guard let data = data else {
                compeletionHandler(nil, error)
                return
            }
            
            let imageURL = self.parseJSON(with: data)
//            let imageURL = self.serializeJSON(with: data)
            
            compeletionHandler(imageURL, nil)
            
        }.resume()
    }
    
    private func parseJSON(with data: Data) -> URL?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(DogModel.self, from: data)
            
            let imageURL = decodedData.url
            
            return imageURL
            
        }catch{
            return nil
        }
    }
    
    private func serializeJSON(with data: Data) -> URL? {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonData = json as? [String: Any] else { return nil }
            
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
