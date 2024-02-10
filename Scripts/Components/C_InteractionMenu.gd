extends Node2D

@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
var ID = -1
var inited = false
@onready var Stats : Node2D = get_node("C_Stats")

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	ID = parent.ID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func selection(sel : int):
	if(sel == 0):
		root.display_reachable_area(ID, Stats.speed)
		parent.InterMode = 0
	if(sel == 1):
		root.display_in_range_area(ID, Stats.rng)
		parent.InterMode = 1
