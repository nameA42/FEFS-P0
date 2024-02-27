extends Node2D

@onready var root = get_tree().root.get_child(0)

@export var location : Array[Vector2i]
var id_to_obj : Array
@export var OpenIDs : Array[bool]
var OpenIDN = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_id(loc, ExcludeID = -1):
	for i in location.size():
		#print("searching: ", loc, " with: ", location[i], " and finding: ", i)
		if(loc == location[i] && i != ExcludeID && OpenIDs[i] == false):
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
	root.astar_manager.reset_astar_point(ID)
	OpenIDs[ID] = true
	OpenIDN += 1
