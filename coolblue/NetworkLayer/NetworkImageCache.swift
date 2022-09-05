//
//  NetworkImageCache.swift
//  coolblue
//
//  Created by Mohammad Sheikh on 9/5/22.
//

import Foundation
import UIKit

class NetworkImageCache {
    
    typealias LoadingCompletionType = (UIImage?) -> Void
    
    typealias LoadingResponse = [NSURL: [LoadingCompletionType]]
    
    typealias CacheType = NSCache<NSURL, UIImage>
    
    typealias RunningRequest = [NSURL: URLSessionDataTask]
    
    public static let shared = NetworkImageCache()
    
    private let urlSession: URLSession
    
    private let cachedImages = CacheType()
    
    private var loadingResponses = LoadingResponse()
    
    private var runningRequests = RunningRequest()
    
    private let concurrentQueue =
    DispatchQueue(
        label: "concurrentQueue",
        attributes: .concurrent)
    
    private init(session: URLSession = URLSession.shared) {
        self.urlSession = session
    }
}
extension NetworkImageCache {
    func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    private var getLoadingResponses : LoadingResponse {
        var loadingResponses = LoadingResponse();
        concurrentQueue.sync {
            loadingResponses = self.loadingResponses
        }
        return loadingResponses
    }
    
    private var getRunningRequests : RunningRequest {
        var runningRequests = RunningRequest();
        concurrentQueue.sync {
            runningRequests = self.runningRequests
        }
        return runningRequests
    }
    
    private func addToRunningRequests(key:NSURL,value:URLSessionDataTask) {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            self?.runningRequests[key] = value
        }
    }
    
    private func addToLoadingResponses(key:NSURL,value: @escaping LoadingCompletionType) {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            self?.loadingResponses[key] = [value]
        }
    }
    
    private func appendToLoadingResponse(key:NSURL,value: @escaping LoadingCompletionType) {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            if (self?.loadingResponses[key] != nil) {
                self?.loadingResponses[key]?.append(value)
            }
        }
    }
    
    private func removeValues(key:NSURL) {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            self?.loadingResponses.removeValue(forKey: key)
            self?.runningRequests.removeValue(forKey: key)
        }
    }
}
extension NetworkImageCache {
    func load(
        url: NSURL,
        queue: DispatchQueue = .main,
        completion: @escaping (UIImage?) -> Void
    ) {
        if let cachedImage = image(url: url) {
            queue.async {
                completion(cachedImage)
            }
            return
        }
        
        if getLoadingResponses[url] != nil {
            appendToLoadingResponse(key: url, value: completion)
            return
        } else {
            addToLoadingResponses(key: url, value: completion)
        }
        
        let task = urlSession.dataTask(with: url as URL) { data, _, error in
            
            defer {
                self.removeValues(key: url)
            }
            
            guard let responseData = data,
                  let image = UIImage(data: responseData),
                  let blocks = self.loadingResponses[url],
                  error == nil
            else {
                queue.async {
                    completion(nil)
                }
                return
            }
            
            for block in blocks {
                queue.async {
                    block(image)
                }
            }
            
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)

        }
        
        task.resume()
        addToRunningRequests(key: url, value: task)
    }
    
    func cancelLoad(_ url: NSURL) {
        runningRequests[url]?.cancel()
        runningRequests.removeValue(forKey: url)
    }
}
