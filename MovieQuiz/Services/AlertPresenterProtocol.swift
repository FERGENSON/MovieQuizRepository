
import UIKit

protocol AlertPresenterProtocol {
    func presentAlert(result: AlertModel)
    var delegate: UIViewController? { get set }
}
