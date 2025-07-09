import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (Data?) -> Void)
}

import UIKit

final class ImageLoader: NSObject, ImageLoaderProtocol {
    private var completions: [URL: (Data?) -> Void] = [:]
    private let cache = NSCache<NSURL, NSData>()

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "homework7")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    func loadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        if let cachedData = cache.object(forKey: url as NSURL) {
            completion(cachedData as Data)
            return
        }

        completions[url] = completion
        let task = session.downloadTask(with: url)
        task.resume()
    }
}

extension ImageLoader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url,
              let data = try? Data(contentsOf: location) else { return }

        cache.setObject(data as NSData, forKey: url as NSURL)

        DispatchQueue.main.async {
            self.completions[url]?(data)
            self.completions[url] = nil
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error, let url = task.originalRequest?.url {
            print("Image load error for URL \(url): \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.completions[url]?(nil)
                self.completions[url] = nil
            }
        }
    }
}
