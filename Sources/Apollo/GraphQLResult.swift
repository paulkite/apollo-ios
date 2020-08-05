/// Represents the result of a GraphQL operation.
public struct GraphQLResult<Data>: Parseable {
  
  public init<T: FlexibleDecoder>(from data: Foundation.Data, decoder: T) throws {
    guard Data.self is Parseable else {
      throw ParseableError.unsupportedInitializer
    }
    
    // TODO: Figure out how to make this work
    // self = try decoder.decode(Data.self, from: data)
    throw ParseableError.notYetImplemented    
  }
  
  /// The typed result data, or `nil` if an error was encountered that prevented a valid response.
  public let data: Data?
  /// A list of errors, or `nil` if the operation completed without encountering any errors.
  public let errors: [GraphQLError]?

  /// Represents source of data
  public enum Source {
    case cache
    case server
  }
  /// Source of data
  public let source: Source

  let dependentKeys: Set<CacheKey>?

  public init(data: Data?,
              errors: [GraphQLError]?,
              source: Source,
              dependentKeys: Set<CacheKey>?) {
    self.data = data
    self.errors = errors
    self.source = source
    self.dependentKeys = dependentKeys
  }
}
