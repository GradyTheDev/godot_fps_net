class_name GFN_Sync_NetPosition3DU24
extends GFN_Sync_NetData

## GFN_Sync_NetPosition3DU24
##
## (float) position / 100 -> serialized into 3x uint16
## rounded to 0.00
## max size 167772.16

var position: Vector3

## The point at which you teleport instead of interpolate/extrapolate
var teleport_on_exceed_speed: float = 100

func _init():
	# is_interpolation_enabled = true
	# is_extrapolation_enabled = true
	is_prediction_enabled = true

func serialize(stream: StreamPeerBuffer):
	stream.put_data(GFN_Sync_Tools.serialize_uint24(position.x * 100))
	stream.put_data(GFN_Sync_Tools.serialize_uint24(position.y * 100))
	stream.put_data(GFN_Sync_Tools.serialize_uint24(position.z * 100))

func deserialize(stream: StreamPeerBuffer) -> bool:
	if stream.get_available_bytes() < 9: 
		return false
	position.x = GFN_Sync_Tools.deserialize_uint24(stream.get_data(3)) / 100
	position.y = GFN_Sync_Tools.deserialize_uint24(stream.get_data(3)) / 100
	position.z = GFN_Sync_Tools.deserialize_uint24(stream.get_data(3)) / 100
	return true

func interpolate(from: GFN_Sync_NetData, to: GFN_Sync_NetData, factor: float):
	var a: GFN_Sync_NetPosition3DU24 = from as GFN_Sync_NetPosition3DU24
	var b: GFN_Sync_NetPosition3DU24 = to as GFN_Sync_NetPosition3DU24
	assert(a != null)
	assert(b != null)
	position = a.position.lerp(b.position, factor)

func clear():
	position.x = 0
	position.y = 0
	position.z = 0

func predict(from: GFN_Sync_NetData, to: GFN_Sync_NetData, from_time: float,
	 to_time: float, current_time: float, time_delta: float, client_latency: float):
	var a: GFN_Sync_NetPosition3DU24 = from as GFN_Sync_NetPosition3DU24
	var b: GFN_Sync_NetPosition3DU24 = to as GFN_Sync_NetPosition3DU24
	if a == null or b == null: return

	# TODO: prediction/interpolation needs work especially with negative values....

	if from_time >= to_time:
		return


	position = extrapolate(a.position, b.position, from_time, to_time, current_time)
	
	# position = position.move_toward(b.position, speed * time_delta)


	# var delayed_time := current_time - client_latency
	# var factor := (delayed_time / to_time)
	# print(factor)
	# position = a.position.lerp(b.position, factor * time_delta)


	
	# # Smoothed extrapolation/interp mixed code
	# var dis := b.position - a.position
	# var hop := b.position + dis
	# var td := to_time - from_time # this gets the syncs the frame of time
	# var s := dis / td
	# var magic_time := (current_time - to_time)/td # this gets the syncs the frame of time
	# var extrapolated_next := b.position.lerp(hop, magic_time)
	# var interpolated_next := position.move_toward(b.position, abs(s.length()) * time_delta)
	# # position = next

	# var pos := b.position
	# var limit := position.distance_to(pos)
	# # if limit > 0.1:
	# var d := a.position.distance_to(b.position)
	# var speed := d/(to_time + (to_time - from_time))
	# print(d)
	# position = position.move_toward(pos, speed * (to_time-from_time) * time_delta)

	# GFN_Sync_Tools.sprint([to_time, current_time, client_latency])
	# if to_time + client_latency > current_time:
	# 	position = extrapolated_next
	# else:
	# 	position = interpolated_next

	
	return


	# ## Interpolation and extrapolation
	# # print(position)
	# var magic := (current_time + time_delta) / (to_time - from_time)
	# if is_nan(magic) or is_inf(magic): 
	# 	print("Poof")
	# 	return
	# var next_pos := a.position.lerp(b.position, magic)
	# # print(current_time, ' ', time_delta, ' ', to_time, ' ', from_time)
	# var dis_delta := position.distance_to(next_pos)
	# if next_pos.is_equal_approx(next_pos):
	# 	dis_delta = 0
	# # print(dis_delta)
	# var speed := dis_delta/time_delta
	# # print(speed)
	# speed = round(speed*100)/100 # smooth out rounding errors from float math
	# # print(speed)
	# # print()

	# if speed < teleport_on_exceed_speed:
	# 	position = next_pos
	# else:
	# 	position = b.position


## just returns a value nothing more
func extrapolate(from: Vector3, to: Vector3, from_time: float,
	to_time: float, current_time: float) -> Vector3:

	# A
	var speed := to.distance_to(from) / (to_time - from_time)
	var dir := from.direction_to(to)
	var next := to + dir * speed
	return next

	# B
	# return to + (from - to)

	# C
	# var dis := to - from
	# var hop := to + dis
	# var td := to_time - from_time # this gets the syncs the frame of time
	# var s := dis / td
	# var magic_time := (current_time - to_time)/td # this gets the syncs the frame of time
	# var extrapolated_next := to.lerp(hop, magic_time)
	# return extrapolated_next