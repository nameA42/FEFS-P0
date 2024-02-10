extends Node2D

@onready var parent = get_parent()
@onready var _root = get_tree().root.get_child(0)
var ID = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	ID = parent.ID

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Act():
	var closest_ID = _root.get_closest_faction_member(1, _root.Location[ID])
	if(_root.get_in_range_area(ID, parent.rang).has(_root.Location[closest_ID])):
		_root.inter(ID, closest_ID)
	elif(!parent.moved):
		_root.actor_move(ID, _root.Location[closest_ID], parent.speed)
