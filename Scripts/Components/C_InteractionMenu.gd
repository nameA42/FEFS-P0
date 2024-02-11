extends Node2D

@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
@onready var ID = root.DEFAULT_ID
var inited = false
var Stats : Node2D = null

var interaction_mode = 0

@onready var combat_manager = root.combat_manager
@onready var faction_manager = root.faction_manager
@onready var ID_manager = root.ID_manager
@onready var combat_display_manager = root.combat_display_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	await root.ready
	ID = parent.ID
	Stats = parent.get_node("C_Stats")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func selection(sel : int):
	if(sel == 0):
		combat_display_manager.combat_display_manager.display_reachable_area(ID, Stats.speed)
		interaction_mode = 0
	if(sel == 1):
		combat_display_manager.combat_display_manager.display_in_range_area(ID, Stats.rng)
		interaction_mode = 1
