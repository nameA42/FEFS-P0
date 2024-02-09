extends Node2D

@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	await par.ready
	ID = par.ID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Act():
	var cloID = rt.getClosestFactionMember(1, rt.Location[ID])
	if(rt.get_inrange_area(ID, par.rang).has(rt.Location[cloID])):
		rt.inter(ID, cloID)
	elif(!par.moved):
		rt.move(ID, rt.Location[cloID], par.speed)
