# Park With Me

## Authors
* Nhi Quach

## Purpose
Park With Me is an application that helps people with available parking spaces
and people in search of a place to park. People will be able to post notices
that they are renting out their parking space and find spaces for rent around
them.

## Features
* Display available parking spaces within a 1 mile radius of the current
location
* Allow users to create postings to rent our their parking space, setting
prices and times available
* Communication platform between interested customers and renters

## Control Flow
* Users will open to login screen to log in with existing user information
or to the main tabbed screen
* The main views of the application are the map view and the list view which
display information about the nearest parking spaces to the user's current
location
* If they are looking for a parking space, the User is presented a marked map
with indicators for the locations of available spaces and their times and price
* If the user wishes to rent their space, the user provides input on the times
the space is available, the price (per hour/per day) and location of the space.
This is done by clicking the Add button at the List View
* When a user selects a space they are interested in parking at, they will be
able to message the renter to begin the transaction. Users can get more details
on parking spaces by clicking on a space's cell in the list View
* User can press refresh on the list view to load nearby posts

## Implementation

### Model
* User.swift
* Post.swift

### View
* MapView
* AddPostView
* PostDetailView
* ChatView
* LoginView
* PostTableView

### Controller
* MapViewController
* AddPostViewController
* ChatViewController
* LoginViewController
* PostDetailViewController
* PostTableViewController

## Credits
* Firebase for Backend
* Braintree for Payments
* Eureka for Form Building
* GeoFire (Firebase) for Location Querying
* Chameleon for Styling
* JSQMessagesViewController for Messaging UI
