extends Node2D

@onready var root = get_tree().root.get_child(0)

var current_id_path: Array[Vector2i]
var moving = false
var moving_id = -1
var last_reachable_tiles:Array
var last_move_id = 0
var last_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_buffered_movement():
	if !current_id_path.is_empty():
		var target_position = root.tile_map.map_to_local(current_id_path.front())
		
		
		root.ID_manager.id_to_obj[moving_id].global_position = root.ID_manager.id_to_obj[moving_id].global_position.move_toward(target_position, 1)
		
		
		if root.ID_manager.id_to_obj[moving_id].global_position == target_position:
			current_id_path.pop_front()
	elif(moving_id != -1):

		moving_id = -1
		moving = false

func actor_move(id, loc, speed = -1):
	var end_point = -1

	if (last_reachable_tiles.has(loc) or speed != -1):

		print(root.ID_manager.location[id], loc)
		root.astar_manager.astar_grid.set_point_solid(loc, false)
		print(root.astar_manager.astar_grid.get_id_path(
			root.ID_manager.location[id],
			loc
		))
		
		var id_path = root.astar_manager.astar_grid.get_id_path(
			root.ID_manager.location[id],
			loc
		).slice(1)
		
		root.astar_manager.astar_grid.set_point_solid(loc, true)
		print(id_path)
		if(speed != -1):
			print("speedOps")
			id_path = id_path.slice(0, speed)
			print(id_path)
			if(id_path.has(loc)):
				print("speedOps in bounds")
				id_path = id_path.slice(0, -1)
		print(id_path)
		if !id_path.is_empty():
			print("imprinting id")
			current_id_path = id_path
		
			print(id_path[end_point])
			root.astar_manager.astar_grid.set_point_solid(root.ID_manager.location[id], false)
			root.astar_manager.astar_grid.set_point_solid(id_path[end_point], true)
			
			moving_id = id
			root.ID_manager.location[id] = id_path[end_point]
			
			moving = true
			root.ID_manager.id_to_obj[id].find_child("C_Dynamic").moved = true
			print("removing from can_move: ", id)
			root.faction_manager.can_move_array.erase(id)
			print("Actually Moving: ", id)
			print(root.faction_manager.can_move_array)
			return true
		else:
			return false
	else:
		return false
