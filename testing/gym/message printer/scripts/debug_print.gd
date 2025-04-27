extends Node3D

@onready var laser_outlet : LaserOutlet = $LaserOutlet

@export var message : String

var print_message : bool

func _ready() -> void:
	laser_outlet.on_laser_hit.connect(start_printing_message)
	laser_outlet.on_laser_exit.connect(stop_printing_message)

func start_printing_message() -> void:
	print_message = true

func stop_printing_message() -> void:
	print_message = false

func _process(_delta : float) -> void:
	if print_message:
		CustomDebug.draw_label(self, global_position + Vector3.UP, message)
