
A Star rating with touch and swipe rate enabled. This is an updated version of https://github.com/thangmam/smoothratingbar addressing several issues I had. Null safe.

* Read only and adjustable rating
* Web Support
* Supports replacing default star icons with desired IconData
* Supports half rate and full rate (1.0 or 0.5)
* Swipe for incrementing/decrementing rate amount
* Change star body and boundary colors independently
* Control size of the star rating
* Set your desired total Star count
* Supports click-to-rate
* Spacing between stars

## Getting Started

In your flutter project add the dependency:
```
    dependencies:
        ...
        smooth_star_rating_v2:
            git:
              url: https://github.com/samu-developments/smoothratingbar.git
```

## Usage example
``` 
import 'package:smooth_star_rating_v2/smooth_star_rating.dart';
``` 

```java
    SmoothStarRating(
          allowHalfRating: false,
          onRated: (v) {
           },
          starCount: 5,
          rating: rating,
          size: 40.0,
          isReadOnly:true,
          fullRatedIconData: Icons.blur_off,
          halfRatedIconData: Icons.blur_on,
          color: Colors.green,
          borderColor: Colors.green,
          spacing:0.0
    )

```

## Constructor parameters
``` 
allowHalfRating                 -   Whether to use whole number for rating(1.0  or 0.5)
onRated(double rating)          -   Rating changed callback
starCount                       -   The maximum amount of stars
rating                          -   The current value of rating
size                            -   The size of a single star
color                           -   The body color of star
borderColor                     -   The border color of star
spacing                         -   Spacing between stars(default is 0.0)
fullRatedIconData               -   Full Rated Icon
halfRatedIconData               -   Half Rated Icon
isReadOnly                      -   true for read only star.False by default
```

### Screenshots

#### Full Rating
![alt text](https://raw.githubusercontent.com/thangmam/smoothratingbar/master/screenshots/fullrating.gif "Full rating")

#### Half Rating

![alt text](https://raw.githubusercontent.com/thangmam/smoothratingbar/master/screenshots/halfrating.gif  "Half Rating")

### MIT LICENSE
