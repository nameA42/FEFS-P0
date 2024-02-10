extends Node2D

@onready var rt = get_tree().root.get_child(0)

var current_id_path: Array[Vector2i]
var moving = false
var moving_id = -1
var movement_indicator

var last_reachable_tiles:Array
var last_id = 0
var last_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_buffered_movement():
	if !current_id_path.is_empty():
		var target_position = rt.astar_manager.tile_map.map_to_local(current_id_path.front())
		
		#print(target_position)
		
		rt.ID_manager.id_to_obj[moving_id].global_position = rt.ID_manager.id_to_obj[moving_id].global_position.move_toward(target_position, 1)
		
		
		if rt.ID_manager.id_to_obj[moving_id].global_position == target_position:
			current_id_path.pop_front()
	elif(moving_id != -1):
		print(moving_id)
		moving_id = -1
		moving = false

func actor_move(id, loc, speed = -1):
	var end_point = -1

	if (last_reachable_tiles.has(loc) or speed != -1):
		print("Moving")
		print(rt.ID_manager.location[id], loc)
		rt.astar_manager.astar_grid.set_point_solid(loc, false)
		print(rt.astar_manager.astar_grid.get_id_path(
			rt.ID_manager.location[id],
			loc
		))
		
		var id_path = rt.astar_manager.astar_grid.get_id_path(
			rt.ID_manager.location[id],
			loc
		).slice(1)
		
		rt.astar_manager.astar_grid.set_point_solid(loc, true)
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
			rt.astar_manager.astar_grid.set_point_solid(rt.ID_manager.location[id], false)
			rt.astar_manager.astar_grid.set_point_solid(id_path[end_point], true)
			
			moving_id = id
			rt.ID_manager.location[id] = id_path[end_point]
			
			moving = true
			rt.ID_manager.id_to_obj[id].moved = true
			can_move_array.erase(id)
			print("Actually Moving: ", id)
			return true
		else:
			return false
	else:
		return false
