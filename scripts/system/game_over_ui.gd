class_name Game_Over_Ui
extends CanvasLayer

@onready var label_time = %time_numb_label
@onready var label_enemies = %monster_numb_label

@export var restar_timer: float = 20.0

var restart_cooldown: float = 5.0


func _ready():
	label_time.text = GameManager.time_elapsed_string
	label_enemies.text = str(GameManager.monster_counter)
	restart_cooldown = restar_timer

func _physics_process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()

func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
