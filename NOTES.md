This app will allow a user to log in and view/update their profile, which will essentially show a bunch of collections. Each collection will contain many items, which will be of different categories.

Models

User has many collections
User has many items through collections

Collection has many items
Collection belongs to a user

Item belongs to a collection

Examples
User = Some dude who has lists of favorites
Collection 1 = favorite movies list
Collection 1 items = lots of different movies
Collection 2 = favorite restaurants list
Collection 2 items = many different restaurants
Collection 3 = favorite vacation spots list
Collection 3 items = many different vacation places, etc….