extends Control

@export var actor_owner: CharacterBody2D

func _ready():
	var buttons = find_children("", "Button", true)
	for b in buttons:
		b.parent = self
