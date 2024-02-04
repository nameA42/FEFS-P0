extends Node2D

var mvmnt_ind_piece = preload("res://Objects/movement_ind_piece.tscn")
@onready var tile_map = $"Map"

@export var Location : Array
@export var OpenIDs : Array
var OpenIDN = 0
var IDToObj : Array
var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
var moving = false
var movingTarget
var Mid = -1
var inited = false
var movement_ind
var last_reachable_tiles:Array

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
				#print(x, ",", y)

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
	if last_reachable_tiles.has(loc):
		print("Moving")
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
		return true
	else:
		return false
	
func get_id(loc, EID=-1):
	for i in Location.size():
		if(loc == Location[i] && i != EID):
			return i
	return -1

func give_id():
	print("giving id")
	if(OpenIDN == 0):
		OpenIDs.push_back(1)
		Location.push_back(Vector2i(0,0))
		IDToObj.push_back(1)
		return OpenIDs.size()-1
	else:
		var wid = 0
		while OpenIDs[wid] == 1:
			wid+=1
		OpenIDs[wid] = 1
		OpenIDN -= 1
		return wid
		
func remove_id(ID):
	OpenIDs[ID] = 0
	OpenIDN += 1

func flopAstargrid(ID):
	print(Location[ID])
	astar_grid.set_point_solid(Location[ID], !astar_grid.is_point_solid(Location[ID]))
	
func display_reachable_area(ID, speed):
	var reachable_tiles:Array
	var current_speed = speed
	while current_speed > 1:
		var x = current_speed
		var y = 0
		var xrot = -1
		var yrot = 1
		while(xrot == -1 or x != current_speed):
			var loc = Location[ID] + Vector2i(x, y)
			if(!reachable_tiles.has(loc)):
				loc.clamp(Vector2i(0,0), tile_map.get_used_rect().size)
				var id_path = astar_grid.get_id_path(
				Location[ID],
				loc).slice(1)
				if(id_path.size() <= speed):
					for tloc in id_path:
						if(!reachable_tiles.has(tloc)):
							reachable_tiles.append(tloc)
			x += xrot
			y += yrot
			if(x == -current_speed):
				xrot = 1
			if(y == current_speed):
				yrot = -1
			if(y == -current_speed):
				yrot = 1
		current_speed -= 1
	
	movement_ind = Node2D.new()
	add_child(movement_ind)
	reachable_tiles.sort()
	print(Location[ID])
	print(reachable_tiles)
	for tile in reachable_tiles:
		var tTile = mvmnt_ind_piece.instantiate()
		tTile.position = tile*16 + Vector2i(8,8)
		movement_ind.add_child(tTile)
	last_reachable_tiles = reachable_tiles
		
func rmvInd():
	movement_ind.queue_free()
