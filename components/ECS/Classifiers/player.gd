extends Ally
class_name Player

var disable_controls : bool = false

func _ready() -> void:
	super._ready()
	add_to_group("players")
	var controller = PlayerController.new()
	add_child.call_deferred(controller)
	var myCAM = CAM.new()
	myCAM.target = self
	add_child.call_deferred(myCAM)
	controller.cam.connect(Callable(myCAM, "set_target_offset"))
	var myEars = AudioListener2D.new()
	add_child.call_deferred(myEars)
	myEars.make_current()
