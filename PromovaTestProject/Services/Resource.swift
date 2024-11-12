//
//  Resource.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import Foundation

struct Resource {
    let route: String
    let httpMethod: HTTPMethod
    let urlQueryParameters: HTTParameters
    let httpBodyParameters: HTTParameters
    let headers: HTTPHeaders
    var httpBody: Data?
    var isNeedBearToken: Bool

    init(
        route: String,
        httpMethod: HTTPMethod = .get,
        urlQueryParameters: HTTParameters = [:],
        httpBodyParameters: HTTParameters = [:],
        headers: HTTPHeaders = [:],
        httpBody: Data? = nil,
        isNeedBearToken: Bool = false
    ) {
        self.route = route
        self.httpMethod = httpMethod
        self.urlQueryParameters = urlQueryParameters
        self.httpBodyParameters = httpBodyParameters
        self.headers = headers
        self.httpBody = httpBody
        self.isNeedBearToken = isNeedBearToken
    }
}

extension Resource {
    func createRequest() throws -> URLRequest {
        guard let url = URL(string: Constants.URL.baseURL + route) else {
            throw APIError.invalidURL
        }

        let targetURL = addURLQueryParameters(toURL: url)
        let httpBody = getHttpBody()

        var request = URLRequest(url: targetURL)

        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers

        if isNeedBearToken {
            request.allHTTPHeaderFields?["Authorization"] = "Bearer some token"
        }
        request.httpBody = httpBody

        return request
    }

    private func getHttpBody() -> Data? {
        guard let contentType = headers["Content-Type"] else { return nil }

        if (contentType as AnyObject).contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters)
        } else if (contentType as AnyObject).contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.map {
                "\($0)=\(String(describing: ($1 as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
            }.joined(separator: "&")

            return bodyString.data(using: .utf8)
        } else {

            return httpBody
        }
    }

    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.values.count > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            let queryItems = urlQueryParameters.map {
                return URLQueryItem(name: $0, value: String(describing: $1))
            }

            urlComponents.queryItems = queryItems

            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }

        return url
    }
}

