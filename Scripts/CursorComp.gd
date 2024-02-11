extends Node2D

var spwn = preload("res://Objects/Player.tscn")
var Bspwn = preload("res://Objects/Enemy.tscn")
@export var Offset = Vector2(8, 8)
@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
@onready var mc = root.get_node("MenuCombat")
@onready var sprt : AnimatedSprite2D = get_node("../AnimatedSprite2D")
var ID = -1
var SID = -1
@export var SpriteID = 0
var inited = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	await root.ready
	ID = parent.ID


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!inited):
		root.astar_manager.flop_astar_grid(ID)
		inited = true

func _input(event):
	if(!(event is InputEventMouseMotion)):
		var input_direction = Input.get_vector("left", "right", "up", "down")
		input_direction = input_direction.ceil()
		if(input_direction != Vector2(0, 0)):
			print(input_direction)
		input_direction = Vector2i(input_direction)
		root.ID_manager.location[ID] += input_direction
		root.ID_manager.location[ID] = root.ID_manager.location[ID].clamp(Vector2i(0,0),root.tile_map.get_used_rect().size)
		parent.position = Vector2(root.ID_manager.location[ID]*16) + Offset
		print("my ID is: ", parent.ID)
	var TSID = root.ID_manager.get_id(root.ID_manager.location[ID], ID)
	print("at ", root.ID_manager.location[ID], " is the ID: ",TSID)
	if(TSID == -1):
		sprt.frame = 0
	else:
		sprt.frame = 1
	
	if(event.is_action_pressed("select")):
		if(root.faction_manager.player_turn and !root.move_manager.moving):
			print("My ID:", ID)
			print("Selected ID:",SID)
			print("Under ID:",TSID)
			if(TSID == -1):
				if(SID != -1):
					if(root.move_manager.actor_move(SID, root.ID_manager.location[ID])):
						SID = -1
						root.combat_display_manager.remove_indicator()
						mc.visible = false
			elif(SID == -1):
				var TSID_object_dynamic = root.ID_manager.id_to_obj[TSID].find_child("C_Dynamic")
				if(root.ID_manager.id_to_obj[TSID].selectable and !TSID_object_dynamic.moved):
					SID = TSID
					root.ID_manager.id_to_obj[SID].clicked()
					mc.visible = true
			elif(SID == TSID):
				SID = -1
				root.combat_display_manager.remove_indicator()
				mc.visible = false
			else:
				print("INTER")
				root.combat_manager.actor_deal_damage(SID, TSID)
				mc.visible = false
		
	if(event.is_action_pressed("db_Spawn")):
		print("Spawning")
		var OBJ = spwn.instantiate()
		OBJ.Init_pos = root.ID_manager.location[ID]
		root.add_child(OBJ)
		root.faction_manager.get_move(root.faction_manager.player_faction)
		
	if(event.is_action_pressed("db_Spawn_bad")):
		print("Spawning baddie")
		var OBJ = Bspwn.instantiate()
		OBJ.Init_pos = root.ID_manager.location[ID]
		root.add_child(OBJ)

