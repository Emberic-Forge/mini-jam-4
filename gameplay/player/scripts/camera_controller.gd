extends Node3D
class_name CameraController

@export var default_sensitivity : float = 0.5
@export var min_vertical_rotation : float = -30
@export var max_vertical_rotation : float = 60

var sensitivity : float
var camera_input_direction : Vector2

func _ready() -> void:
	sensitivity = Blackboard.get_or_add("sensitivity", default_sensitivity)

func _unhandled_input(event : InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	)

	if is_camera_motion:
		camera_input_direction = event.screen_relative * sensitivity

func _process(delta : float) -> void:
	handle_camera_control(delta)

func handle_camera_control(delta : float) -> void:
	rotation.x -= camera_input_direction.y * delta
	rotation.x = clamp(rotation.x, deg_to_rad(min_vertical_rotation), deg_to_rad(max_vertical_rotation))

	rotation.y -= camera_input_direction.x * delta
	camera_input_direction = Vector2.ZERO
