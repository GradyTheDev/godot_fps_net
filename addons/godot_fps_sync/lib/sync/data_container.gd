class_name GFN_Sync_DataContainer
extends RefCounted

## Data Container
##
## Any data fields you want duplicated/tracked 
## must be of the type GFN_Sync_NetData

## DO NOT CHANGE THIS
## keys
var entries: Array[String]

## DON'T CHANGE THIS
## this is when (in game time), this container was received (network) or pulled from the simulation
## or if this is a prediction, this is future time
var timestamp: float

func _init():
	for x in get_property_list():
		if is_instance_of(get(x['name']), GFN_Sync_NetData):
			entries.append(x['name'])
	# End for loop
	entries.sort() # ensures deterministic order

func duplicate() -> GFN_Sync_DataContainer:
	var n = new()
	var stream := StreamPeerBuffer.new()
	serialize(stream)
	stream.seek(0)
	assert(n.deserialize(stream), 'oh no')
	return n 

func serialize(stream: StreamPeerBuffer):
	for entry in entries:
		var nd := get(entry) as GFN_Sync_NetData
		nd.serialize(stream)

func deserialize(stream: StreamPeerBuffer) -> bool:
	for entry in entries:
		var nd := get(entry) as GFN_Sync_NetData
		if not nd.deserialize(stream): 
			return false
	# end for loop
	return true

## Resets ONLY serializable data to defaults
## NOT anything else
func clear():
	for entry in entries:
		var nd := get(entry) as GFN_Sync_NetData
		nd.clear()

## self.timestamp is used as current time
## time_delta is the simulation frame time / time between simulation frames
func predict(from: GFN_Sync_DataContainer, to: GFN_Sync_DataContainer,
	 time_delta: float, client_latency: float):
	for entry in entries:
		var entry_c := get(entry) as GFN_Sync_NetData
		if not entry_c.is_prediction_enabled: continue
		var entry_a := from.get(entry) as GFN_Sync_NetData
		var entry_b := to.get(entry) as GFN_Sync_NetData
		entry_c.predict(entry_a, entry_b, from.timestamp, to.timestamp,
		 timestamp, time_delta, client_latency)