//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by macbook on 15.09.2024.
//
import UIKit
import Foundation

// структура-шаблон ддля mock-данных
struct QuizQuestion {
    // строка с названием фильма,
    // совпадает с названием картинки афиши фильма в Assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
