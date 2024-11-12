//
//  Animal.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import Foundation

struct Animal: Decodable, Identifiable, Equatable {
    var id: UUID = UUID()

    let title: String
    let description: String
    let image: String
    let order: Int
    let status: Status
    var content: [AnimalContent]?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case image
        case order
        case status
        case content
    }

    var contentIsAvailable: Bool {
        (content?.isEmpty ?? true) == false
    }

    enum Status: String, Decodable, CaseIterable, Equatable {
        case paid
        case free

        var isAvailable: Bool {
            self == .free
        }
    }
}

struct AnimalContent: Decodable, Equatable {
    let fact: String
    let image: String
}

// MARK: Mock
extension Animal {
    static func mock(maxIndex: Int) -> [Animal] {
        (0...maxIndex).map { index in
            .init(
                id: UUID(),
                title: "Dogs 🐕 \(index)",
                description: "Different facts about dogs",
                image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
                order: index,
                status: Status.allCases.randomElement() ?? .free,
                content: [
                    .init(
                        fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer.",
                        image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
                    ),
                    .init(
                        fact: "The Mayans and Aztecs symbolized every tenth day with the dog, and those born under this sign were believed to have outstanding leadership skills.",
                        image: "https://images.dog.ceo/breeds/dachshund/dachshund-3.jpg"
                    )
                ]
            )
        }
    }
}
