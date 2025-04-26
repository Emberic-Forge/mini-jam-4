extends StaticBody3D
class_name BeamRedirector

enum REDIRECT_FACING {Forward, Mirror}

@export var facing_type : REDIRECT_FACING

func redirect_beam(incoming_basis : Basis) -> Beam:
	var beam : Beam = preload("res://gameplay/beam/beam.tscn").instantiate()
	beam.global_position = global_position
	beam.global_basis = calculate_angle(facing_type, incoming_basis)
	return beam

func calculate_angle(type : REDIRECT_FACING, incoming_basis : Basis) -> Basis:
	match type:
		REDIRECT_FACING.Forward:
			return global_basis
		REDIRECT_FACING.Mirror:
			# Reflect the beam direction across the mirror's normal
			var normal = global_basis.z.normalized()
			var incoming_direction = incoming_basis.z.normalized()
			var reflected_direction = incoming_direction.bounce(normal).normalized()

			var new_basis = Basis()
			new_basis.z = reflected_direction
			new_basis.x = reflected_direction.cross(Vector3.UP).normalized()
			new_basis.y = new_basis.z.cross(new_basis.x).normalized()
			return new_basis

	return Basis()
