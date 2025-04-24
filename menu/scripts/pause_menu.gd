extends CanvasLayer

func _ready() -> void:
	PauseSystem.pause_game = true
	PauseSystem.starting_element_to_enter = self

	PauseSystem.paused_mouse_mode =  Input.MOUSE_MODE_VISIBLE
	PauseSystem.unpaused_mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.mouse_mode = PauseSystem.unpaused_mouse_mode

	visible = false
