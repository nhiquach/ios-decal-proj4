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
* Allow users to create postings to rent our their parking space, setting prices
and times available
* Communication platform between interested customers and renters
## Control Flow
* Users will open to screen giving them the option to search for a parking space
or rent out their parking space
* If they are looking for a parking space, the User is presented a marked map
with indicators for the locations of available spaces and their times and price
* If the user wishes to rent their space, the user provides input on the times
the space is available, the price (per hour/per day) and location of the space
* When a user selects a space they are interested in parking at, they will be
able to message the renter to begin the transaction

## Implementation

### Model
* User.swift
* ParkingSpace.swift
### View
* MapView
* AddPostView
* MessagesView
* StartScreenView
### Controller
* MapViewController
* AddPostViewController
* MessagesViewController
* StartScreenViewController
