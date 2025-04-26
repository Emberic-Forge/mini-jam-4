extends Node
class_name RefractorController

@export var scope_action : String

@onready var refractor : Refractor = $"../Avatar/Refractor"

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed(scope_action):
		refractor.start_refracting()
	#elif Input.is_action_just_released(scope_action):
		#refractor.stop_refracting()
