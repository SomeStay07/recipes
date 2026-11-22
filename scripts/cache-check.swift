// Скрипт из 13 серии: замер политики кэша.
// returnCacheDataDontLoad с пустым кэшем в сеть не идёт и падает, useProtocolCachePolicy грузит ответ.
// Запуск: swift scripts/cache-check.swift

import Foundation

let url = URL(string: "https://www.apple.com")!
URLCache.shared.removeAllCachedResponses()

for policy in [URLRequest.CachePolicy.returnCacheDataDontLoad, .useProtocolCachePolicy] {
    let name = policy == .returnCacheDataDontLoad ? "старая" : "стандартная"
    do {
        let (_, response) = try await URLSession.shared.data(for: URLRequest(url: url, cachePolicy: policy))
        print(name, "- код", (response as? HTTPURLResponse)?.statusCode ?? 0)
    } catch {
        print(name, "- упал:", (error as? URLError)?.code == .resourceUnavailable ? "ресурс недоступен" : "\(error)")
    }
}
