extends StaticBody3D
class_name Redirector

enum MODE {OVERRIDE, MIRROR, LENS}

@export var redirect_mode : MODE
@export var override_id : int

@onready var laser  : Laser3D = $Offset/Laser
@onready var mesh_instance_3d : MeshInstance3D = $MeshInstance3D
@onready var offset : Node3D = $Offset



func is_already_redirecting() -> bool:
	return laser.enabled

func _ready() -> void:
	LaserEventBus.on_enter.connect(redirect)
	LaserEventBus.on_stay.connect(redirect_update)
	LaserEventBus.on_exit.connect(stop_redirecting)

	InteractionEventBus.on_interact.connect(remove_self)

	tree_exiting.connect(func():
		LaserEventBus.on_enter.disconnect(redirect)
		LaserEventBus.on_stay.disconnect(redirect_update)
		LaserEventBus.on_exit.disconnect(stop_redirecting)
		)

	laser.add_exception(self)
	laser.set_active(false)

func remove_self(caller : InteractionController, target : Node3D) -> void:
	if self != target and self != target.get_parent():
		return
	laser.set_active(false)
	if OS.has_feature('debug'):
		print("[LOG][Redirect][%s]: Stopped redirecting!" % get_path())
	queue_free()


func redirect(incoming_laser : Laser3D, target : Node3D) -> void:
	if self != target:
		return

	if redirect_mode == MODE.LENS:
		apply_color(override_id)
	else:
		apply_color(incoming_laser.id)

	laser.set_active(true)
	if OS.has_feature('debug'):
		print("[LOG][Redirect][%s]: Laser redirected!" % get_path())

func redirect_update(incoming_laser : Laser3D, target : Node3D) -> void:
	if self != target:
		return
	update_direction(incoming_laser)

#func _process(_delta : float) -> void:
	#if laser.enabled:
		#CustomDebug.draw_label(self, laser.global_position, "Redirected Laser")

func stop_redirecting(incoming_laser : Laser3D, target : Node3D) -> void:
	if self != target:
		return

	laser.set_active(false)
	if OS.has_feature('debug'):
		print("[LOG][Redirect][%s]: Stopped redirecting!" % get_path())

func update_direction(incoming_laser : Laser3D) -> void:
	var incoming_dir := (global_position - incoming_laser.global_position).normalized()
	match redirect_mode:
		MODE.OVERRIDE:
			offset.global_basis = rotate_towards(-global_basis.z)
			offset.position = Vector3.ZERO
		MODE.MIRROR:
			var normal := incoming_laser.get_collision_normal().normalized()
			var point := incoming_laser.get_collision_point()
			if normal == Vector3.ZERO:
				return
			offset.global_basis = rotate_towards(-incoming_dir.bounce(normal))
			offset.position = to_local(point)

			CustomDebug.draw_label(self, offset.global_position, "x:%f,y:%f,z:%f" % [offset.position.x, offset.position.y, offset.position.z])
			CustomDebug.draw_3d_line(self, point, point + normal,4, Color.YELLOW)

		MODE.LENS:
			offset.global_basis = rotate_towards(-incoming_dir)
			offset.position = Vector3.ZERO

func apply_color(id : int) -> void:
	laser.update_color(id)

func rotate_towards(direction : Vector3, up_direction : Vector3 = Vector3.UP) -> Basis:
	return Transform3D.IDENTITY.looking_at(direction, up_direction).basis

func set_mesh_visible(new_state : bool) -> void:
	mesh_instance_3d.visible = new_state
