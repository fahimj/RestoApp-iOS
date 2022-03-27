# RestoApp-iOS

This is a mini project of a food ordering app. A user can see a list of menus. When the user tap a menu item, the app shows a detail page containing its variants and extras addons. Through the detail page, the user can choose a variant, addons, how many quantity needed for the dish and see the total price that is calculated from the chosen options.  

## Project Structure

This project structure is monorepo arranged into the following folders:
- Menu Feature. This contains domain models of the app and protocols that represent loading menu item use case and loading detail item use case. These components do not have any dependency with other components outside this folder.
- Menu UI. This contains UI components. UI components don't hold states and their states are controlled by View Model components.
- Menu Presentation. This contains view model components. View models accept inputs from view controllers and use case components, and also manage states represented by view controllers
- Menu API. Components contained in this folder are implementation details of loading use cases defined in menu feature.
- Tests (RestoApp iOSTests). This folder contains tests for Menu API & Menu Presentation components. I tried Test Driven Development process while developing this app so I made the test while developing the production code. I don't test fully the UI components yet because I find it is harder and tricky to test

## How to Run

To run the project, clone and open the RestoApp-iOS.xcodeproj using Xcode 13. Let the dependency manager (swift package manager) load the dependencies, then the app should be running by clicking the play button or pressing Command + R.
