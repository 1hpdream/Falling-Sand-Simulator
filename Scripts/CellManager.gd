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

# spawn area variables
var spawnArea = 4

# timer variables
var waitTime : float = .2
var waitTimeCur : float = 0

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

func _process(delta):
		SpawnCells()

		UpdateCells(delta)

		SwapArrays()
		

# if input is received, change the selected cells to sand.
func SpawnCells():
	if Input.is_action_pressed("left"):
		var mousePosition = get_local_mouse_position()
		# scales the position to match the scaling of the window.
		var xPos = int(mousePosition.x / 10)
		var yPos = int(mousePosition.y / 10)
		
		var halfSize = spawnArea / 2
		
		for xNew in range(-halfSize, halfSize):
			for yNew in range(-halfSize, halfSize):
				# makes sure the spawn region is within the bounds of the array.
				if (xPos + xNew < sizeX  - 1 and xPos + xNew > 0) and (yPos + yNew < sizeY and yPos + yNew > 0) and cellsBufferArray[xPos + xNew][yPos + yNew].cellType == 0:
					cellsBufferArray[xPos + xNew][yPos + yNew].cellType = 1
					cellsBufferArray[xPos + xNew][yPos + yNew].cellColor = Color.YELLOW

func UpdateCells(delta):

	# Process rows bottom-to-top
	for y in range(sizeY - 1, -1, -1):

			for x in range(sizeX):
				if cells[x][y].cellType == 1:
					UpdateSandCells(x, y)


func UpdateSandCells(x, y):
	# check if the cell isn't at the border.
	if y < sizeY - 1:
		# check the cell below the current, and if it is an air cell change the buffer equivalant to a sand cell.
		if cells[x][y + 1].cellType == 0:
			# reset current cell
			#cells[x][y].cellType = 0
			#cells[x][y].cellColor = Color.LIGHT_BLUE
			
			cellsBufferArray[x][y + 1].cellType = 1
			cellsBufferArray[x][y + 1].cellColor = Color.YELLOW

	

		elif x < sizeX - 1 or x > 0:
			# if both the left and right of a cell below the current cell is open, move to either of those.
			if x < sizeX - 1 and x > 0 and (cells[x - 1][y + 1].cellType == 0 and cells[x + 1][y + 1].cellType == 0):
				var direction = randf_range(0, 1)
				if direction < .51:
					#cells[x][y].cellType = 0
					#cells[x][y].cellColor = Color.LIGHT_BLUE

					cellsBufferArray[x + 1][y + 1].cellType = 1
					cellsBufferArray[x + 1][y + 1].cellColor = Color.YELLOW

				else:
					#cells[x][y].cellType = 0
					#cells[x][y].cellColor = Color.LIGHT_BLUE
					
					cellsBufferArray[x - 1][y + 1].cellType = 1
					cellsBufferArray[x - 1][y + 1].cellColor = Color.YELLOW
					
			# if the cell to the left of the cell below the current cell is open, move there. 
			elif  x > 0 and cells[x - 1][y + 1].cellType == 0:
					#cells[x][y].cellType = 0
					#cells[x][y].cellColor = Color.LIGHT_BLUE
					
					cellsBufferArray[x - 1][y + 1].cellType = 1
					cellsBufferArray[x - 1][y + 1].cellColor = Color.YELLOW
					
			# if the cell to the right of the cell below the current cell is open, move there. 				
			elif x < sizeX - 1 and cells[x + 1][y + 1].cellType == 0:
					#cells[x][y].cellType = 0
					#cells[x][y].cellColor = Color.LIGHT_BLUE
					
					cellsBufferArray[x + 1][y + 1].cellType = 1
					cellsBufferArray[x + 1][y + 1].cellColor = Color.YELLOW
			else:
				cellsBufferArray[x][y].cellType = 1
				cellsBufferArray[x][y].cellColor = Color.YELLOW

	else:
		cellsBufferArray[x][y].cellType = 1
		cellsBufferArray[x][y].cellColor = Color.YELLOW

	

# swaps the cells values with the buffer values and resets the buffer
#TODO: change buffer system from only updating cells that are air to every cell to allow for more cell interactions.
func SwapArrays():
	for x in range(len(cells)):		
		for y in range(len(cells[x])):

			cells[x][y].cellType = cellsBufferArray[x][y].cellType
			cells[x][y].cellColor = cellsBufferArray[x][y].cellColor

			cells[x][y].get_node("Sprite2D").modulate = cells[x][y].cellColor

			cellsBufferArray[x][y].cellType = 0
			cellsBufferArray[x][y].cellColor = Color.LIGHT_BLUE
