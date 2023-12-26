class_name GFN_Glue_Node_Synchronizer
extends Node

@export var viewport: Viewport

var synchronizer := GFN_Sync_Synchronizer.new()

func _ready():
	assert(viewport != null)
	viewport.own_world_3d = true

	# Ensure it's own SceneMultiplayer
	# TODO: handle this properly. viewport, enter/exit_tree, renamed, replaced_by
	if get_tree().get_multiplayer() == get_tree().get_multiplayer(viewport.get_path()):
		get_tree().set_multiplayer(GFN_Glue_Multiplayer.new(), viewport.get_path())
	
	# Remove custom scene multiplayer when viewport exits the scene
	viewport.tree_exiting.connect(get_tree().set_multiplayer.bind(null, viewport.get_path()))
	
	# connect after it's been given it's own SceneMultiplayer
	connect_network_signals() 

func connect_network_signals():
	viewport.multiplayer.connected_to_server.connect(_connected_to_server)
	viewport.multiplayer.server_disconnected.connect(_server_disconnected)
	viewport.multiplayer.connection_failed.connect(_connection_failed)
	viewport.multiplayer.peer_connected.connect(_peer_connected)
	viewport.multiplayer.peer_disconnected.connect(_peer_disconnected)

func create_server(port: int = GFN_Sync_Synchronizer.DEFAULT_PORT):
	# Create server
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(port, 3)
	print('creating server')
	viewport.multiplayer.multiplayer_peer = peer


func create_client(address: String = 'localhost', port: int = GFN_Sync_Synchronizer.DEFAULT_PORT):
	# Ensure it's own SceneMultiplayer
	# TODO: handle this properly. viewport, enter/exit_tree, renamed, replaced_by see [Node] signals
	if get_tree().get_multiplayer() == get_tree().get_multiplayer(viewport.get_path()):
		get_tree().set_multiplayer(SceneMultiplayer.new(), viewport.get_path())

	# Create client
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	print('creating client')
	viewport.multiplayer.multiplayer_peer = peer


func _connected_to_server():
	print(multiplayer.get_unique_id(), " _connected_to_server")
	pass

func _server_disconnected():
	print(multiplayer.get_unique_id(), " _server_disconnected")
	pass	

func _connection_failed():
	print(multiplayer.get_unique_id(), " _connection_failed")
	pass

func _peer_connected(peer: int):
	print(multiplayer.get_unique_id(), " _peer_connected ", peer)
	pass

func _peer_disconnected(peer: int):
	print(multiplayer.get_unique_id(), " _peer_disconnected ", peer)
	pass
