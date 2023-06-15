//
//  Logger.swift
//  IORequestable_Example
//
//  Created by Roy on 2022/5/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//
import Foundation
import Alamofire
import Moya



/// Logs network activity (outgoing requests and incoming responses).
public final class BasicNetworkLoggerPlugin: PluginType {
    fileprivate let loggerId = "Urfitness API"
    fileprivate let dateFormatString = "yyyy/MM/dd(eee) HH:mm:ss"
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let separator = ", "
    fileprivate let terminator = "\n"
    fileprivate let cURLTerminator = "\\\n"
    fileprivate let output: (_ separator: String, _ terminator: String, _ items: Any...) -> Void
    fileprivate let requestDataFormatter: ((Data) -> (String))?
    fileprivate let responseDataFormatter: ((Data) -> (Data))?
  
    public static let defaultResponseDataFormatter: ((Data) -> Data) =
    { data in
      if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
         let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
        return jsonData
      } else {
        return data
      }
    }
    

    /// A Boolean value determing whether response body data should be logged.
    public let isVerbose: Bool
    public let cURL: Bool

    /// Initializes a NetworkLoggerPlugin.
    public init(verbose: Bool = false, cURL: Bool = false, output: ((_ separator: String, _ terminator: String, _ items: Any...) -> Void)? = nil, requestDataFormatter: ((Data) -> (String))? = nil, responseDataFormatter: ((Data) -> (Data))? = BasicNetworkLoggerPlugin.defaultResponseDataFormatter) {
        self.cURL = cURL
        self.isVerbose = verbose
        self.output = output ?? BasicNetworkLoggerPlugin.reversedPrint
        self.requestDataFormatter = requestDataFormatter
        self.responseDataFormatter = responseDataFormatter
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        var cURLString: String?
        if let request = request as? Request, cURL {
            cURLString = request.getCurlRepresentation()
            //output(separator, terminator, request.debugDescription)
            //return
        }
        outputItems(logNetworkRequest(request.request as URLRequest?, cURL: cURLString))
    }

    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            outputItems(logNetworkResponse(response, data: response.data, target: target))
        } else {
            outputItems(logNetworkResponse(nil, data: nil, target: target))
        }
    }

    fileprivate func outputItems(_ items: [String]) {
        if isVerbose {
            items.forEach { output(separator, terminator, $0) }
        } else {
            output(separator, terminator, items)
        }
    }
}

private extension BasicNetworkLoggerPlugin {

    var date: String {
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date())
    }

    func format(_ loggerId: String, date: String, identifier: String, message: String) -> String {
        return "\(loggerId): [\(date)] \(identifier): \(message)"
    }

    func logNetworkRequest(_ request: URLRequest?, cURL: String?) -> [String] {

        var output = [String]()

        output += ["API ⬆ \(request?.httpMethod ?? "UnknownMethod ") \(request?.url?.absoluteString ?? "")"]
        
        output += [cURL ?? "No cURL"]

        return output
    }

    func logNetworkResponse(_ moyaResponse: Moya.Response?, data: Data?, target: TargetType) -> [String] {
        guard let response = moyaResponse?.response else {
           return [format(loggerId, date: date, identifier: "Response", message: "Received empty network response for \(target).")]
        }

        var output = [String]()
        output += ["API ⬇ \(moyaResponse?.request?.httpMethod ?? "UnknownMethod ") \(moyaResponse?.request?.url?.absoluteString ?? "") (\(response.statusCode))"]

        if let data = data, let stringData = String(data: responseDataFormatter?(data) ?? data, encoding: String.Encoding.utf8), isVerbose {
            output += [stringData]
        }

        return output
    }
}

fileprivate extension BasicNetworkLoggerPlugin {
    static func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            print(item, separator: separator, terminator: terminator)
        }
    }
}

fileprivate extension Alamofire.Request {
    func getCurlRepresentation() -> String {
        var components = ["$ curl -v"]

        guard let request = self.request,
              let url = request.url,
              let _ = url.host
        else {
            return "$ curl command could not be created"
        }

        if let httpMethod = request.httpMethod, httpMethod != "GET" {
            components.append("-X \(httpMethod)")
        }
        
        var headers: [AnyHashable: Any] = [:]

        /* Ignore cookies since session is no longer accessible in Alamofire 5.x.x
        if session.configuration.httpShouldSetCookies {
            if
                let cookieStorage = session.configuration.httpCookieStorage,
                let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty
            {
                let string = cookies.reduce("") { $0 + "\($1.name)=\($1.value);" }

            #if swift(>=3.2)
                components.append("-b \"\(string[..<string.index(before: string.endIndex)])\"")
            #else
                components.append("-b \"\(string.substring(to: string.characters.index(before: string.endIndex)))\"")
            #endif
            }
        }

        session.configuration.httpAdditionalHeaders?.filter {  $0.0 != AnyHashable("Cookie") }
                                                    .forEach { headers[$0.0] = $0.1 }
         */

        request.allHTTPHeaderFields?.filter { $0.0 != "Cookie" }
                                    .forEach { headers[$0.0] = $0.1 }

        components += headers.map {
            let escapedValue = String(describing: $0.value).replacingOccurrences(of: "\"", with: "\\\"")

            return "-H \"\($0.key): \(escapedValue)\""
        }

        if let httpBodyData = request.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            components.append("-d \"\(escapedBody)\"")
        }

        components.append("\"\(url.absoluteString)\"")

        return components.joined(separator: " \\\n\t")
    }
}

