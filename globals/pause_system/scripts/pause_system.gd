extends Node

@export var pause_key : String

var element_stack : Array[Node]

var starting_element_to_enter : Node
var pause_game : bool
var paused_mouse_mode : int
var unpaused_mouse_mode : int

var _not_in_the_game : bool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_window().focus_exited.connect(func(): _not_in_the_game = true)


func _process(_delta : float) -> void:
	if Input.is_action_just_pressed(pause_key) || _not_in_the_game:
		if  element_stack.is_empty():
			if starting_element_to_enter:
				enter_element(starting_element_to_enter)
			_not_in_the_game = false
		else:
			exit_element()

func enter_element(new_element : Node, hide_parent : bool = false) -> void:
	if element_stack.is_empty() && pause_game:
		get_tree().paused = true
		Input.mouse_mode = paused_mouse_mode
	else:
		_update_parent(hide_parent)
	new_element.visible = true
	element_stack.push_back(new_element)


func exit_element() -> void:
	var element = element_stack.pop_back()
	element.visible = false
	if element_stack.is_empty():
		get_tree().paused = false
		Input.mouse_mode = unpaused_mouse_mode

func _update_parent(hide_elements) -> void:
	if element_stack.is_empty():
		return
	var parent = element_stack.get(element_stack.size() - 1)
	parent.visible = !hide_elements

func clear_element_stack() -> void:
	element_stack.clear()
