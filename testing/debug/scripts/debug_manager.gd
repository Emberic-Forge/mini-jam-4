@tool
extends Control

var _elements : Dictionary = {} # Store pooled HandleLabels

func _ready() -> void:
	z_index = 1000

func draw_label(owner: Node3D, position : Vector3, text : String) -> void:
	if !OS.has_feature('debug'):
		return
	# Get a caller id
	var id := generate_caller_id(owner)
	var label : HandleLabel
	# Add or Get a label
	if _elements.has(id):
		label = _elements[id] as HandleLabel
	else:
		label = HandleLabel.new()
		_elements[id] = label
		add_child(label)

	#Fetch the viewport camera
	var cam := get_viewport().get_camera_3d()
	if !cam:
		return
	#Unproject the 3d position back to screen space.
	var pos_2d := cam.unproject_position(position)

	#Apply the settings to the label
	label.global_position = pos_2d
	label.text = text
	label.visible = not cam.is_position_behind(position)

func draw_3d_line(owner : Node3D, start : Vector3, end : Vector3, width : float, color : Color = Color.WHITE) -> void:
	if !OS.has_feature('debug'):
		return
	var id := generate_caller_id(owner)
	var line : HandleLine
	# Add or Get a label
	if _elements.has(id):
		line = _elements[id]
	else:
		line = HandleLine.new()
		_elements[id] = line
		add_child(line)

	var cam := get_viewport().get_camera_3d()
	if !cam:
		return
	#Unproject the 3d position back to screen space.
	line.start_pos = cam.unproject_position(start)
	line.end_pos = cam.unproject_position(end)
	line.color = color
	line.width = width

	line.visible = not cam.is_position_behind(start)


func generate_caller_id(owner : Node3D) -> String:
	var stack := get_stack()
	if stack.size() > 1:
		var caller_info = stack[2]
		return "%s/%s:%d" % [caller_info.source,owner.get_path(), caller_info.line]
	return owner.name

func _process(_delta : float) -> void:
	if !OS.has_feature('debug'):
		return
	for key in _elements.keys():
		var label : Control = _elements[key]
		label.visible = false
