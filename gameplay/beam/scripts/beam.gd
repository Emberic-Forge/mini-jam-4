extends Node3D
class_name Beam

@export var beam_settings : BeamEmissionColor
@export var beam_size : float = .25

@onready var ray_cast_3d : RayCast3D = $RayCast3D
@onready var visual : MeshInstance3D = $Visual

var redirected_beam : Beam

func _ready() -> void:
	update_beam_color(beam_settings.beam_color)

func _physics_process(_delta : float) -> void:
	handle_collisions()
	update_beam_visuals()

func handle_collisions() -> void:
	ray_cast_3d.force_raycast_update()
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()

		match typeof(collider):
			BeamRedirector:
				if !redirected_beam:
					var redirector = collider as BeamRedirector
					redirected_beam = redirector.redirect_beam(global_basis)
			#BeamOutlet:
				#try_removing_redirected_beam()
				#return
		try_removing_redirected_beam()

func try_removing_redirected_beam() -> void:
	if redirected_beam:
		redirected_beam.queue_free()
		redirected_beam = null

func update_beam_visuals() -> void:
	# Get the start and end pos (hit element)
	var result : Vector3 = ray_cast_3d.get_collision_point()
	var origin := ray_cast_3d.global_position

	var max_dist_end_pos =  origin + (ray_cast_3d.global_transform * ray_cast_3d.target_position)

	# Set start and end points
	var start_pos := origin
	var end_pos : Vector3 = result if ray_cast_3d.is_colliding() else max_dist_end_pos

	# Set beam mesh pos to be between the first hit element and the emitter.
	var mid_point = (start_pos + end_pos) / 2.0
	#mid_point.y = global_position.y
	visual.global_position = mid_point

	# Rotate the beam mesh so that the top faces the hit element
	var end_dir = (start_pos - end_pos).normalized()

	# Use Y as forward — build a basis where Y points toward the direction
	var new_basis = Basis()
	new_basis.y = end_dir # Y points at the direction

	# Compute orthogonal axes (X and Z) to form a proper rotation matrix
	# Choose a fallback for X (avoid colinearity)
	var fallback = Vector3(0, 0, 1) if abs(end_dir.dot(Vector3.FORWARD)) < 0.99 else Vector3.RIGHT
	new_basis.x = fallback.cross(new_basis.y).normalized()
	new_basis.z = new_basis.x.cross(new_basis.y).normalized()
	# Apply new basis
	visual.global_transform.basis = new_basis.orthonormalized()
	# Scale the beam on the Y axis based on the distance between the start and end_pos
	var scale_factor := (start_pos - end_pos).length() / 2.0
	visual.scale = Vector3(beam_size / 2.0, scale_factor + 0.1, beam_size / 2.0)

func update_beam_color(new_color : Color) -> void:
	var mat3D := visual.material_override as StandardMaterial3D
	mat3D.albedo_color = new_color

func get_beam_settings() -> BeamEmissionColor:
	return beam_settings
