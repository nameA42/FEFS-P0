extends Node2D

@onready var root = get_tree().root.get_child(0)

var astar_grid: AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_astar_grid():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = root.tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()	

func init_tile_data():
	for x in root.tile_map.get_used_rect().size.x:
		for y in root.tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(x,y)
			
			var tile_data = root.tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or !tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_position)	

func flop_astar_grid(ID):
	print(root.ID_manager.location[ID])
	astar_grid.set_point_solid(root.ID_manager.location[ID], !astar_grid.is_point_solid(root.ID_manager.location[ID]))
