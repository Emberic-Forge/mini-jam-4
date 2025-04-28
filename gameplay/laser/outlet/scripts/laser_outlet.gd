extends StaticBody3D
class_name LaserOutlet

@export var desired_laser_id : int

var is_triggered : bool

signal on_laser_hit
signal on_laser_exit

func _ready() -> void:
	LaserEventBus.on_enter.connect(trigger_event)
	LaserEventBus.on_exit.connect(reset_event)

func trigger_event(incoming_laser : Laser3D, target : Node3D) -> void:
	if self != target:
		return
	var is_laser_valid_id = desired_laser_id == incoming_laser.id || desired_laser_id == 0
	if  is_laser_valid_id && !is_triggered:
		is_triggered = true
		on_laser_hit.emit()

func reset_event(incoming_laser : Laser3D, target : Node3D) -> void:
	if self != target:
		return
	if is_triggered:
		on_laser_exit.emit()
		is_triggered = false
