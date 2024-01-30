extends Node2D

@onready var tile_map = $"Map"

@export var Location : Array
var IDToObj : Array
var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
var moving = false
var movingTarget
var Mid = -1


# Called when the node enters the scene tree for the first time.
func _ready(): 
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x,
				y
			)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or !tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_position)
				print(x, y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !current_id_path.is_empty():
		var target_position = tile_map.map_to_local(current_id_path.front())
		
		print(target_position)
		
		IDToObj[Mid].global_position = IDToObj[Mid].global_position.move_toward(target_position, 1)
		
		
		if IDToObj[Mid].global_position == target_position:
			current_id_path.pop_front()
	elif(Mid != -1):
		print(Mid)
		Mid = -1
		moving = false
	

func move(id, loc):
	print(Location[id], loc)
	var id_path = astar_grid.get_id_path(
		Location[id],
		loc
	).slice(1)
	
	print(id_path)
	if id_path.is_empty() == false:
		print("imprinting id")
		current_id_path = id_path
	
	print(loc)
	astar_grid.set_point_solid(Location[id], false)
	astar_grid.set_point_solid(loc, true)
	
	Mid = id
	Location[id] = loc
	
	moving = true
	print("Moving")
	
	
func get_id(loc, EID=-1):
	for i in Location.size():
		if(loc == Location[i] && i != EID):
			return i
	return -1
