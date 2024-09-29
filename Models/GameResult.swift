//
//  GameResult.swift
//  MovieQuiz
//
//  Created by macbook on 28.09.2024.
//

import UIKit

struct GameResult {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan (_ another :GameResult) -> Bool {
        correct > another.correct
    }
}



