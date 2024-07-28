class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int = 10
@export var death_animiation : PackedScene

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drops: Array[PackedScene]
@export var drop_rare: Array[float]

var damage_digit_scene : PackedScene

func _ready():
	damage_digit_scene = preload("res://misc/damage_digit.tscn")

func damage(amount: int):
	health -= amount
	print("tomou dano")
	var maker = $Marker2D
	var damage_digit = damage_digit_scene.instantiate()
	damage_digit.value = amount
	
	damage_digit.global_position = maker.global_position
	
	get_parent().add_child(damage_digit)
	damageAnimation()
	
	if health <= 0 :
		die()

func die():
	if death_animiation:
		var death = death_animiation.instantiate()
		death.position = position
		get_parent().add_child(death)
	
	GameManager.monster_counter += 1
	if randf() <= drop_chance: drop_item()
	queue_free()

func damageAnimation():
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	

func drop_item():
	var item = chose_item().instantiate()
	item.position = position
	get_parent().add_child(item)

func chose_item() -> PackedScene:
	if drops.size() == 1:
		return drops[0]
	
	var max_value: float = 0.0
	for i in drop_rare:
		max_value += drop_rare[i]
	
	var random_value = randf() * max_value
	
	var neddle: float = 0.0
	for i in drops.size():
		var drop = drops[i]
		var chance = drop_rare[i] if i < drop_rare.size() else 1
		if random_value <= chance + neddle:
			return drop
		neddle += chance
	
	return drops[0]
