extends Node2D


@export var mob_spawner: MobSpawner
@export var start_spawn_rate: float = 60
@export var spawn_rate_per_minute: float = 60
@export var wave_duration: float = 30.0
@export var break_intensity: float = 0.3

var time: float = 0.0

func _physics_process(delta):
	if GameManager.is_game_over: return
	
	time += delta
	
	var spawn_rate = start_spawn_rate * spawn_rate_per_minute * (time/60)
	
	var sin_wave = sin((time *TAU) / wave_duration)
	var wave_factor = remap(sin_wave,-1.0,1.0,break_intensity,1)
	
	spawn_rate *= wave_factor
	
	
	mob_spawner.timer = spawn_rate
