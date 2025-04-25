extends CharacterBody3D
class_name MovementController

@export var player_settings : PlayerSettings

@onready var camera_anchor : Node3D = $CameraArm/CameraAnchor
@onready var gravity_dir = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
@onready var gravity_amm = ProjectSettings.get_setting("physics/3d/default_gravity")

func calculate_ground_movement() -> void:
	var local_x_input : Vector3 = camera_anchor.global_basis.x * Input.get_axis(player_settings.move_left_action, player_settings.move_right_action)
	var local_z_input : Vector3 = camera_anchor.global_basis.z * Input.get_axis(player_settings.move_forward_action, player_settings.move_backward_action)
	var input_dir = local_x_input + local_z_input
	velocity.x = input_dir.x * player_settings.movement_speed_in_meters
	velocity.z = input_dir.z * player_settings.movement_speed_in_meters


func calculate_jump_velocity() -> void:
	var jump_velocity = sqrt(2 * gravity_amm * player_settings.jump_height_in_meters)
	velocity += -gravity_dir * jump_velocity

func apply_gravity(delta : float) -> void:
	velocity += gravity_dir * gravity_amm * delta

func _process(delta : float) -> void:
	if Input.is_action_just_pressed(player_settings.jump_action) and is_on_floor():
		calculate_jump_velocity()

func _physics_process(delta : float) -> void:
	apply_gravity(delta)
	calculate_ground_movement()

	move_and_slide()
