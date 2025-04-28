extends StaticBody3D
class_name RefractorResupply

@export var refractor_usage_given : int = 1

func _ready() -> void:
	InteractionEventBus.on_interact.connect(resupply_caller)

func resupply_caller(caller : InteractionController, target : Node3D) -> void:
	if self != target:
		return
	var refractor := caller.get_player().get_refractor() as Refractor
	refractor.add_usage(refractor_usage_given)
