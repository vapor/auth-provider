import Vapor

extension BCryptHasher: PasswordVerifier {
    public func verify(password: String, matchesHash: String) throws -> Bool {
        return try check(password.bytes, matchesHash: matchesHash.bytes)
    }
}
