# Assignment for Coolblue
The goal was to implement the project as simple as possible to display a list of products with ability to search and load more data as user scroll to the end of the screen based on available data count and page counts from API.

## Architecture
Project is based on MVVM which separates app code into Views, Models, ViewModels in combination with a repository which uses a network layer to load data from API and finally sending data to UI using `Combine` and reactive programing method.

### So how it works?
UI asks ViewModel to load data and view model asks repository to load data from the source. This way we can change repository with anything if needed without changing UI or the logic of the app. 

Let's say loading data from local DB or another kind of cloud function or cloud database.

## Deep into layers
### Network layer
A simple networking class to load data from an API provided with a `NetworkClient` object to configure `URLSession` and `URLRequest` based on the need of api call. 

### NetworkImageCache
A singleton class which uses `NSCaching` and `DispatchQueues` to load product images concurrently without affecting app performance. The class is using features from `DispatchQueue` to prevent concurrency problems like race condition or non atomic operation caused by multiple access to singleton object.

## If I had more time...
- I would write more test for the project to increase coverage but for now I tried to cover different ways that I would test behaviour in the project.

- If it was a large project with a some kind clear roadmap I might have added more details in the project with protocols and generics to make project more expandable.
