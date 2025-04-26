extends StaticBody3D
class_name Refractor

#@onready var local_emitter : BeamEmitter = $LocalEmitter
#
#var should_refract : bool
#
#func _ready() -> void:
	#local_emitter.disable_emission()
#
#func start_refracting() -> void:
	#local_emitter.enable_emission()
#
#func stop_refracting() -> void:
	#local_emitter.disable_emission()
#
#func apply_new_data_on_refraction(new_data : BeamEmissionColor) -> void:
	#local_emitter.beam_settings = new_data
