extends Node3D
class_name Refractor

@export var scope_action : String
@export var fire_action : String
@export var desired_laser_id : int

@onready var laser_preview : Laser3D = $LaserPreview

var power_state : bool
var incoming_laser : Laser3D

func _ready() -> void:
	LaserEventBus.on_enter.connect(give_power)
	LaserEventBus.on_exit.connect(lose_power)

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

func _process(_delta : float) -> void:
	var input := Input.is_action_pressed(scope_action)
	var active_state := power_state && input

	laser_preview.set_active(active_state)

	if !active_state || !incoming_laser:
		return
	laser_preview.update_color(desired_laser_id)
	#print("Currently using the beam")
