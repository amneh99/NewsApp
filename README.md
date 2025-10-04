# NewsApp
 
A modern iOS news application built with UIKit that fetches and displays top headlines from the News API.

## How It's Made:

Tech Stack:

Swift 5.9+

UIKit

URLSession for networking

Core Data for offline caching

Combine for reactive state management

Swift Testing for unit tests

## Key Features:

MVVM (Model-View-ViewModel) pattern

Protocol-oriented design

Repository pattern for data abstraction

Dependency injection for testability

## Adiitional Features:

Offline support with Core Data caching

Automatic fallback to cached articles when network unavailable

Network connectivity monitoring

Async image loading with fade-in animation

Empty state display when no articles available

Relative time display (e.g., "2 hours ago")

Support dark mode

Add app Icon

## Testing
Run tests with `⌘U` in Xcode or:

Tests include:

Network layer with mock responses

ViewModel state management

Repository data fetching

Offline/cache scenarios

## 🔧 How to Run

1. Clone the repo
2. Open the `.xcodeproj` in Xcode
3. Build and run the app on a simulator or device
