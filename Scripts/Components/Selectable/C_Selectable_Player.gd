class_name CSelectablePlayer extends Node2D

@export var selectable = true


func _ready():
	get_parent().selected.connect(on_selected)
	get_parent().selected.connect(on_deselected)
	
func on_selected():
	print("Selected!")

func on_deselected():
	print("Selected!")
