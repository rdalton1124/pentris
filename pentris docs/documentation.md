# Game Rules

	- Pentris is a variation of Tetris. 
	
	- Instead of having tetriminoes w/ 4 orthogonal squares, it has pentaminoes comprised of 5 squares
	
	- The game will generate a block and the block will fall. Control the block as it falls and try to make a line by filling every square in a row. If you make a line, the line will disappear, making more room for falling blocks. 
	
# Controls
	- A: move a falling block left
	- D: move a falling block right 
	- S: block will fall faster. Let go and it will go back to normal speed 
	- Q: Rotate block 90 degrees counter-clockwise
	- E: Rotate block 90 degrees clockwise 
	- Space: Quick drop. Block will immediately fall as far as it can and game will generate a new block. 
	- R: restart game. 
# Scenes

## Root Scene
	-  Contains the walls and floor 
	- 
## Pentamino 1-18
	- Each of the 18 pentaminos have their own scene, which I used to set up the collision
	- Most of the pentaminoes use a polygon2D for collision. 

## Wall / Floor
	- It's just a StaticBody2D w/ a color rect and a shape collider
## Block 
	- 
# Media

## Art 

	- I made the block textures myself. It's just 3 squares nested within each other. I then used a blur tool over the blocks. 
	- Background is just a black screen which has had a grid patter superimposed on it by a website that I found online

## Sounds
	
	- Found the sounds from Kenney's. 
