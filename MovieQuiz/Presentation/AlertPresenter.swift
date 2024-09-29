
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: UIViewController?
    
    func presentAlert(result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in 
            result.completion()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: {})
    }
}








