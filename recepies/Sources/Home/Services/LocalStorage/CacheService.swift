import Foundation

// MARK: - CacheServiceType

protocol CacheServiceType {
    func remove(key: String)
    func removeAll()
    func write(value: Bool, key: String)
    func read(key: String)
}

protocol CodableCacheServiceType: CacheServiceType {
    func write<T: Encodable>(_ value: T, key: String)
    func read<T: Decodable>(key: String) -> T?
}

// MARK: - CacheServiceImpl

final class CacheServiceImpl {
    
    // MARK: - Storage
    
    enum Storage: String {
        case `default` = "com.recipes"
        case pushes = "com.recipes.pushes"
    }
    
    private let service: UserDefaults
    
    // MARK: - Init
    
    init(storage: Storage = .default) {
        service = UserDefaults()
        service.addSuite(named: storage.rawValue)
    }
    
}

// MARK: - Extensions

extension CacheServiceImpl: CodableCacheServiceType {
    
    func remove(key: String) {
        service.removeObject(forKey: key)
    }
    
    func removeAll() {
        for (key, _) in service.dictionaryRepresentation() {
            service.removeObject(forKey: key)
        }
    }
    
    func write(value: Bool, key: String) {
        service.set(value, forKey: key)
    }
    
    func read(key: String) {
        service.bool(forKey: key)
    }
    
    func write<T: Encodable>(_ value: T, key: String) {
        guard let data = try? JSONEncoder().encode(value) else {
            return
        }
        
        service.set(data, forKey: key)
    }
    
    func read<T: Decodable>(key: String) -> T? {
        guard
            let data = service.value(forKey: key) as? Data,
            let model = try? JSONDecoder().decode(T.self, from: data) 
        else {
            return nil
        }
        
        return model
    }
    
}
