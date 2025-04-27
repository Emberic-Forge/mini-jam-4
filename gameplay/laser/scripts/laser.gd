extends RayCast3D
class_name Laser3D

@export var id : int
@export var affect_outlets : bool = true

@onready var laser_mesh : MeshInstance3D = $LaserMesh

var last_collided_entity : Node3D

static var laser_color : Array[Color] = [Color.WHITE, Color.RED, Color.GREEN, Color.BLUE]

func _ready() -> void:
	update_color(id)

func _process(_delta : float) -> void:
	if last_collided_entity:
		CustomDebug.draw_label(self, global_position + Vector3.UP, last_collided_entity.name)

	var cast_point : Vector3 = target_position
	force_raycast_update()

	if is_colliding() && enabled:
		var collider = get_collider() as Node3D
		# Handle Events
		if last_collided_entity == null:
			last_collided_entity = collider
			LaserEventBus.on_enter.emit(self, collider)
		elif last_collided_entity != collider:
			#print("[LOG][Laser][%s]: Collider (%s) exited the laser" % [get_path(), last_collided_entity.name])
			LaserEventBus.on_exit.emit(self, last_collided_entity)
			#print("[LOG][Laser][%s]: Collider (%s) entered the laser" % [get_path(), collider.name])
			LaserEventBus.on_enter.emit(self, collider)
			last_collided_entity = collider
		else:
			LaserEventBus.on_stay.emit(self, collider)

		cast_point = to_local(get_collision_point())
	else:
		if last_collided_entity:
			LaserEventBus.on_exit.emit(self, last_collided_entity)
			last_collided_entity = null

	# Update visuals
	laser_mesh.mesh.height = cast_point.y
	laser_mesh.position.y = cast_point.y/2

func update_color(new_id : int) -> void:
	var new_color := Laser3D.laser_color[new_id]
	var mat3D := laser_mesh.material_override as StandardMaterial3D
	var original_color := mat3D.albedo_color

	mat3D.albedo_color = Color(new_color, original_color.a)
	mat3D.emission = new_color

	id = new_id

func set_active(new_state : bool) -> void:

	enabled = new_state
	laser_mesh.visible = new_state
	#force_raycast_update()
	#print("[LOG][Laser][%s]: Laser %s!" % [get_path(), ("enabled" if enabled else "disabled")])
