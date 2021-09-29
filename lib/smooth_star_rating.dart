import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatefulWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRated;
  final Color? color;
  final Color? borderColor;
  final double size;
  final bool allowHalfRating;
  final IconData filledIconData;
  final IconData halfFilledIconData;
  final IconData
  defaultIconData; //this is needed only when having fullRatedIconData && halfRatedIconData
  final double spacing;
  final bool isReadOnly;
  StarRating({
    Key? key,
    this.starCount = 5,
    this.isReadOnly = false,
    this.spacing = 0.0,
    this.rating = 0.0,
    this.defaultIconData = Icons.star_border,
    this.onRated,
    this.color,
    this.borderColor,
    this.size = 25,
    this.filledIconData = Icons.star,
    this.halfFilledIconData = Icons.star_half,
    this.allowHalfRating = false,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  final double halfStarThreshold =
  0.53; //half star value starts from this number

  //tracks for user tapping on this widget
  bool isWidgetTapped = false;
  late double currentRating;
  Timer? debounceTimer;
  @override
  void initState() {
    currentRating = widget.rating;
    super.initState();
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    debounceTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: widget.spacing,
          children: List.generate(
              widget.starCount, (index) => buildStar(context, index))),
    );
  }

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= currentRating) {
      icon = Icon(
        widget.defaultIconData,
        color: widget.borderColor ?? Theme.of(context).primaryColor,
        size: widget.size,
      );
    } else if (index >
        currentRating -
            (widget.allowHalfRating ? halfStarThreshold : 1.0) &&
        index < currentRating) {
      icon = Icon(
        widget.halfFilledIconData,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size,
      );
    } else {
      icon = Icon(
        widget.filledIconData,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size,
      );
    }
    final star = widget.isReadOnly
        ? icon
        : kIsWeb
        ? MouseRegion(
      onExit: (event) {
        if (widget.onRated != null && !isWidgetTapped) {
          setState(() {
            currentRating = widget.rating;
          });
        }
      },
      onEnter: (event) {
        isWidgetTapped = false; //reset
      },
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox;
        var _pos = box.globalToLocal(event.position);
        var i = _pos.dx / widget.size;
        var newRating =
        widget.allowHalfRating ? i : i.ceil().toDouble();
        if (newRating > widget.starCount) {
          newRating = widget.starCount.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        setState(() {
          currentRating = newRating;
        });
      },
      child: GestureDetector(
        onTapDown: (detail) {
          isWidgetTapped = true;

          final box = context.findRenderObject() as RenderBox;
          var _pos = box.globalToLocal(detail.globalPosition);
          var i = ((_pos.dx - widget.spacing) / widget.size);
          var newRating =
          widget.allowHalfRating ? i : i.ceil().toDouble();
          if (newRating > widget.starCount) {
            newRating = widget.starCount.toDouble();
          }
          if (newRating < 0) {
            newRating = 0.0;
          }

          setState(() {
            currentRating =
            currentRating == widget.rating ? 0.0 : currentRating;
          });
          widget.onRated?.call(normalizeRating(currentRating));
        },
        onHorizontalDragUpdate: (dragDetails) {
          isWidgetTapped = true;

          final box = context.findRenderObject() as RenderBox;
          var _pos = box.globalToLocal(dragDetails.globalPosition);
          var i = _pos.dx / widget.size;
          var newRating =
          widget.allowHalfRating ? i : i.ceil().toDouble();
          if (newRating > widget.starCount) {
            newRating = widget.starCount.toDouble();
          }
          if (newRating < 0) {
            newRating = 0.0;
          }
          setState(() {
            currentRating = newRating;
          });
          debounceTimer?.cancel();
          debounceTimer = Timer(Duration(milliseconds: 100), () {
            widget.onRated?.call(normalizeRating(newRating));
          });
        },
        onTapUp: (e) {
          setState(() {
            currentRating =
            currentRating == widget.rating ? 0.0 : currentRating;
          });
          widget.onRated?.call(currentRating);
        },
        child: icon,
      ),
    )
        : GestureDetector(
      onTapDown: (detail) {
        final box = context.findRenderObject() as RenderBox;
        var _pos = box.globalToLocal(detail.globalPosition);
        var i = ((_pos.dx - widget.spacing) / widget.size);
        var newRating =
        widget.allowHalfRating ? i : i.ceil().toDouble();
        if (newRating > widget.starCount) {
          newRating = widget.starCount.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        newRating = normalizeRating(newRating);
        setState(() {
          currentRating = newRating;
        });
      },
      onTapUp: (e) {
        setState(() {
          currentRating =
          currentRating == widget.rating ? 0.0 : currentRating;
        });
        widget.onRated?.call(currentRating);
      },
      onHorizontalDragUpdate: (dragDetails) {
        final box = context.findRenderObject() as RenderBox;
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = _pos.dx / widget.size;
        var newRating =
        widget.allowHalfRating ? i : i.ceil().toDouble();
        if (newRating > widget.starCount) {
          newRating = widget.starCount.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        setState(() {
          currentRating = newRating;
        });
        debounceTimer?.cancel();
        debounceTimer = Timer(Duration(milliseconds: 100), () {
          widget.onRated?.call(normalizeRating(newRating));
        });
      },
      child: icon,
    );

    return star;
  }

  double normalizeRating(double newRating) {
    var k = newRating - newRating.floor();
    if (k != 0) {
      //half stars
      if (k >= halfStarThreshold) {
        newRating = newRating.floor() + 1.0;
      } else {
        newRating = newRating.floor() + 0.5;
      }
    }
    return newRating;
  }
}
