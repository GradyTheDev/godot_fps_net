extends Control

@onready var server: Viewport = %Server
@onready var server_sync: GFN_Glue_Node_Synchronizer = %ServerSync

@onready var client: Viewport = %Client
@onready var client_sync: GFN_Glue_Node_Synchronizer = %ClientSync

@onready var node_history: RichTextLabel = %Log

var note_index: int = 0
func note(s: String):
	note_index += 1
	node_history.text += '%s: %s \n' % [note_index, s]
	print('\n%s: %s' % [note_index, s])

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_Q and event.is_released():
			get_tree().quit()

func sleep(x: float = 1):
	await get_tree().create_timer(x).timeout

func _ready():
	# Start server and client
	note('Starting server and client')
	server_sync.create_server()
	client_sync.create_client()
	await sleep()
	
	# Spawn scene in server
	note('Spawning scene')
	var scene = load("res://addons/godot_fps_sync/demo/level.tscn") as PackedScene
	scene = scene.instantiate()
	server.add_child(scene)
	await get_tree().create_timer(3).timeout

	# Pause game 
	note("Pausing game")
	get_tree().paused = true
	await sleep()

	# Unpause game 
	note("Unpausing game")
	get_tree().paused = false
	await sleep()

	# Despawn scene in server
	note('Despawning scene')
	server.remove_child(scene)
	await get_tree().create_timer(2).timeout

	# Disconnect client
	note('Server kicking client')
	server.multiplayer.multiplayer_peer.disconnect_peer(client.multiplayer.get_unique_id())
	await sleep()

	server.get_parent().get_parent().queue_free()
	print(server.get_parent().get_parent())
	await sleep()

	await sleep()
	get_tree().quit()
