import UIKit

// MARK: - Protocol
protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (Data?) -> Void)
}

// MARK: - Properties
final class ImageLoader: NSObject, ImageLoaderProtocol {
    private let cache = NSCache<NSURL, NSData>()
    private var completions: [URL: (Data?) -> Void] = [:]

    /// URLSession с фоновой конфигурацией, чтобы загрузки продолжались даже при сворачивании приложения
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "socialApp")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
}

// MARK: - Protocol function
extension ImageLoader {
    /// Проверяет наличие изображения в кэше, иначе загружает по URL
    func loadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        if let cached = cache.object(forKey: url as NSURL) {
            completion(cached as Data)
            return
        }

        completions[url] = completion
        session.downloadTask(with: url).resume()
    }
}

// MARK: - URLSessionDownloadDelegate
extension ImageLoader: URLSessionDownloadDelegate {
    /// Вызывается при завершении загрузки. Кэширует изображение и вызывает completion
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url,
              let data = try? Data(contentsOf: location) else { return }

        cache.setObject(data as NSData, forKey: url as NSURL)

        DispatchQueue.main.async {
            self.completions[url]?(data)
            self.completions[url] = nil
        }
    }

    /// Обработка ошибки загрузки. Сообщаем через completion, что данные не получены
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url, let error = error else { return }

        print("Image load failed: \(error.localizedDescription)")

        DispatchQueue.main.async {
            self.completions[url]?(nil)
            self.completions[url] = nil
        }
    }
}
