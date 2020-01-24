

import Foundation

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let finalURL = baseURL + currency
        print(finalURL)
        performRequest (urlString: finalURL)
        
    }
    
    func performRequest (urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, URLresponse, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(Error: error!)
                    print(error!.localizedDescription)
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    self.delegate?.didUpdatePrice(Price: self.parseJSON(data: safeData)!)
                    
                }
                
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LastPrice.self, from: data)
            print(decodedData.last)
            return decodedData.last
            
        } catch {
            delegate?.didFailWithError(Error: error)
            return nil
        }
        
    }
    
}

//MARK: - CoinManagerDelegate

protocol CoinManagerDelegate {
    
    func didFailWithError(Error: Error)
    
    func didUpdatePrice(Price: Double)
    
}

//MARK: - LastPrice

struct LastPrice: Codable {
    let last: Double
}
