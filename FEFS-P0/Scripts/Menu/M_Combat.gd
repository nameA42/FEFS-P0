class_name M_Combat extends Control

var actor_owner: Node2D
@onready var sample_button = preload("res://Objects/M_Element.tscn")

func _ready():
	pass
# Create all buttons
# Connect them to the master on pressed thing
# Connect them (outside of code?) to the functions they perform

func add_option(name: String) -> Button:
	var element: Button = sample_button.instantiate() as Button
	element.text = name
	find_child("VBoxContainer").add_child(element)
	return element
	
