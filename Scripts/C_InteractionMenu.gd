extends Node2D

@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID = -1
var inited = false
@onready var Stats : Node2D = get_node("C_Stats")

# Called when the node enters the scene tree for the first time.
func _ready():
	await par.ready
	ID = par.ID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func selection(sel : int):
	if(sel == 0):
		rt.display_reachable_area(ID, Stats.speed)
		par.InterMode = 0
	if(sel == 1):
		rt.display_inrange_area(ID, Stats.rng)
		par.InterMode = 1
