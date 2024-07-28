extends CanvasLayer



@onready var label_meat : Label = %labelMeat
@onready var label_timer : Label = %labelTimer




func _process(delta):
	label_meat.text = str(GameManager.meat_count)
	label_timer.text = GameManager.time_elapsed_string

