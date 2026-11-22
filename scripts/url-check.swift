// Скрипт из 13 серии: почему URL нельзя склеивать руками.
// Амперсанд в значении параметра режет запрос, URLQueryItem кодирует его в %26.
// Запуск: swift scripts/url-check.swift

import Foundation

let text = "salt & pepper"

let glued = URL(string: "https://api.spoonacular.com/recipes/complexSearch?query=\(text)")!
print(glued.absoluteString)
print(URLComponents(url: glued, resolvingAgainstBaseURL: false)!.queryItems!)

var components = URLComponents()
components.scheme = "https"
components.host = "api.spoonacular.com"
components.path = "/recipes/complexSearch"
components.queryItems = [URLQueryItem(name: "query", value: text)]
print(components.url!.absoluteString)
