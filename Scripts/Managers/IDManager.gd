extends Node2D

@onready var root = get_tree().root.get_child(0)

@export var location : Array
var id_to_obj : Array
@export var OpenIDs : Array[bool]
var OpenIDN = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_id(loc):
	for i in location.size():
		if(loc == location[i] && i != root.DEFAULT_ID && OpenIDs[i] == false):
			return i
	return -1

func give_id():
	print("giving id")
	if(OpenIDN == 0):
		OpenIDs.push_back(false)
		location.push_back(Vector2i(0,0))
		id_to_obj.push_back(1)
		return OpenIDs.size()-1 
	else:
		var working_id = 0
		while OpenIDs[working_id]:
			working_id+=1
		OpenIDs[working_id] = false
		OpenIDN -= 1
		return working_id
		
func remove_id(ID):
	root.astar_manager.flop_astar_grid(ID)
	OpenIDs[ID] = true
	OpenIDN += 1
