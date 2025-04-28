extends Node3D
class_name Door

@export var outlet_reference : LaserOutlet

@export var open_animation_clip : String
@export var close_animation_clip : String

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	outlet_reference.on_laser_hit.connect(open_door)
	outlet_reference.on_laser_exit.connect(close_door)
	close_door()

func open_door() -> void:
	animation_player.play(open_animation_clip)

func close_door() -> void:
	animation_player.play(close_animation_clip)
