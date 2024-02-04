extends Button

@export var command: Script

signal cursor_selected()

func _ready():
	pass

func cursor_select() -> void:
	if !command:
		print("ERROR: No command script attached inside button's menu item script!")
		return
	
	emit_signal("cursor_selected")
