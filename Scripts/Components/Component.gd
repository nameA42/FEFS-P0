class_name Component extends Node2D

var ID
@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
@onready var combat_manager = root.combat_manager
@onready var faction_manager = root.faction_manager
@onready var ID_manager = root.ID_manager
@onready var combat_display_manager = root.combat_display_manager
@onready var astar_manager = root.astar_manager
@onready var move_manager = root.move_manager

func _ready():
	await parent.ready
	await root.ready
	ID = parent.ID
