
import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate
{
    // MARK: - IB Outlets
    
    @IBOutlet weak private var imageView: UIImageView!
    
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    
    private let presenter = MovieQuizPresenter()
    
    private var currentQuestion: QuizQuestion?
    
    private var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var statisticsService = StatisticsService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: NetworkClient()), delegate: self)
        statisticsService = StatisticsService()
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
        self.alertPresenter = AlertPresenter()
        self.alertPresenter?.delegate = self
        
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    // MARK: - Private functions
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    internal func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            
            statisticsService.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            let text = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount) \n Количество сыграных квизов: \(statisticsService.gamesCount) \n Рекорд: \(statisticsService.bestGame.correct)/\(statisticsService.bestGame.total) (\(statisticsService.bestGame.date.dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticsService.totalAccuracy)) %"
            
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз", completion: {[weak self] in
                    
                    guard let self = self else { return }
                    
                    self.presenter.resetQuestionIndex()
                    self.correctAnswers = 0
                    
                    questionFactory?.requestNextQuestion()
                })
            alertPresenter?.presentAlert(result: viewModel)
        } else {
            presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator () {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError (message:String) {
        hideLoadingIndicator ()
        
        let text = "Произошла ошибка"
        let viewModel = AlertModel(title: text,
                                   message: message,
                                   buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.presentAlert(result: viewModel)
    }
    
    // MARK: - Public functions
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
