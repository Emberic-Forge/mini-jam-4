extends Node3D
class_name Refractor

@export var scope_action : String
@export var fire_action : String
@export var desired_laser_id : int

@onready var laser_preview : Laser3D = $LaserPreview

var power_state : bool
var incoming_laser : Laser3D
var refraction_usage_left : int



func _ready() -> void:
	LaserEventBus.on_enter.connect(give_power)
	LaserEventBus.on_exit.connect(lose_power)
	refraction_usage_left = 0

func give_power(incoming_laser : Laser3D, target : Node3D) -> void:
	if self != target:
		return
	power_state = true
	self.incoming_laser = incoming_laser

func lose_power(incoming_laser : Laser3D, target : Node3D) -> void:
	if self != target:
		return
	power_state = false
	self.incoming_laser = null

func add_usage(amount : int) -> void:
	refraction_usage_left += amount

func _process(_delta : float) -> void:
	var preview_input := Input.is_action_pressed(scope_action)
	var active_state := power_state && preview_input

	laser_preview.set_active(active_state)

	if !active_state || !incoming_laser || refraction_usage_left <= 0:
		return
	laser_preview.update_color(desired_laser_id)

	var fire_input := Input.is_action_just_pressed(fire_action)

	if fire_input:
		place_refractor_entity()
		refraction_usage_left -= 1

func place_refractor_entity() -> void:
	const REDIRECTOR = preload("res://gameplay/player/refractor/interactable_redirector.tscn")
	var redirector := REDIRECTOR.instantiate() as Redirector
	get_tree().current_scene.add_child(redirector)

	var refractor_basis := global_basis
	var refractor_pos := global_position

	redirector.global_basis = refractor_basis
	redirector.global_position = refractor_pos
