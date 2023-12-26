extends Node3D

@onready var player_spawn: Node3D = get_node("PlayerSpawn")
@onready var player_container: Node3D = get_node("Players")

var pck_player: PackedScene = load("res://addons/godot_fps_sync/demo/player.tscn") 

func _ready():
	multiplayer.peer_connected.connect(on_player_join)
	for peer in multiplayer.get_peers():
		on_player_join(peer)

func on_player_join(peer: int):
	var player: Node3D = pck_player.instantiate()
	player.set_multiplayer_authority(peer)
	player_container.add_child(player)
	