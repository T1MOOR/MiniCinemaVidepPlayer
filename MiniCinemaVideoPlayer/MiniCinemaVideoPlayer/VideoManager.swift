//
//  VideoManager.swift
//  MiniCinemaVideoPlayer
//
//  Created by Тимур Гарипов on 26.02.23.
//

import Foundation

// Перечисление запросов тегов, предлагаемых приложением.
enum Query: String, CaseIterable {
    case nature, animals, people, ocean, food
}

class VideoManager: ObservableObject {
    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.nature {
        // Once the selectedQuery variable is set, we'll call the API again
        didSet {
            Task.init {
                await findVideos(topic: selectedQuery)
            }
        }
    }
    
    // При инициализации класса извлекаем видео
    init() {
        // Необходимо использовать Task.init и ключевое слово await, поскольку findVideos является асинхронной функцией.
        Task.init {
            await findVideos(topic: selectedQuery)
        }
    }
    
    // Получение видео асинхронно
    func findVideos(topic: Query) async {
        do {
        // Прежде чем продолжить, надо убедится, что у нас есть URL
        guard let url = URL(string: "https://api.pexels.com/videos/search?query=\(topic)&per_page=20&orientation=portrait") else { fatalError("Missing URL") }
        
        // Создание запроса URLRequest
        var urlRequest = URLRequest(url: url)
        
        // Настройка заголовка авторизации HTTP-запроса
        urlRequest.setValue("UxneBoLU4rog2qDJYPXKrwXfjcMImmQbALkaX5t1sIkh7zQ48PfafUWK", forHTTPHeaderField: "Authorization")
        
            // Получение данных
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            //Прежде чем продолжить, убедитесь, что ответ 200 OK.
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            
            // Создание экземпляра JSONDecoder
            let decoder = JSONDecoder()
            
            // Позволяет нам преобразовать данные API из snakeCase в CamalCase.
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // Декодируйtv в структуру ResponseBody
            let decodedData = try decoder.decode(ResponseBody.self, from: data)
            
            // Установка переменного видео
            DispatchQueue.main.async {
                // Сбрасываем видео (когда мы снова вызываем API)
                self.videos = []
                
                // Пересоздание видео, которые мы получили из API
                self.videos = decodedData.videos
            }

        } catch {
            // Если мы столкнемся с ошибкой, вывод ошибки в консоли
            print("Error fetching data from Pexels: \(error)")
        }
    }
}

// Структура ResponseBody, которая следует за данными JSON, которые мы получаем от API
struct ResponseBody: Decodable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
    
}

struct Video: Identifiable, Decodable {
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User: Identifiable, Decodable {
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile: Identifiable, Decodable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
