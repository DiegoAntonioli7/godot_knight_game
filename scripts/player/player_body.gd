class_name Player
extends CharacterBody2D

@export var speed: float = 5
@export var streaght: int = 2

@export var health: int = 50
@export var death_animiation : PackedScene
@export var max_health: int = 50

@export var ritual_damage = 2
@export var ritual_interval: float = 30.0
@export var ritual_scene : PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_player :Sprite2D = $Sprite2D
@onready var hit :Area2D = $Area2D
@onready var hitBox :Area2D = $HitBox
@onready var health_bar: ProgressBar = $ProgressBar

signal meat_collect(value: int)

var is_atacking: bool = false
var is_running: bool = false
var attack_cooldown = 0.6
var hitbox_ocoldown = 0.5
var ritual_cooldown = 0.0

func _ready():
	GameManager.player = self
	meat_collect.connect(func(value: int): GameManager.meat_count += 1)

func _physics_process(delta):
	GameManager.player_position = position
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down",0.15)
	var velocity_player = input_vector * speed * 100
	if is_atacking:
		velocity_player *= 0.25
	velocity = lerp(velocity,velocity_player,0.5)
	
	move_and_slide()
	check_if_damage(delta)
	var was_running = is_running
	is_running = not input_vector.is_zero_approx()
	if not is_atacking:
		if is_running != was_running:
			if is_running:
				animation_player.play("run_animation")
			else:
				animation_player.play("idle_animation")
	test_cooldown_attack(delta)
	if Input.is_action_just_pressed("attack"):
		atack()
	
	health_bar.max_value = max_health
	health_bar.value = health
	ritual(delta)
	
	if input_vector.x  > 0 and not is_atacking:
		sprite_player.flip_h = false
	elif input_vector.x  < 0 and not is_atacking:
		sprite_player.flip_h = true	


func ritual(delta):
	ritual_cooldown -= delta
	if ritual_cooldown > 0 :return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	ritual.damage = ritual_damage
	add_child(ritual)

func test_cooldown_attack(delta):
	if is_atacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_atacking = false
			is_running = false
			animation_player.play("idle_animation")

func atack():
	if is_atacking:
		return
	attack_cooldown = 0.6
	animation_player.play("atk_side_01_animation")
	is_atacking = true
	

func deal_damage():
	var bodies = hit.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction : Vector2
			if sprite_player.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_produt = direction_to_enemy.dot(attack_direction)
			if dot_produt >= 0.3:
				enemy.damage(streaght)

func check_if_damage(delta):
	hitbox_ocoldown -= delta
	if hitbox_ocoldown > 0:return
	hitbox_ocoldown = 0.5
	
	var bodies = hitBox.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)


func damage(amount: int):
	health -= amount
	print("tomou dano")
	
	damageAnimation()
	
	if health <= 0 :
		die()

func die():
	GameManager.end_game()
	if death_animiation:
		var death = death_animiation.instantiate()
		death.position = position
		get_parent().add_child(death)
	queue_free()

func heal(amount):
	health += amount
	if health > max_health:
		health = max_health
	print("hellou")

func damageAnimation():
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
