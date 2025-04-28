extends Area3D
class_name InteractionController

@onready var interact_hud : CanvasLayer = $"Interact HUD"
@onready var popup : Control = $"Interact HUD/Popup"
@onready var text : RichTextLabel = $"Interact HUD/Popup/Text"

@export var interact_action : String

var latest_detected_entity : Node3D
var popup_offset : Vector2
var controller_owner : Player

func get_player() -> Node3D:
	return controller_owner

func _ready() -> void:
	popup_offset = popup.position
	var is_valid := InputMap.has_action(interact_action)
	text.text = "Interact [%s]" %  InputMap.action_get_events(interact_action)[0].as_text() if is_valid else "NaN"

func _on_body_entered(body : Variant) -> void:
	latest_detected_entity = body
	interact_hud.visible = true


func _on_body_exited(body : Variant) -> void:
	latest_detected_entity = null
	interact_hud.visible = false

func _process(_delta : float) -> void:
	if !latest_detected_entity:
		return

	popup.position = from_3d(latest_detected_entity.global_position) + popup_offset

	if Input.is_action_just_pressed(interact_action):
		InteractionEventBus.on_interact.emit(self, latest_detected_entity)

func from_3d(vector3 : Vector3) -> Vector2:
	var cam := get_viewport().get_camera_3d()
	return cam.unproject_position(vector3)
