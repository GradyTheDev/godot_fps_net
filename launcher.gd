extends Node

# class what extends GFN_Sync_DataContainer:
# 	var position := GFN_Sync_NetPosition3DU24.new()

# @onready var box := $box as MeshInstance3D
# @onready var box2 := $box2 as MeshInstance3D

# var start := what.new()
# var current := what.new()
# var end := what.new()

# func _ready():
# 	# start.position.is_extrapolation_enabled = true
# 	start.position.position = box.position
# 	current.position.position = box.position
# 	end.position.position = box.position
# 	# end.timestamp = 1
# 	# end.position.position.x += 1.52


# 	# var a = what.new()
# 	# var b = what.new()
# 	# print(a.position.position)
# 	# b.position.position.x = 137
# 	# b.position.position.y = 10
# 	# b.position.position.z = 26
# 	# a.position.interpolate(b.position, 0.5)
# 	# print(a.position.position)
	
# 	# print(box.position)
# 	await get_tree().create_timer(30).timeout
# 	# print(box.position)
# 	await get_tree().create_timer(0.3).timeout
# 	get_tree().quit()


func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_Q and event.is_released():
			get_tree().quit()

# var delay_min: float = 0.1
# var delay_max: float = 1
# var delay: float = delay_max
# var counter: float = 0
# var counter2: float = delay
# var flip: float = 1
# var speed: float = 1
# func _physics_process(delta: float):
# 	pass
# 	# current.position.interpolate(end.position, clamp(delta, 0, 1))
	# print(current.position.position)

	# current.predict(start, end, delta)
	# current.timestamp += delta
	# box.position = current.position.position
	
	# box.position = lerp(Vector3.ZERO, Vector3(5,5,5), clamp(counter, 0, 1) )
	# print(lerp(Vector3.ZERO, Vector3(5,5,5), counter ))
	
	# box.position.x += speed * flip * delta
	# if box.position.x > 2:
	# 	flip = -1
	# elif box.position.x < -2:
	# 	flip = 1

	# var dir := Vector3.ZERO
	# if Input.is_key_pressed(KEY_D):
	# 	dir.x = 1
	# if Input.is_key_pressed(KEY_A):
	# 	dir.x = -1
	
	# if Input.is_key_pressed(KEY_W):
	# 	dir.z = -1
	# if Input.is_key_pressed(KEY_S):
	# 	dir.z = 1
	
	# if Input.is_key_pressed(KEY_SHIFT):
	# 	dir *= 3

	# box.position += dir * speed * delta

	# current.predict(start, end, delta, randf_range(delay-0.3, delay+0.3)) # simulate packet latency
	# current.timestamp += delta
	# box2.position = current.position.position
	# box2.position.y = 1.5

	# counter += delta
	# if counter > counter2:
	# 	# timers
	# 	delay = randf_range(delay_min, delay_max) # simulate packet latency
	# 	counter2 = counter + delay

	# 	# add to confirmed state buffer
	# 	start.position.position = end.position.position
	# 	start.timestamp = end.timestamp

	# 	end.position.position = box.position
	# 	end.timestamp = counter



@onready var s: Node = %Server
@onready var c1: Node = %Client
@onready var c2: Node = %Client2 

var address := 'localhost'
var port := 7000

func sleep(x: float = 1):
	await get_tree().create_timer(x).timeout

func create_server(n: Node):
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(port)
	n.multiplayer.multiplayer_peer = peer

func create_client(n: Node):
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	n.multiplayer.multiplayer_peer = peer

func _peer_connected(peer: int):
	print("peer connected ", peer)

func _connection_failed():
	print("connection_failed")

func _ready():
	# print(s, ' ', s.multiplayer.multiplayer_peer)
	# print(c1, ' ', c1.multiplayer.multiplayer_peer)
	# print(c2, ' ', c2.multiplayer.multiplayer_peer)
	# print()
	await sleep(0.3)
	get_window().mode = get_window().MODE_MINIMIZED

	# create_client(c1)
	# create_client(c2)
	# create_server(s)
	# s.multiplayer.peer_connected.connect(_peer_connected)
	# s.multiplayer.connection_failed.connect(_connection_failed)

	var peer

	peer = ENetMultiplayerPeer.new()
	assert(peer.create_client(address, port) == OK)
	c1.multiplayer.multiplayer_peer = peer
	

	peer = ENetMultiplayerPeer.new()
	assert(peer.create_server(port) == OK)
	s.multiplayer.multiplayer_peer = peer
	s.multiplayer.connection_failed.connect(_connection_failed)