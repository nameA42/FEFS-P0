extends Node2D

@onready var rt = get_tree().root.get_child(0)

@export var Location : Array
var IDToObj : Array
@export var OpenIDs : Array
var OpenIDN = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_id(loc, EID=-1):
	for i in Location.size():
		if(loc == Location[i] && i != EID && OpenIDs[i] != 0):
			return i
	return -1

func give_id():
	print("giving id")
	if(OpenIDN == 0):
		OpenIDs.push_back(1)
		Location.push_back(Vector2i(0,0))
		IDToObj.push_back(1)
		return OpenIDs.size()-1 
	else:
		var working_id = 0
		while OpenIDs[working_id] == 1:
			working_id+=1
		OpenIDs[working_id] = 1
		OpenIDN -= 1
		return working_id
		
func remove_id(ID):
	rt.flop_astar_grid(ID)
	OpenIDs[ID] = 0
	OpenIDN += 1
