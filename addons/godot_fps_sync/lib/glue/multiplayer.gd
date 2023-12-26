extends MultiplayerAPIExtension
class_name GFN_Glue_Multiplayer

# We want to augment the default SceneMultiplayer.
var base_multiplayer = SceneMultiplayer.new()

func _init():
	# Just passthrough base signals (copied to var to avoid cyclic reference)
	var cts = connected_to_server
	var cf = connection_failed
	var pc = peer_connected
	var pd = peer_disconnected
	base_multiplayer.connected_to_server.connect(func(): cts.emit())
	base_multiplayer.connection_failed.connect(func(): cf.emit())
	base_multiplayer.peer_connected.connect(func(id): pc.emit(id))
	base_multiplayer.peer_disconnected.connect(func(id): pd.emit(id))

var last_print_time: float
func _poll():
	var now := Time.get_ticks_msec()
	if now - last_print_time > 500:
		print('_poll ', now)
		last_print_time = now
		if is_server():
			for i in range(multiplayer_peer.get_available_packet_count()):
				print('packet: ', multiplayer_peer.get_packet())
		else:
			multiplayer_peer.set_target_peer(MultiplayerPeer.TARGET_PEER_SERVER)
			base_multiplayer.send_bytes('HI'.to_utf8_buffer(), 1)
	return base_multiplayer.poll()

# Log RPC being made and forward it to the default multiplayer.
func _rpc(peer: int, object: Object, method: StringName, args: Array) -> Error:
	print("Got RPC for %d: %s::%s(%s)" % [peer, object, method, args])
	return base_multiplayer.rpc(peer, object, method, args)

# Log configuration add. E.g. root path (nullptr, NodePath), replication (Node, Spawner|Synchronizer), custom.
func _object_configuration_add(object, config: Variant) -> Error:
	if config is MultiplayerSynchronizer:
		print("Adding synchronization configuration for %s. Synchronizer: %s" % [object, config])
	elif config is MultiplayerSpawner:
		print("Adding node %s to the spawn list. Spawner: %s" % [object, config])
	return base_multiplayer.object_configuration_add(object, config)

# Log configuration remove. E.g. root path (nullptr, NodePath), replication (Node, Spawner|Synchronizer), custom.
func _object_configuration_remove(object, config: Variant) -> Error:
	if config is MultiplayerSynchronizer:
		print("Removing synchronization configuration for %s. Synchronizer: %s" % [object, config])
	elif config is MultiplayerSpawner:
		print("Removing node %s from the spawn list. Spawner: %s" % [object, config])
	return base_multiplayer.object_configuration_remove(object, config)

# These can be optional, but in our case we want to augment SceneMultiplayer, so forward everything.
func _set_multiplayer_peer(p_peer: MultiplayerPeer):
	base_multiplayer.multiplayer_peer = p_peer

func _get_multiplayer_peer() -> MultiplayerPeer:
	return base_multiplayer.multiplayer_peer

func _get_unique_id() -> int:
	return base_multiplayer.get_unique_id()

func _get_peer_ids() -> PackedInt32Array:
	return base_multiplayer.get_peers()

#
#
#
#
#
#
#


# var cts = connected_to_server
# var cf = connection_failed
# var pc = peer_connected
# var pd = peer_disconnected
func _connected_to_server():
	pass

func _connection_failed():
	pass

func _peer_connected(peer: int):
	pass

func _peer_disconnected(peer: int):
	pass
