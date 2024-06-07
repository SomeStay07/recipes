import UIKit
import SUIRecipesKit
import SUIRecipesUI

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        SUIRecipesKit.hello()
        SUIRecipesUI.hello()
        
        CustomFontManager.registerCustomFonts()
        
        ThemeManager.shared.themes = [
            .light: ThemeStorage.light,
            .dark: ThemeStorage.dark
        ]

        return true
    }

}
