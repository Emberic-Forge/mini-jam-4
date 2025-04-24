extends Node

@export var variables : Dictionary[String, Variant]

func verify_variable(name : String, type : Variant.Type = TYPE_NIL) -> void:
	assert(variables[name], "Entry %s is null")
	if type:
		assert(typeof(variables[name]) == type, "Entry %s is not of type %s" % [name, type])

func get_variable(name : String) -> Variant:
	verify_variable(name)
	return variables[name]

func set_variable(name : String, value : Variant) -> void:
	if not is_numeric(value):
		assert(value, "Value is null for entry %s" % name)
	variables[name] = value

func get_int(name : String) -> int:
	verify_variable(name, TYPE_INT)
	return variables[name] as int

func get_float(name : String) -> float:
	verify_variable(name, TYPE_FLOAT)
	return variables[name] as float

func get_boolean(name : String) -> bool:
	verify_variable(name, TYPE_BOOL)
	return variables[name] as bool

func get_string(name : String) -> String:
	verify_variable(name, TYPE_STRING)
	return variables[name] as String

func is_numeric(value : Variant) -> bool:
	return value is float or value is int
