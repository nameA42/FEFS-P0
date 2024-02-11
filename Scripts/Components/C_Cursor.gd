extends Node2D

var spwn = preload("res://Objects/Player.tscn")
var Bspwn = preload("res://Objects/Enemy.tscn")
@export var Offset = Vector2(8, 8)
@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
@onready var sprt : AnimatedSprite2D = get_node("../AnimatedSprite2D")
@onready var ID = root.DEFAULT_ID
@onready var selected_id = root.DEFAULT_ID
@export var SpriteID = 0
var inited = false

var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await parent.ready
	await root.ready
	ID = parent.ID
	sprt.frame = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(!inited):
		root.astar_manager.flop_astar_grid(ID)
		inited = true

func _input(event):
	if (disabled): return

	var hovered_over_id = root.ID_manager.get_id(root.ID_manager.location[ID], ID)

	if((event is InputEventKey)):
		shift_cursor(hovered_over_id)
	
	if(event.is_action_pressed("select")
		and root.faction_manager.player_turn 
		and !root.move_manager.moving):

		check_cursor_actions(hovered_over_id)

	#check_spawn_player(event)
	#check_spawn_enemy(event)


func check_cursor_actions(hovered_over_id):
	
		# First case: If under the cursor is a blank selection, but the cursor has a unique selection, move the actor if possible
		if(hovered_over_id == root.DEFAULT_ID and selected_id != root.DEFAULT_ID):
			return

		# Second case: If the cursor has no selection, or has the same selection, see if you can select/deselect.
		if (check_can_select_deselect_object(hovered_over_id)):
			return

func check_can_select_deselect_object(hovered_over_id):
	if(selected_id == root.DEFAULT_ID):
		var hovered_over_object_dynamic = root.ID_manager.id_to_obj[hovered_over_id].find_child("C_Dynamic")
		if(hovered_over_object_dynamic):
			selected_id = hovered_over_id
			root.ID_manager.id_to_obj[selected_id].selected.emit()
			return true

	# If the cursor is hovering over the selected object, deselect it.
	elif(selected_id == hovered_over_id):
		selected_id = root.DEFAULT_ID
		root.ID_manager.id_to_obj[selected_id].deselected.emit()
		return true

	return false


func shift_cursor(hovered_over_id):

	print("at ", root.ID_manager.location[ID], " is the ID: ",hovered_over_id)

	var input_direction = Input.get_vector("left", "right", "up", "down")
	input_direction = input_direction.ceil()

	input_direction = Vector2i(input_direction)
	root.ID_manager.location[ID] += input_direction
	root.ID_manager.location[ID] = root.ID_manager.location[ID].clamp(Vector2i(0,0),root.tile_map.get_used_rect().size)

	parent.position = Vector2(root.ID_manager.location[ID]*16) + Offset

#func check_spawn_enemy(event):
	#if(event.is_action_pressed("db_Spawn_bad")):
		#print("Spawning baddie")
		#var OBJ = Bspwn.instantiate()
		#OBJ.init_pos = root.ID_manager.location[ID]
		#root.add_child(OBJ)
#
#func check_spawn_player(event):
	#if(event.is_action_pressed("db_Spawn")):
		#print("Spawning")
		#var OBJ = spwn.instantiate()
		#OBJ.init_pos = root.ID_manager.location[ID]
		#root.add_child(OBJ)
		#root.faction_manager.get_move(root.faction_manager.player_faction)
