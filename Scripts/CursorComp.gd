extends Node2D

var spwn = preload("res://Objects/Player.tscn")
@export var Offset = Vector2(8, 8)
@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
var ID = -1
var SID = -1
var inited = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await par.ready
	ID = par.ID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!inited):
		rt.flopAstargrid(ID)
		inited = true

func _input(event):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction = input_direction.ceil()
	if(input_direction != Vector2(0, 0)):
		print(input_direction)
	input_direction = Vector2i(input_direction)
	rt.Location[ID] += input_direction
	par.position = Vector2(rt.Location[ID]*16) + Offset
	
	if(event.is_action_pressed("select")):
		print("My ID:", ID)
		print("Selected ID:",SID)
		var TSID = rt.get_id(rt.Location[ID], ID)
		print("Under ID:",TSID)
		if(TSID == -1):
			if(SID != -1 and !rt.moving):
				if(rt.move(SID, rt.Location[ID])):
					SID = -1
					rt.rmvInd()
		elif(SID == -1):
			SID = TSID
			rt.IDToObj[SID].clicked()
		else:
			print("INTER")
			rt.inter(SID, TSID)
		
	if(event.is_action_pressed("db_Spawn")):
		print("Spawning")
		var OBJ = spwn.instantiate()
		OBJ.Init_pos = rt.Location[ID]
		rt.add_child(OBJ)

