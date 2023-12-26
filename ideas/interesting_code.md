```swift
this actually gets rid of latency, when moving in a straight line
there is problems when switching directions

var dis := b.position - a.position
var hop := b.position + dis
var td := to_time - from_time # this syncs the frame of time / relative time
var s := dis / td
var magic_time := (current_time - to_time)/td # this syncs the frame of time / relative time
var next := b.position.lerp(hop, magic_time)
position = next

```


```swift
# Smoothed extrapolation/interp mixed code
var dis := b.position - a.position
var hop := b.position + dis
var td := to_time - from_time # this gets the syncs the frame of time
var s := dis / td
var magic_time := (current_time - to_time)/td # this gets the syncs the frame of time
var extrapolated_next := b.position.lerp(hop, magic_time)
var interpolated_next := position.move_toward(b.position, 1 * time_delta)
# position = next

var limit := position.distance_to(extrapolated_next)
if limit > 0.3:
	dis = extrapolated_next - position
	s = dis/(to_time + (to_time - from_time))
	position = position.move_toward(extrapolated_next, min(0.5, s.length()))
```


```swift
# smoothed extrapolation
var dis := to - from
var hop := to + dis
var td := to_time - from_time # this gets the syncs the frame of time
var s := dis / td
var magic_time := (current_time - to_time)/td # this gets the syncs the frame of time
var extrapolated_next := to.lerp(hop, magic_time)
return extrapolated_next
	
	```