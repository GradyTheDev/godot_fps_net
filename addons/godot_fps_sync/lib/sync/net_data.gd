class_name GFN_Sync_NetData
extends RefCounted

## Doesn't include data type / data processor type in serialization

var is_prediction_enabled: bool

## Only serializes data
func serialize(stream: StreamPeerBuffer):
	assert(false, "Dev! Override this function!")
	# Serialization logic
	# Must be overridden
	pass

## Only serializes data
## returns false on failure
func deserialize(stream: StreamPeerBuffer) -> bool:
	assert(false, "Dev! Override this function!")
	# Deserialization logic
	# Must be overridden
	return true

## factor 0 -> 1 is interpolation[br]
## factor 1+ is extrapolation
func interpolate(from: GFN_Sync_NetData, to: GFN_Sync_NetData, factor: float):
	assert(false, "Dev! Override this function!")
	# Interpolation logic
	# Must be overridden
	pass


func make_new() -> GFN_Sync_NetData:
	return new()

## Resets ONLY serializable data to defaults
## NOT anything else
func clear():
	assert(false, "Dev! Override this function!")
	pass


## time is the milliseconds between "from" and "to"
func predict(from: GFN_Sync_NetData, to: GFN_Sync_NetData, from_time: float,
	 to_time: float, current_time: float, time_delta: float, client_latency: float):
	pass