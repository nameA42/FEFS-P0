class_name Component extends Node2D

var ID
@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)

var combat_manager
var faction_manager
var ID_manager
var combat_display_manager
var astar_manager
var move_manager
var tile_map

func _ready():
	await parent.ready
	await root.ready
	
	combat_manager = root.combat_manager
	faction_manager = root.faction_manager
	ID_manager = root.ID_manager
	combat_display_manager = root.combat_display_manager
	astar_manager = root.astar_manager
	move_manager = root.move_manager
	tile_map = root.tile_map
	ID = parent.ID

