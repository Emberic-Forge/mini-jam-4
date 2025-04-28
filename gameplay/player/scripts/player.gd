extends Node3D
class_name Player

@onready var refractor : Refractor = $Avatar/CameraRotator/Refractor
@onready var interactor : InteractionController = $Avatar/Interactor

func _ready() -> void:
	interactor.controller_owner = self

func get_interactor() -> InteractionController:
	return interactor

func get_refractor() -> Refractor:
	return refractor
