class_name RemapButton extends HBoxContainer

@export var input_action : String

@onready var input_name : Label = get_child(0)
@onready var button : Button = get_child(1)

func _ready() -> void:
	assert(!input_action.is_empty(), "Attempted to assign a null action!")

	name = "remap_%sbutton" % input_action

	input_name.name = "input_name_%s" % input_action

	button = get_child(1)
	button.name = "button_%s" % input_action

	button.toggled.connect(_rebind_key)

	set_process_unhandled_key_input(false)
	_display_current_key()

func _rebind_key(is_button_pressed : bool) -> void:
	if input_action.is_empty():
		push_warning("Missing action in %s" % get_path())
		return

	set_process_unhandled_key_input(is_button_pressed)
	if is_button_pressed:
		button.text = "<press a key>"
		modulate = Color.YELLOW
		release_focus()
	else:
		_display_current_key()
		modulate = Color.WHITE
		# Grab focus after assigning a key, so that you can go to the next
		# key using the keyboard.
		grab_focus()

# NOTE: You can use the `_input()` callback instead, especially if
# you want to work with gamepads.
func _unhandled_key_input(event: InputEvent) -> void:
	# Skip if pressing Enter, so that the input mapping GUI can be navigated
	# with the keyboard. The downside of this approach is that the Enter
	# key can't be bound to actions.
	if event is InputEventKey and event.keycode != KEY_ENTER:
		remap_action_to(event)
		button.button_pressed = false

func remap_action_to(event: InputEvent) -> void:
	if input_action.is_empty():
		push_warning("Missing action in %s" % get_path())
		return
	# We first change the event in this game instance.
	InputMap.action_erase_events(input_action)
	InputMap.action_add_event(input_action, event)
	# And then save it to the keymaps file.
	KeyPersistence.keymaps[input_action] = event
	KeyPersistence.save_keymap()
	button.text = event.as_text()

func _display_current_key() -> void:
	if input_action.is_empty():
		push_warning("Missing action in %s" % get_path())
		return
	var current_key := InputMap.action_get_events(input_action)[0].as_text()
	button.text = current_key
	input_name.text = _format_action_name(input_action)

func _format_action_name(action : String) -> String:
	var result : String = ""
	var regex := RegEx.new()
	var status := regex.compile("[_,.!:]")
	var input := action

	assert(status == OK, "Regex failed - %s!" % status)

	# Remove all marked characters in the regex and replace them with white space
	var regex_results := regex.search_all(action)
	if regex_results:
		for regex_result in regex_results:
			input = action.replace(regex_result.get_string(), " ")

	# Split the input into several words if there is any white space
	var words := input.split(" ", false)
	for i in range(words.size()):
		if words[i].length() > 0:
			words[i] = words[i][0].to_upper() + words[i].substr(1).to_lower()

	# Join the result
	result = " ".join(words)

	return result
