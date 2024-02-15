class_name C_MapCursor extends Component

@export var Offset = Vector2(8, 8)
@onready var sprt: AnimatedSprite2D = get_node("../AnimatedSprite2D")
@export var SpriteID = 0

var hovered_over_id = -1

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
	if(event != InputEventMouseMotion):
		check_input(event)

func cursor_disable():
	state = CursorState.DISABLED
	sprt.visible = false

func cursor_enable(new_state: CursorState = CursorState.NORMAL):
	state = new_state
	sprt.visible = true

func check_input(event):
	
	if (Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2(0,0)
		and not event is InputEventMouse):
		shift_cursor()
	
	if(Input.is_action_just_pressed("ui_select")
		and faction_manager.player_turn 
		and !move_manager.moving
		and hovered_over_id != -1):

		try_select_player()

func try_select_player():
	var sel = ID_manager.id_to_obj[hovered_over_id]

	var selected_Combat = sel.find_child("C_Combat")
	if (selected_Combat and selected_Combat.faction == 1):
		if (selected_Combat.select()):
			cursor_disable()
		


func shift_cursor():

	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	input_direction = Vector2i(input_direction)
	ID_manager.location[ID] += input_direction
	ID_manager.location[ID] = ID_manager.location[ID].clamp(Vector2i(0,0),tile_map.get_used_rect().size)

	parent.position = Vector2(ID_manager.location[ID]*16) + Offset
	hovered_over_id = root.ID_manager.get_id(root.ID_manager.location[ID], ID)
	
	print("at ", ID_manager.location[ID], " is the ID: ", hovered_over_id)

