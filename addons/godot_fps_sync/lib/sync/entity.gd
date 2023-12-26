class_name GFN_Sync_Entity
extends RefCounted

## Entity Registration
##
## When a game entity, not network entity
## is spawn in, it should ask for the network synchronizer 
## to spawn a network entity with a specific type
## if the network synchronizer doesn't return a network entity / entity link
## it means that it failed to spawn, so the game entity should delete its self
## otherwise the network synchronizer will send the spawn command and entity state data
## to all other peers (if this is the server, if not the network entity/link spawn request will be denied)

## serialized: uint16
var id: int

## serialized: uint8
var type: int

## This isn't to store data
## but rather to be duplicated 
## and the data stored in the duplicate
var data_container_base: GFN_Sync_DataContainer

## Confirmed state / State from server
## used for prediction
var older_state: GFN_Sync_DataContainer

## Confirmed state / State from server
## used for prediction
var newer_state: GFN_Sync_DataContainer

func get_relative_sync_priority(to_client: int) -> int:
	assert(false, "Dev! Override this function!")
	return 0

func on_spawn():
	assert(false, "Dev! Override this function!")
	pass

func on_despawn():
	assert(false, "Dev! Override this function!")
	pass

func get_state() -> GFN_Sync_DataContainer:
	assert(false, "Dev! Override this function!")
	return data_container_base.duplicate()

func set_state(state: GFN_Sync_DataContainer):
	assert(false, "Dev! Override this function!")
	pass

func predict(time_delta: float, client_latency: float):
	var c := get_state()
	c.predict(older_state, newer_state, time_delta, client_latency)
	set_state(c)

## makes a fresh entity
func make_new() -> GFN_Sync_Entity:
	return new()