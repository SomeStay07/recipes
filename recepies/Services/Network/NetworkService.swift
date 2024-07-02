import Foundation

protocol NetworkService {
    func request() async throws -> Data
    func decode<T: Codable>(from data: Data) throws -> T
}
