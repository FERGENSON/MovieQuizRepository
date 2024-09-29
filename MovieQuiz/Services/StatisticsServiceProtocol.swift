//
//  StatisticsServiceProtocol.swift
//  MovieQuiz
//
//  Created by macbook on 28.09.2024.
//

import UIKit

protocol StatisticsServiceProtocol {
    var gamesCount: Int {get}
    var bestGame: GameResult {get}
    var totalAccuracy: Double {get}
    
    func store (correct count: Int, total amount: Int)
}

