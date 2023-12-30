## Objective 
* Build an iOS app using the ArcGIS Maps SDK for Swift (https://developers.arcgis.com/swift/) that works with preplanned map areas.
* Use the webmap, "Explore Maine", with the item id 3bc3179f17da44a0ac0bfdac4ad15664 (https://www.arcgis.com/home/item.html?id=3bc3179f17da44a0ac0bfdac4ad15664)

## Use cases:
#### Use Case 1: Display Web Map and List of Preplanned Maps
* Actor: User
* Preconditions: The device is connected to the network
* Main Flow:
  * The user opens the application with a screen displaying a web map.
  * Simultaneously, a list of preplanned maps is displayed on the screen.
  * The web map shows an overview of the geographical area, while the list includes details such as map names, snippets, and a thumbnail
#### Use Case 2: Review Map Details by Clicking on the Web Map
* Actor: User
* Preconditions: The device is connected to the network, and the user clicks the web map
* Main Flow:
  * The user clicks on a web map.
  * The application retrieves and displays map details related to the selected map.
#### Use Case 3: Download a Preplanned Map and Review Its Details
* Actor: User
* Preconditions: The device is connected to the network, and the user clicks the download button on a preplanned map
* Main Flow:
  * The user clicks the download icon on a preplanned map from the list.
  * The user initiates the download process.
  * Once downloaded, the user can access and review the map details offline by clicking on the map.
#### Use Case 4: Review Downloaded Map Details Offline
* Actor: User
* Preconditions: The device is disconnected from the network
* Main Flow:
  * The user disconnects the device from the network.
  * Despite the network disconnection, the user is able to access and review the downloaded map.
  * The user can explore map details, and navigate the map details without an internet connection.
## Screenshots:
| Map list | Map details |
|----------|----------|
| <kbd>![Simulator Screenshot - iPhone 15 Pro - 2023-12-29 at 22 10 29](https://github.com/salmdoo/ExploreArcGIS/assets/118146780/915013ba-3454-4eef-8e5a-17131aed0d9c)</kbd>|<kbd> ![Simulator Screenshot - iPhone 15 Pro - 2023-12-29 at 22 10 36](https://github.com/salmdoo/ExploreArcGIS/assets/118146780/992a255f-4772-4bf3-8345-df272260641b)</kbd>|

## Non-Functional Requirement:
1. The application allows users to view and open previously downloaded map areas seamlessly, even when launched without a network connection.
* **Technique Applied:**
  * Employing NWPathMonitor for observing and responding to network changes.
  * Utilizing the Observer pattern to subscribe to network status updates.
  * This triggers the map-loading function to dynamically reflect the map based on the current network status.
2. The application prioritizes user-friendly interaction:
* Map list refresh: Users can effortlessly update the map list by performing a downward swipe gesture.
* Confirmation for map removal: The application ensures user confirmation before deleting a map.
3. The application boasts a highly scalable architecture:
* Utilizes design patterns: Observer, Singleton, Dependency injection, SOLID, and Protocol Oriented Programming (POP).
* Applied generic class: all maps are MapItem and the offline maps list can be Preplanned Map or Store Map, which is helpful to expand the Preplanned Map or Store Map if they have new specific behaviors.
4. The application incorporates cutting-edge technologies:
* Implementation of @Observable, a feature supported in iOS 17. 


## Architecture overview:
![Untitled Diagram drawio](https://github.com/salmdoo/ExploreArcGIS/assets/118146780/5dbcd631-6cc9-47fa-87d1-6fad00ce5183)
* The application displays both the web map and preplanned maps sourced from the **ArcGIS APIs**.
* Users have the capability to download preplanned maps:
  * The metadata, including map name, thumbnail URL, and snippet, is stored locally using technologies such as Core Data, Realm, or SQLite. **Core Data** is specifically implemented in this application.
  * The .mmpk map file is saved on the local device and managed through **File Management.**
  * The map thumbnail image is stored locally and managed by third-party tools like SDWebImage or Kingfisher, with **SDWebImageSwiftUI** being the chosen implementation in the application.
* To facilitate offline access, the application loads downloaded maps from local storage using **NSPersistentContainer and NSFetchRequest.**

## Class diagram:
 <img width="672" alt="Screenshot 2023-12-29 at 11 01 37 PM" src="https://github.com/salmdoo/ExploreArcGIS/assets/118146780/2306c4f0-c8c1-4732-a80a-8017c01b645f">

