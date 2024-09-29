//
//  StatisticsService.swift
//  MovieQuiz
//
//  Created by macbook on 28.09.2024.
//

import UIKit

final class StatisticsService {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
        case date
        case correctAnswers
    }
}

extension StatisticsService: StatisticsServiceProtocol {
    
    var gamesCount: Int {
        get {storage.integer(forKey: Keys.gamesCount.rawValue)}
        set {storage.set(newValue, forKey: Keys.gamesCount.rawValue)}
    }
    
    var bestGame: GameResult {
        get {
            GameResult(
                correct: storage.integer(forKey: Keys.correct.rawValue),
                total: storage.integer(forKey: Keys.total.rawValue),
                date: storage.object(forKey: Keys.date.rawValue) as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(Date(), forKey: Keys.date.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if gamesCount != 0 {
            Double(correctAnswers)/(10 * Double(gamesCount)) * 100
        }
        else {0.00}
    }
    
    private var correctAnswers: Int {
        get {storage.integer(forKey: Keys.correctAnswers.rawValue)}
        set {storage.set(newValue, forKey: Keys.correctAnswers.rawValue)}
    }
    
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        gamesCount += 1
        let game = GameResult(correct: count, total: amount, date: Date())
        if game.isBetterThan(bestGame) {
            bestGame.correct = count
            bestGame.total = amount
            bestGame.date = game.date
        }
    }
}





