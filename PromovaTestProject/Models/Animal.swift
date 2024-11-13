//
//  Animal.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import Foundation

struct Animal: Decodable, Identifiable, Equatable {
    var id: String = UUID().uuidString

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

struct AnimalContent: Decodable, Equatable, Identifiable {
    var id: String = UUID().uuidString

    let fact: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case fact
        case image
    }
}

// MARK: Transformation CoreData to Local
extension Animal {
    init(animalMO: AnimalMO) {
        title = animalMO.title ?? ""
        description = animalMO.descriptionTitle ?? ""
        image = animalMO.image ?? ""
        order = Int(animalMO.order)
        status = animalMO.statusEnum
        content = animalMO.contentArray?.map { AnimalContent(animalContentMO: $0) }
    }
}

extension AnimalContent {
    init(animalContentMO: AnimalContentMO) {
        fact = animalContentMO.fact ?? ""
        image = animalContentMO.image ?? ""
    }
}

// MARK: Mock
extension Animal {
    static func mock(maxIndex: Int) -> [Animal] {
        (0...maxIndex).map { index in
            .init(
                id: UUID().uuidString,
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

extension AnimalContent {
    static func mock() -> [AnimalContent] {
        [
            .init(
                fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer.",
                image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
            ),
            .init(
                fact: "The Mayans and Aztecs symbolized every tenth day with the dog, and those born under this sign were believed to have outstanding leadership skills.",
                image: "https://images.dog.ceo/breeds/dachshund/dachshund-3.jpg"
            ),
            .init(
                fact: "The Mayans and Aztecs symbolized every tenth day with the dog, and those born under this sign were believed to have outstanding leadership skills.",
                image: "https://images.dog.ceo/breeds/dachshund/dachshund-3.jpg"
            ),
            .init(
                fact: "The Mayans and Aztecs symbolized every tenth day with the dog, and those born under this sign were believed to have outstanding leadership skills.",
                image: "https://images.dog.ceo/breeds/dachshund/dachshund-3.jpg"
            ),
            .init(
                fact: "The Mayans and Aztecs symbolized every tenth day with the dog, and those born under this sign were believed to have outstanding leadership skills.",
                image: "https://images.dog.ceo/breeds/dachshund/dachshund-3.jpg"
            ),
            .init(
                fact: "The Mayans and Aztecs symbolized every tenth day with the dog, and those born under this sign were believed to have outstanding leadership skills.",
                image: "https://images.dog.ceo/breeds/dachshund/dachshund-3.jpg"
            )
        ]
    }
}
