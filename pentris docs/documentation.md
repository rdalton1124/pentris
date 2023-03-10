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
	- x, y: Temporary variables representing position of pentamino
	- angle: Current angle. Since Godot keeps angles as radians by default, I think it's beneficial to have a
	separate, integer value which does not get distorted over time by float conversions. 
	- fallSpeed: Current fallSpeed. Set to 60 by default. 
	- fSpd: A temporary variable which is 2 * fallSpeed if S is being held or just fallSpeed otherwise. Ultimately not necessary
	- gravity: The main velocity vector. x is always 0, y is set to the current fall speed. 
	- leftColl, rightColl: booleans which tell whether the pentamino is hitting the right or left wall 
	- qd, wallBump: sounds 
	- playfield: points to the play space node. 
### _ready function
	- Initializes variables. 
	- Sets fallSppeed to variables. 
### processInput function
 	- Reacts to input.
	- Called at the beginning of physics process. 
### _physics_process function
	- Calls process input, checks for collisions with walls, calls move_and_slide, and then check for weird collisions
### printStatus function
	- Used for debugging. 
	- Prints out location, rotation and collisions. 
### snap functions 	
	- The snap functions exist to keep the pieces in line with the grid. 
	- If x and y are not multiples of 32, this will modify them to be one (blocks are 32 x 32).  
	- Usually called right before locking pieces or if the game notices something weird
	- hSnap: horizontal snap. If x is not a multiple of 32, round it to the nearest one 
	- vSnap: vertical snap. If y is not a multiple of 32, round it to the nearest one 
	- snap: calls hSnap and vSnap 
	- downSnap: rounds y to the next higher multiple of 32. 
### lock function 
	- Called after block lands
	- If pentamino has somehow fallen out of the grid, it realigns it. 
	- Removes all children from pentamino. Destroys collision and forfeits blocks to playfield
	- If pentamino is not hitting ceiliing, spawn a new pentamino. If it is, just don't, causing game to end. 
	- Call playfield's check lines function 

## Block 
### Variables 
	- xOffset, yOffset: offset of block from it's parent node
	- vel: a velocity vector that I ended up not needing
	- landed: a boolean telling whether parent pentamino has landed. 
###Functions
	- physics process: Keeps block's offset aligned with parent pentamino. Disabled when block lands
	- move: disables physics process. Called when a pentamino lands. 
	- fall: moves block down 32 pixels. Called when line below it is cleared  
## Spawner 
	- Spawns a new pentamino. 
### Functions
	- _ready: creates and randomizes an RNG. 
	- spawn: chooses a random number between 1 and 18, and instantiates the corresponding pentamino. 

## Playfield 
### variables 
	- array 
	- linesCleared: an integer showing the number of lines which have been cleared 
	- lineComplete: a sound 
### functions 
	- rstarry: reset array. Sets every value in array to 0 
	- h2in and in2h: The index of the array(in) corresponds to a certain y position (h).
	- printStatus: debug function, prints number of children 
### checkLines function 
	- Checks to see if any lines have been made
	- Works by checking every single block and counting how many blocks there are at each height.
	- If there are 13 or more blocks (playfield is 13 blocks wide), that line is marked for deletion

### deleteLines function
	- Deletes lines after they are made
	- Receives an array from the checkLines function 
	- Goes through every single block. If the block is at one of the heights marked for deletion, delete it
	- Goes through every single remaining block. If it higher than the blocks marked for deletion, calls blocks
	fall function
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
	- The first pr

## Problems during creation

### Movement 
	- The first problem I encountered was that Godot (and most game engines) is meant for continous movement, but Pentris specifically requires grid-based movements (ie, moving left or right specifically moves you 32 pixels left or right). I directly set the self.position.x += 32, but this is far from an ideal solution. 
	
### Collision issues
	- At first I tried to use the collision of the block nodes, but couldn't get it working
	- Then I tried to use a collision polygon2d which matched up cleanly with the pentamino. This didn't work because I accidentally set it to segment collision instead of solid collison 
	- After this, I set the collision to be 2-3 collisonShape2D rectangles. This worked okay, except for the fact 
	that the corners of a falling piece would collide with the corners of a landing piece. 
	- I tried a few different solution, such as increasing the fallspeed when colliding w/ a block, et cetera.
	- I eventually ended up setting the collision as collison polygon 2Ds which almost match the blocks, but without the corners. 
	- Had trouble w/ landing 

## Things I would change
### Playfield script
	- Playfield script is a mess. Child blocks are just added as they fall, and there's no easy way to tell whether you've completed a line. Right now, it just goes  through every single child block and checks its Y position. 
	- I think the playfield script would be better off treating child blocks as a 2D array. That way it'd be easier to check for lines. 
	
### Pentamino Script 
	- Pentamino script doesn't actually delete itself in lock().  It just sets physics process to false. It's a single line change, but I've already submitted the assignment. 
	- Quick drop doesn't work quite right. Since it sometimes gets caught in an endless loop, I set the quick drop function to just stop after 500 iterations. It's a collision problem of some kind, because the loop is set to run until you hit the floor. 
	- I wish to fix the movement. I directly modify the position values a lot, which is something I wish to change. 
	- I would change the way that the game detects a loss. It just checks a pentamino's Y position. This is inconsistent
	because the position is based on the "center" of the 5 blocks, which varies based on the specific block + rotation. 
	I would instead change it to detect a collision with an invisible ceiling. 
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
	- My fans wish for there to be T-spin functionality. 
# Thoughts on Godot 
## General thoughts 
	- I choose Godot specifically because I wanted to learn a new technology
	- It was easy enough to learn. It would've been easier for me if I paid more attention to the 
	built-in docs. For example, I accidentally set my collison to be segments instead of solids because 
	I thought that option referred to the shape of the collision rather than the functionality of the collision 
## Advantages 
	- 
## Disadvantages 
	- 
