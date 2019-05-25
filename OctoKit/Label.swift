import Foundation
import RequestKit

open class Label: Codable {
    open var url: URL?
    open var name: String?
    open var color: String?
}

// MARK: request

public extension Octokit {
    /**
     Fetches all labels in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter page: Current page for label pagination. `1` by default.
     - parameter perPage: Number of labels per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func labels(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Label]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = LabelRouter.readLabels(configuration, owner, repository, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Label].self) { labels, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let labels = labels {
                    completion(Response.success(labels))
                }
            }
        }
    }
}

enum LabelRouter: JSONPostRouter {
    case readLabels(Configuration, String, String, String, String)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .GET
        }
    }
    
    var encoding: HTTPEncoding {
        switch self {
        default:
            return .url
        }
    }
    
    var configuration: Configuration {
        switch self {
        case .readLabels(let config, _, _, _, _): return config
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .readLabels(_, _, _, let page, let perPage):
            return ["per_page": perPage, "page": page]
        }
    }
    
    var path: String {
        switch self {
        case .readLabels(_, let owner, let repository, _, _):
            return "/repos/\(owner)/\(repository)/labels"
        }
    }
}
