extends Node2D

var spwn = preload("res://Objects/Player.tscn")
var Bspwn = preload("res://Objects/Enemy.tscn")
@export var Offset = Vector2(8, 8)
@onready var parent = get_parent()
@onready var root = get_tree().root.get_child(0)
@onready var menu_combat = root.get_node("MenuCombat")
@onready var sprt : AnimatedSprite2D = get_node("../AnimatedSprite2D")
@onready var ID = root.DEFAULT_ID
@onready var selected_id = root.DEFAULT_ID
@export var SpriteID = 0
var inited = false

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
	check_input(event)


func check_input(event):
	var hovered_over_id = root.ID_manager.get_id(root.ID_manager.location[ID], ID)

	if (Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2(0,0)
		and not event is InputEventMouse):
		shift_cursor(hovered_over_id)
	
	if(Input.is_action_just_pressed("ui_select")
		and root.faction_manager.player_turn 
		and !root.move_manager.moving):

		check_cursor_actions(hovered_over_id)	

func check_cursor_actions(hovered_over_id):
	
		# First case: If under the cursor is a blank selection, but the cursor has a unique selection, move the actor if possible
		if(hovered_over_id == root.DEFAULT_ID and selected_id != root.DEFAULT_ID):
			return

		# Second case: If the cursor has no selection, or has the same selection, see if you can select/deselect.
		if (check_can_select_deselect_object(hovered_over_id)):
			return

func check_can_select_deselect_object(hovered_over_id):
	if(selected_id == root.DEFAULT_ID):
		return

	elif(selected_id == hovered_over_id):
		return
	


func shift_cursor(hovered_over_id):

	print("at ", root.ID_manager.location[ID], " is the ID: ",hovered_over_id)

	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


	input_direction = Vector2i(input_direction)
	root.ID_manager.location[ID] += input_direction
	root.ID_manager.location[ID] = root.ID_manager.location[ID].clamp(Vector2i(0,0),root.tile_map.get_used_rect().size)

	parent.position = Vector2(root.ID_manager.location[ID]*16) + Offset
