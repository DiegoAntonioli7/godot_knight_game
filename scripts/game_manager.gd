extends Node

signal game_over

var player : Player
var player_position : Vector2
var is_game_over: bool = false

var monster_counter: int = 0
var meat_count: int = 0
var time_elapsed_string: String
var timer_pass: float = 0.0

func _process(delta):
	timer_pass += delta
	
	var timer_seconds: int = floori(timer_pass)
	var seconds: int = timer_seconds %60
	var minutes: int = timer_seconds /60
	
	time_elapsed_string = "%02d:%02d" %[minutes,seconds]

func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	monster_counter = 0
	meat_count = 0
	time_elapsed_string = ""
	timer_pass = 0.0
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
