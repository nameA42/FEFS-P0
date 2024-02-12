class_name C_MapCursor extends Component

@export var Offset = Vector2(8, 8)
@onready var sprt: AnimatedSprite2D = get_node("../AnimatedSprite2D")
@onready var selected_id = -1
@export var SpriteID = 0

var disabled = false

func _input(event):
	if disabled: return
	check_input(event)


func disable():
	disabled = true
	sprt.visible = false

func enable():
	disabled = false
	sprt.visible = true

func check_input(event):
	var hovered_over_id = root.ID_manager.get_id(root.ID_manager.location[ID], ID)

	if (Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2(0,0)
		and not event is InputEventMouse):
		shift_cursor(hovered_over_id)
	
	if(Input.is_action_just_pressed("ui_select")
		and faction_manager.player_turn 
		and !move_manager.moving):

		try_select_player(hovered_over_id)

func try_select_player(hovered_over_id):
	var selected = ID_manager.id_to_obj[hovered_over_id]
	var selected_dynamic = selected.find_child("C_Combat")
	if (selected_dynamic and selected_dynamic.faction == 1):
		print("Success!")
		selected_dynamic.select()
		


func shift_cursor(hovered_over_id):

	print("at ", ID_manager.location[ID], " is the ID: ", hovered_over_id)

	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	input_direction = Vector2i(input_direction)
	ID_manager.location[ID] += input_direction
	ID_manager.location[ID] = ID_manager.location[ID].clamp(Vector2i(0,0),tile_map.get_used_rect().size)

	parent.position = Vector2(ID_manager.location[ID]*16) + Offset
