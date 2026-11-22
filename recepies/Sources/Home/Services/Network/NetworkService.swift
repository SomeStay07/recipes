import Foundation

protocol NetworkService {
    func request(_ type: RequestType) async throws -> Data
    func decode<T: Decodable>(from data: Data) throws -> T
}
