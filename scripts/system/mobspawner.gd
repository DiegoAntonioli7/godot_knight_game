class_name MobSpawner
extends Node2D

@export var mobs: Array[PackedScene]
var timer: float = 60.0

@onready var path_follow_2d = %PathFollow2D

var cooldown: float = 1.0

func _process(delta):
	if GameManager.is_game_over: return
	
	cooldown -= delta
	if cooldown > 0: return
	
	
	var interval = 60.0/timer
	cooldown = interval
	
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var paramenters = PhysicsPointQueryParameters2D.new()
	paramenters.position = point
	var result = world_state.intersect_point(paramenters,1)
	if not result.is_empty(): return 
	
	
	var index = randi_range(0, mobs.size() - 1)
	var mob_scene = mobs[index]
	var mob = mob_scene.instantiate()
	mob.position = point
	get_parent().add_child(mob)

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
