extends Node3D

@onready var csg_baked_mesh_instance_3d : MeshInstance3D = $StaticBody3D/CSGBakedMeshInstance3D
@onready var laser  : Laser3D = $StaticBody3D/Laser

#func _ready() -> void:
	#var mat3D := csg_baked_mesh_instance_3d.mesh.surface_get_material(1) as StandardMaterial3D
	#mat3D.emission = Laser3D.laser_color[laser.id]
	#mat3D.albedo_color = Laser3D.laser_color[laser.id]
