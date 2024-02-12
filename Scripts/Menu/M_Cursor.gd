extends TextureRect

@export var menu_parent_path: NodePath
@export var cursor_offset: Vector2

@onready var menu_parent := get_node(menu_parent_path)

var cursor_index :int = 0

# Called every frame.
func _process(delta):
	process_cursor_inputs()

# Processes inputs on the cursor, including directions based on the grid of the container and 
func process_cursor_inputs():
	var input := Vector2.ZERO
	menu_parent.release_focus()

	if Input.is_action_just_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		input.y += 1
	if Input.is_action_just_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		input.x += 1

	if menu_parent is VBoxContainer:
		set_cursor_from_index(cursor_index + input.y)
	elif menu_parent is HBoxContainer:
		set_cursor_from_index(cursor_index + input.x)
	elif menu_parent is GridContainer:
		set_cursor_from_index(cursor_index + input.x + input.y * menu_parent.columns)
		
	if Input.is_action_just_pressed("ui_select"):
		var current_menu_item := get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_select"):
				current_menu_item.cursor_select()		

# Gets the control node at whatever index the cursor is currently at.
func get_menu_item_at_index(index: int) -> Control:
	if !menu_parent:
		return null
		
	if index >= menu_parent.get_child_count() or index < 0:
		return null
		
	return menu_parent.get_child(index) as Control
	
# Sets the cursor to the index of the menu items.
func set_cursor_from_index(index: int) -> void:
	
	if index < 0:
		index = menu_parent.get_child_count() - 1
	elif index >= menu_parent.get_child_count():
		index = 0
	
	var menu_item := get_menu_item_at_index(index)
	
	if !menu_item:
		return
	
	var position = menu_item.global_position
	var size = menu_item.size
	
	global_position = Vector2(position.x, position.y + (size.y / 2)) - (size / 2) - cursor_offset

	cursor_index = index
