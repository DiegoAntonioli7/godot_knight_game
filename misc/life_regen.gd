extends Node2D

@export var life_reg: int = 10

@onready var area: Area2D = $Area2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(life_reg)
		player.meat_collect.emit(life_reg)
		queue_free()
