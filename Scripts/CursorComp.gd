extends Node2D

var spwn = preload("res://Objects/Player.tscn")
var Bspwn = preload("res://Objects/Enemy.tscn")
@export var Offset = Vector2(8, 8)
@onready var par = get_parent()
@onready var rt = get_tree().root.get_child(0)
@onready var mc = rt.get_node("MenuCombat")
@onready var sprt : AnimatedSprite2D = get_node("../AnimatedSprite2D")
var ID = -1
var SID = -1
@export var SpriteID = 0
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
	rt.Location[ID] = rt.Location[ID].clamp(Vector2i(0,0),rt.tile_map.get_used_rect().size)
	par.position = Vector2(rt.Location[ID]*16) + Offset
	var TSID = rt.get_id(rt.Location[ID], ID)
	if(TSID == -1):
		sprt.frame = 0
	else:
		sprt.frame = 1
	
	if(event.is_action_pressed("select")):
		if(rt.pt and !rt.moving):
			print("My ID:", ID)
			print("Selected ID:",SID)
			print("Under ID:",TSID)
			if(TSID == -1):
				if(SID != -1):
					if(rt.move(SID, rt.Location[ID])):
						SID = -1
						rt.rmvInd()
						mc.visible = false
			elif(SID == -1):
				if(rt.IDToObj[TSID].selectable and !rt.IDToObj[TSID].moved):
					SID = TSID
					rt.IDToObj[SID].clicked()
					mc.visible = true
			elif(SID == TSID):
				SID = -1
				rt.rmvInd()
				mc.visible = false
			else:
				print("INTER")
				rt.inter(SID, TSID)
				mc.visible = false
		
	if(event.is_action_pressed("db_Spawn")):
		print("Spawning")
		var OBJ = spwn.instantiate()
		OBJ.Init_pos = rt.Location[ID]
		rt.add_child(OBJ)
		rt.getMovable(1)
		
	if(event.is_action_pressed("db_Spawn_bad")):
		print("Spawning baddie")
		var OBJ = Bspwn.instantiate()
		OBJ.Init_pos = rt.Location[ID]
		rt.add_child(OBJ)

