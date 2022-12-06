# Game Rules

	- Pentris is a variation of Tetris. 
	
	- Instead of having tetriminoes w/ 4 orthogonal squares, it has pentaminoes comprised of 5 squares
	
	- The game will generate a block and the block will fall. 
	- Control the block as it falls and try to make a line by filling every square in a row. 
	- If you make a line, the line will disappear, making more room for falling blocks. 
	
# Controls
	- A: move a falling block left
	- D: move a falling block right 
	- S: block will fall faster. Let go and it will go back to normal speed 
	- Q: Rotate block 90 degrees counter-clockwise
	- E: Rotate block 90 degrees clockwise 
	- Space: Quick drop. Block will immediately fall as far as it can and game will generate a new block. 
	- R: restart game. 
	
# Installation Instructions
	- An .exe and a .app are in the builds folder. 
# Scenes

## Root Scene
	-  Contains the walls and floor 
	- 
## Pentamino 1-18
	- Each of the 18 pentaminos have their own scene, which I used to set up the collision
	- Most of the pentaminoes use a polygon2D for collision. 
	- Made up of 5 blocks 

## Wall / Floor
	- It's just a StaticBody2D w/ a color rect and a shape collider.

## Block 
	- The blocks that make up pentaminoes 
	- Just a square with a rectangle collision 

# Scripts 

## Pentamino 
	- Controls the pentaminos.	
	- Used by all types of pentaminoes. 
### variables	

### _ready function
	- Initializes variables. 
	- Sets fallSppeed to variables. 
### processInput function
 	-	
### _physics_process function

### printStatus function
	- Used for debugging. 
	- Prints out location, rotation and collisions. 
### lock function 
	- Called after block lands
	- If pentamino has somehow fallen out of the grid, it realigns it. 
	- Removes all children from pentamino. Destroys collision and forfeits blocks to playfield
	- If pentamino is not hitting ceiliing, spawn a new pentamino. If it is, just don't, causing game to end. 
	- 

## Block 

## Spawner 
	- Spawns a new pentamino. 
### Functions
	- _ready: creates and randomizes an RNG. 
	- spawn: chooses a random number between 1 and 18, and instantiates the corresponding pentamino. 

## Playfield 

## game_script

	- Spawns a pentamino at the beginning of the game 
	- Is in charge of restarting the game when player presses R. 


# Media

## Art 

	- I made the block textures myself. It's just 3 squares nested within each other. I then used a blur tool over the blocks. 
	- Background is just a black screen which has had a grid patter superimposed on it by a website that I found online

## Sounds
	
	- Found the sounds from Kenney's. 
	
# Creation Process
## Steps 
	- The first thing I did was create the block sprites. 
	- After creating the images, I then created the individual pentamino scenes. I initially used a polygon2D which directly aligned w/ the way the sprites looked. 
	-

## Problems during creation

### Movement 
	- The first problem I encountered was that Godot (and most game engines) is meant for continous movement, but Pentris specifically requires grid-based movements (ie, moving left or right specifically moves you 32 pixels left or right). I directly set the self.position.x += 32, but this is far from an ideal solution. 
	
### Collision issues
	- 

## Things I would change
### Playfield script
	- Playfield script is a mess. Child blocks are just added as they fall, and there's no easy way to tell whether you've completed a line. Right now, it just goes  through every single child block and checks its Y position. 
	- I think the playfield script would be better off treating child blocks as a 2D array. That way it'd be easier to check for lines. 
	
### Pentamino Script 
	- Pentamino script doesn't actually delete itself in lock().  It just sets physics process to false. It's a single line change, but I've already submitted the assignment. 
	- Quick drop doesn't work quite right. Since it sometimes gets caught in an endless loop, I set the quick drop function to just stop after 500 iterations. It's a collision problem of some kind, because the loop is set to run until you hit the floor. 
	- I wish to fix the movement. I directly modify the position values a lot, which is something I wish to change. 
### Spawning
	- I wanted to try to do some sort of object pooling, but I didn't get to that point.
	- The spawner seems to behave strangely at times (spawning the same piece 3 times in a row, spawning a bunch of the same piece, et cetera). I'm not sure why. randi seems to have uniform distribution. I want to make it less wonky. 
### other
	- I would change the background image 

## Things I would add
	- Hold function. Most tetris games have a holding cell where you can hold a piece for later. This was part of my inital plan (it's seen on the pentamino state diagram)
	- Pause. Pausing would be nice 
	- Ghost piece. Most tetris games have a "ghost piece" which will help you visualize where your piece will fall. 
	- Scoring/high scores. 
	- Speeding up after 5 pieces
	- Special sound for a pentris (clearing 5 lines at once). 
# Thoughts on Godot 
