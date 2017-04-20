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
        try req.assertSession().data.set(sessionEntityId, id)
    }
    
    public func unpersist(for req: Request) throws {
        try req.assertSession().data.set(sessionEntityId, nil)
    }
    
    public static func fetchPersisted(for request: Request) throws -> Self? {
        guard let id = try request.assertSession().data[sessionEntityId] else {
            return nil
        }
        
        guard let user = try Self.find(id) else {
            return nil
        }
        
        return user
    }
}
