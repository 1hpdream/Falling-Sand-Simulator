extends Node2D

# cell instance variables
var cell = preload("res://Scenes/cell.tscn")

var cellInstance
var cellBufferInstance

# cell array variables
var cells : Array = []
var sizeX : int = 121 # screen width / 10
var sizeY : int = 61 # screen height / 10

# cell buffer array variables
var cellsBufferArray : Array = []

func _init():
	# creates the 2d arrays.
	for x in range(sizeX):
		cells.append([])
		cellsBufferArray.append([])

		for y in range(sizeY):
			cellInstance = cell.instantiate()
			cellBufferInstance = cell.instantiate()

			# adds the cell instance to the array and sets its position and color.
			cells[x].append(cellInstance)
			cellInstance.position = Vector2(x * 10, y * 10)
			cellInstance.get_node("Sprite2D").modulate = Color.LIGHT_BLUE
			add_child(cellInstance)
			# adds the buffer cell to the buffer array.
			cellsBufferArray[x].append(cellBufferInstance)
			
	print(cells.size())
