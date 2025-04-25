extends Resource
class_name PlayerSettings

@export_group("Movement")
@export var movement_speed_in_meters : float
@export var jump_height_in_meters : float
@export_group("Input")
@export var move_left_action : String
@export var move_right_action : String
@export var move_forward_action : String
@export var move_backward_action : String
@export var jump_action : String
