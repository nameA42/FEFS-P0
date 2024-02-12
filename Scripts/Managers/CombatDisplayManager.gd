extends Node2D

var movement_range_tile = preload("res://Objects/MovementRangeTile.tscn")
@onready var root = get_tree().root.get_child(0)
var movement_indicator

# Gets reachable area via a radial search.
func get_reachable_area(ID, speed):
	var reachable_tiles:Array
	var current_speed = speed

	var player_position_index = 1

	while current_speed >= 1:
		var x = current_speed
		var y = 0
		var x_rotation = -1
		var y_rotation = 1
		while(x_rotation == -1 or x != current_speed):
			var loc = root.ID_manager.location[ID] + Vector2i(x, y)
			if(!reachable_tiles.has(loc)):
				loc = loc.clamp(Vector2i(0,0), root.tile_map.get_used_rect().size)
				var id_path = root.astar_manager.astar_grid.get_id_path(
				root.ID_manager.location[ID],
				loc).slice(player_position_index)
				if(id_path.size() <= speed):
					for tloc in id_path:
						if(!reachable_tiles.has(tloc)):
							reachable_tiles.append(tloc)
			x += x_rotation
			y += y_rotation
			if(x == -current_speed):
				x_rotation = 1
			if(y == current_speed):
				y_rotation = -1
			if(y == -current_speed):
				y_rotation = 1
		current_speed -= 1
	reachable_tiles.sort()
	print(reachable_tiles)
	return reachable_tiles

func redisplay_reachable_area():
	if(root.faction_manager.player_turn):
		remove_indicator()
		display_reachable_area(root.move_manager.last_move_id, root.move_manager.last_speed)

func display_reachable_area(ID, speed, dis = true):
	root.move_manager.last_move_id = ID
	root.move_manager.last_speed = speed
	root.move_manager.last_reachable_tiles = get_reachable_area(ID, speed)
	print(root.ID_manager.location[ID])
	if(dis):
		movement_indicator = Node2D.new()
		add_child(movement_indicator)
		for tile in root.move_manager.last_reachable_tiles:
			var tTile : Sprite2D = movement_range_tile.instantiate()
			tTile.position = tile*16 + Vector2i(8,8)
			movement_indicator.add_child(tTile)
		
func remove_indicator():
	if (movement_indicator):
		movement_indicator.queue_free()

func get_in_range_area(ID, speed):
	var reachable_tiles:Array
	var current_speed = speed
	while current_speed >= 1:
		var x = current_speed
		var y = 0
		var x_rotation = -1
		var y_rotation = 1
		
		while(x_rotation == -1 or x != current_speed):
			var loc = root.ID_manager.location[ID] + Vector2i(x, y)
			reachable_tiles.append(loc)
			x += x_rotation
			y += y_rotation
			if(x == -current_speed):
				x_rotation = 1
			if(y == current_speed):
				y_rotation = -1
			if(y == -current_speed):
				y_rotation = 1
		current_speed -= 1
	reachable_tiles.sort()
	print(reachable_tiles)
	return reachable_tiles

func display_in_range_area(ID, speed, distance = true):

	var red = Color(1, 0, 0, .5)

	root.move_manager.last_move_id = ID
	root.move_manager.last_speed = speed
	root.move_manager.last_reachable_tiles = get_in_range_area(ID, speed)
	if(distance):
		movement_indicator = Node2D.new()
		add_child(movement_indicator)
		for tile in root.move_manager.last_reachable_tiles:
			var tTile : Sprite2D = movement_range_tile.instantiate()
			tTile.position = tile*16 + Vector2i(8,8)
			tTile.modulate = red
			movement_indicator.add_child(tTile)
