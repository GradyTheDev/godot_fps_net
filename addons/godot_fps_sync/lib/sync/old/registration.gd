class_name GFN_Sync_EntityRegistration
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

## serialized: uint8
var entity_type: int

## data schema required for game simulation replication
## simulation_entity_replication_data_schema[br]
## replication_schema[br]
## also optionally used to interpolate, extrapolate, and predict[br]
## { schema key: [GFN_Sync_DataProcessor] }[br]
## when data is pulled/pushed from an entity it's in the order of this schema
# var schema: Dictionary

## This isn't to store data
## but rather to be duplicated 
## and the data stored in the duplicate
var data_container: GFN_Sync_DataContainer

func get_relative_sync_priority(of_entity: GFN_Sync_EntityLink, to_client: int) -> int:
	assert(false, "Dev! Override this function!")
	return 0

func on_entity_spawned(link: GFN_Sync_EntityLink):
	assert(false, "Dev! Override this function!")
	pass

func on_entity_despawned(link: GFN_Sync_EntityLink):
	assert(false, "Dev! Override this function!")
	pass

func get_state(from: GFN_Sync_EntityLink) -> GFN_Sync_DataContainer:
	assert(false, "Dev! Override this function!")
	return data_container.duplicate()

func set_state(to: GFN_Sync_EntityLink, state: GFN_Sync_DataContainer):
	assert(false, "Dev! Override this function!")
	pass

func predict(link: GFN_Sync_EntityLink):
	pass