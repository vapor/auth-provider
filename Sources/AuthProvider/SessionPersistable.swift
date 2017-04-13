import HTTP
import Sessions
import Fluent

/// Models conforming to this protocol can
/// be persisted through Sessions with `SessionMiddleware`
///
/// - note: If the model is an `Entity`, persistable
///         protocol requirements will be implemented automatically.
public protocol SessionPersistable: Persistable {}

private let sessionEntityId = "session-entity-id"

/// MARK: Default conformance

extension SessionPersistable where Self: Entity {
    public func persist(for req: Request) throws {
        try req.session().data.set(sessionEntityId + "-\(Self.self)", id)
    }
    
    public func unpersist(for req: Request) throws {
        try req.session().data.set(sessionEntityId + "-\(Self.self)", nil)
    }
    
    public static func fetchPersisted(for request: Request) throws -> Self? {
        guard let id = try request.session().data[sessionEntityId + "-\(Self.self)"] else {
            return nil
        }
        
        guard let user = try Self.find(id) else {
            return nil
        }
        
        return user
    }
}
