class_name GFN_Sync_EntityLink
extends RefCounted

## network entity id
## link id
var entity_id: int

## [member GFN_Sync_EntityRegistration.entity_id]
## serialized: uint8
var entity_type: int

### external entity id
# var external_id / simulation_entity_id : int
# or maybe just
# var external_entity - direct link to entity, bad idea though

## Used for prediction
var previous_state: GFN_Sync_DataContainer

## Used for prediction
var next_state: GFN_Sync_DataContainer

## Used for prediction
var state_delta_time: float
