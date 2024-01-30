extends Node2D

@export var Offset = Vector2(8, 8)
@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID = -1
var SID = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	ID = par.ID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction = input_direction.ceil()
	if(input_direction != Vector2(0, 0)):
		print(input_direction)
	rt.Location[ID] += input_direction
	par.position = Vector2(rt.Location[ID]*16) + Offset
	
	if(event.is_action_pressed("select")):
		print(SID)
		var TSID = rt.get_id(rt.Location[ID], ID)
		print(TSID)
		if(TSID == -1):
			if(SID != -1 and !rt.moving):
				rt.move(SID, rt.Location[ID])
				SID = -1
		elif(SID == -1):
			SID = TSID
		
