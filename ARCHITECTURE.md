App Architecture
    This app uses the MVC (Model View Controller) Architechture pattern. 

Current Project Structure
    Frameworks
    Products
    Susi
        Youtube-Player
        Localization
        Assets
        Controllers
        Custom Views
        Helpers
        Model
        SnowboyFiles
        Shimmer
        Storyboards
        Supporting Files
   SusiUITests
   Pods
Presentation Logic
    Model : The Model contains only the pure application data, it contains no logic describing how to present the data to a user.
    View : The View presents the model’s data to the user. The view knows how to access the model’s data, but it does not know what this data means or what the user can do to manipulate it.
    Controller : The Controller exists between the view and the model. It listens to events triggered by the view (or another external source) and executes the appropriate reaction to these events. In most cases, the reaction is to call a method on the model. Since the view and the model are connected through a notification mechanism, the result of this action is then automatically reflected in the view.

Useful Resources
    MVC: Model, View, Controller https://www.codecademy.com/articles/mvc
    MVC Architecture  https://www.tutorialsteacher.com/mvc/mvc-architecture
    Model-View-Controller - Apple Developer https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html
