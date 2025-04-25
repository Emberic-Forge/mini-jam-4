extends Node3D
class_name BeamEmitter

@onready var shape_cast_3d : ShapeCast3D = $ShapeCast3D
@onready var beam : MeshInstance3D = $Beam


func _physics_process(_delta : float) -> void:
	update_beam_path()
	if shape_cast_3d.is_colliding():
		var refractor_owner = has_collided_a_refractor()
		if refractor_owner:
			notify_refractor_owner(refractor_owner)
	print("is currently colliding: %s" % ("Yes" if shape_cast_3d.is_colliding() else "No"))

func update_beam_path() -> void:
	# Get the start and end pos (hit element)
	var result := shape_cast_3d.collision_result

	var start_pos := shape_cast_3d.global_position
	var end_pos : Vector3 = result[0].point if not result.is_empty() else start_pos + (shape_cast_3d.global_transform * shape_cast_3d.target_position)

	# Set beam mesh pos to be between the first hit element and the emitter.
	var mid_point = (start_pos + end_pos) / 2.0
	mid_point.y = global_position.y
	beam.global_position = mid_point

	# Rotate the beam mesh so that the top faces the hit element
	var end_dir = (start_pos - end_pos).normalized()
	end_dir.y = 0
	# Use Y as forward — build a basis where Y points toward the direction
	var new_basis = Basis()
	new_basis.y = end_dir # Y points at the direction

	# Compute orthogonal axes (X and Z) to form a proper rotation matrix
	# Choose a fallback for X (avoid colinearity)
	var fallback = Vector3(0, 0, 1) if abs(end_dir.dot(Vector3.FORWARD)) < 0.99 else Vector3.RIGHT
	new_basis.x = fallback.cross(new_basis.y).normalized()
	new_basis.z = new_basis.x.cross(new_basis.y).normalized()
	# Apply new basis
	beam.global_transform.basis = new_basis.orthonormalized()

	# Scale the beam on the Y axis based on the distance between the start and end_pos
	var scale_factor := (start_pos - end_pos).length() / 2.0
	beam.scale = Vector3(shape_cast_3d.shape.radius, scale_factor + 0.1, shape_cast_3d.shape.radius)
	pass

func has_collided_a_refractor() -> Variant:
	return null

func notify_refractor_owner(owner : Variant) -> void:
	pass
