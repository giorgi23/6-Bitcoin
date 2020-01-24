
import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    var moneySign = ""
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
    }
}
    
    //MARK: - UIPickerView
    
    extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return coinManager.currencyArray.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return coinManager.currencyArray[row]
            
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedCurrency = coinManager.currencyArray[row]
            coinManager.getCoinPrice(for: selectedCurrency)
            moneySign = selectedCurrency
        }
        
    }

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func didFailWithError(Error: Error) {
        //show to the user
    }
    
    func didUpdatePrice(Price: Double) {
        DispatchQueue.main.async{
            self.bitcoinLabel.text = String(format: "%.2f", Price)
            self.currencyLabel.text = self.moneySign
        }
        
    }
    
    
}

