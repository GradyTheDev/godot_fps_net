class_name GFN_Sync_Synchronizer # game sync, network sync, world sync?
extends RefCounted

const DEFAULT_PORT: int = 6543

## A registry of entity types
## { [member GFN_Sync_Entity.type] : [GFN_Sync_Entity] }
var entity_types: Dictionary

## a list of active entity instances
## { [member GFN_Sync_Entity.id]: [GFN_Sync_Entity] }
var entities: Dictionary

var clients # TODO: finish this

func run():
	pass
	# send interval...
	# bandwidth optimizations? later
	# 
	Time.get_ticks_msec()


func create_server():
	pass

func create_client():
	pass