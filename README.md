# Nooro Weather Test App
This is a demo application that demonstrates the use of Swift and SwiftUI with MVVM and Clean Architecture.
The app uses the [weatherapi.com](https://www.weatherapi.com) REST API to search for cities and load the current weather.

## Key features
* Vanilla **SwiftUI** implementation
* Decoupled **Presentation**, **Business Logic**, and **Data Access** layers
* Data persistence with **UserDefaults**
* Native SwiftUI dependency injection
* Simple yet flexible networking layer built on Generics
* Built with SOLID, DRY, KISS, YAGNI in mind
* Designed for scalability.

### Presentation Layer
**SwiftUI views** that contain no business logic and are a function of the state.
Side effects are triggered by the user's actions (such as a tap on a button) or view lifecycle event `onAppear` and are forwarded to the `ViewModel`.
`ViewModel` also serves as the data source for the View. `ViewModel` is injected into the view as a constructor parameter.

### Business Logic Layer
Business Logic Layer is represented by `ViewModels` and `Services`.
`Services` receive requests to perform work, such as obtaining data from an external source or making computations.
`ViewModel` works as an intermediary between `View` and `Services`, encapsulating business logic local to the view.

### Data Access Layer
Data Access Layer is represented by `Repositories`.
Repositories provide asynchronous API for making CRUD operations on the backend or a local database. They don't contain business logic. Repositories are accessible and used only by the Services.

## How to run the app
- Create an `.env` file in the root of the project by running this command `cp .env.example .env` and fill it with required parameters.
- Build and run the application.

