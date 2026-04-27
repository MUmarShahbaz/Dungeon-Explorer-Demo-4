extends Resource
class_name Objective

@export var checked : bool
@export var text : String
@export var subobjectives : Array[Objective]

func _init(_checked : bool = false, _text : String = "", _subobjectives : Array[Objective] = []) -> void:
	checked = _checked
	text = _text
	subobjectives = _subobjectives
