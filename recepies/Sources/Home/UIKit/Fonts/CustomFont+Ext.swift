import SwiftUI

public extension Font {
    
    var uiFont: UIFont? {
        guard let fontProvider = fontProvider(in: self) else {
            return nil
        }
        
        let mirror = Mirror(reflecting: fontProvider)
        
        if let name = mirror.descendant("name") as? String,
           let size = mirror.descendant("size") as? CGFloat {
            return UIFont(name: name, size: size)
        }
        
        return nil
    }
    
    func fontProvider<T>(in object: T) -> T? {
        let mirror = Mirror(reflecting: object)
        
        if let provider = mirror.descendant("provider") ?? mirror.descendant("base") {
            if let providerObject = provider as? T {
                return fontProvider(in: providerObject)
            }
        }
        
        return object
    }
    
    func customWeight(_ weight: Weight) -> Font {
        guard 
            let uiFont,
            let weight = weight.uiWeight,
            uiFont.fontDescriptor.postscriptName.starts(with: "Inter")
        else {
            return self.weight(weight)
        }
        
        return Font(uiFont.withWeight(weight.inter))
    }
    
}
