class_name C_MapCursor extends Component

@export var Offset = Vector2(8, 8)
@onready var sprt: AnimatedSprite2D = get_node("../AnimatedSprite2D")
@export var SpriteID = 0

var state = CursorState.NORMAL

enum CursorState
{
	NORMAL,
	DISABLED,
	SELECT_MOVE,
	SELECT_ATTACK
}

func _input(event):
	if state == CursorState.DISABLED: return
	check_input(event)

func cursor_disable():
	state = CursorState.DISABLED
	sprt.visible = false

func cursor_enable(new_state: CursorState = CursorState.NORMAL):
	state = new_state
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
	var sel = ID_manager.id_to_obj[hovered_over_id]

	var selected_dynamic = sel.find_child("C_Combat")
	if (selected_dynamic and selected_dynamic.faction == 1):
		if (selected_dynamic.select()):
			cursor_disable()
		


func shift_cursor(hovered_over_id):

	print("at ", ID_manager.location[ID], " is the ID: ", hovered_over_id)

	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	input_direction = Vector2i(input_direction)
	ID_manager.location[ID] += input_direction
	ID_manager.location[ID] = ID_manager.location[ID].clamp(Vector2i(0,0),tile_map.get_used_rect().size)

	parent.position = Vector2(ID_manager.location[ID]*16) + Offset
