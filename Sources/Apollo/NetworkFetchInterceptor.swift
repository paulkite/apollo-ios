import Foundation

public class NetworkFetchInterceptor: ApolloInterceptor {
  let client: URLSessionClient
  private var currentTask: URLSessionTask?
  
  init(client: URLSessionClient) {
    self.client = client
  }
  
  public func interceptAsync<ParsedValue: Parseable, Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<ParsedValue>,
    completion: @escaping (Result<ParsedValue, Error>) -> Void) {
    
    let urlRequest: URLRequest
    do {
      urlRequest = try request.toURLRequest()
    } catch {
      completion(.failure(error))
      return
    }
    
    self.currentTask = self.client.sendRequest(urlRequest) { result in
      defer {
        self.currentTask = nil
      }
      
      guard chain.isNotCancelled else {
        return
      }
      
      switch result {
      case .failure(let error):
        chain.handleErrorAsync(error,
                               request: request,
                               response: response,
                               completion: completion)
        completion(.failure(error))
      case .success(let (data, httpResponse)):
        response.httpResponse = httpResponse
        response.rawData = data
        response.sourceType = .network
        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
      }
    }
  }
}
