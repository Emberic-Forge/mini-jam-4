class_name HBlackboardSlider extends HSlider

@export var blackboard_variable : String

func _ready() -> void:
	value = Blackboard.get_float(blackboard_variable)
	value_changed.connect(_update_blackboard)

func _update_blackboard(value : float) -> void:
	Blackboard.set_variable(blackboard_variable, value)
