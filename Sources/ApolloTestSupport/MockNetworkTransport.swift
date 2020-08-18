@testable import Apollo
import Dispatch

public final class MockNetworkTransport: RequestChainNetworkTransport {

  public init(body: JSONObject, store: ApolloStore) {
    let testURL = TestURL.mockServer.url
    let mockClient = MockURLSessionClient()
    mockClient.data = try! JSONSerializationFormat.serialize(value: body)
    mockClient.response = HTTPURLResponse(url: testURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
    let legacyProvider = LegacyInterceptorProvider(client: mockClient,
                                                   store: store)
    super.init(interceptorProvider: legacyProvider,
               endpointURL: TestURL.mockServer.url)
  }
}

private final class MockTask: Cancellable {
  func cancel() {
    // no-op
  }
}
