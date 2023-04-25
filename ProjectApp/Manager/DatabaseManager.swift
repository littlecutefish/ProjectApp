//
//  DatabaseManager.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/22.
//

import Foundation

class DatabaseManager {
    
    // Singleton
    static let shared: DatabaseManager = DatabaseManager()
    private init() { }
    
    // Public Function
    func uploadData(to urlString: String, data: Encodable, httpMethod: String = "POST") async -> Result<(Data, Int), UploadDataError> {
        // 網址
        guard let url = URL(string: urlString) else {
            return .failure(.urlPathError)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        // 設置請求 HTTP 標頭
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let data = try? JSONEncoder().encode(data) else {
            return .failure(.encodeError)
        }
        request.httpBody = data
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            return .failure(.internetError)
        }
        guard let response = response as? HTTPURLResponse else {
            return .failure(.responseCodeError)
        }
        // 回應的狀態碼
        let statusCode = response.statusCode
        return .success((data, statusCode))
    }
}

extension DatabaseManager {
    enum UploadDataError: String, LocalizedError {
        case urlPathError = "URL格式錯誤"
        case encodeError = "JSON錯誤"
        case internetError = "網路錯誤"
        case responseCodeError = "狀態碼轉換錯誤"
        case uploadError = "上傳錯"
    }
}
