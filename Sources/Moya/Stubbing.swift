import Foundation

public protocol StubbedTargetType: TargetType {
    /// Provides stub data for use in testing.
    var sampleData: Data? { get }
}

/// Controls how stub responses are returned.
public struct StubBehavior {
    let delay: TimeInterval
    let result: MoyaResult    

    init(delay: TimeInterval = 0, result: MoyaResult) {
        self.result = result
        self.delay = delay
    }

    init(delay: TimeInterval = 0, statusCode: Int, data: Data, request: URLRequest?, httpResponse: HTTPURLResponse?) {
        let response = Moya.Response(statusCode: statusCode, data: data, request: request, response: httpResponse)
        self.init(delay: delay, result: .success(response))
    }

    init(delay: TimeInterval = 0, error: Swift.Error) {
        let finalError: MoyaError
        if let moyaError = error as? MoyaError {
            finalError = moyaError
        } else {
            finalError = MoyaError.underlying(error, nil)
        }
        self.init(delay: delay, result: .failure(finalError))
    }
}