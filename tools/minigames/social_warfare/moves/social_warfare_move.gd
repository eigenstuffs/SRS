extends Resource

class_name SocialWarfareMove

# This might be a little weird for new godot ppl so heres a quick rundown
# Resources are great for data storage, you can load them on a scene
# and reference their functions or values

# Here, I think a Resource would be great for storing all the available
# player/enemy moves, because we want to ideally swap out the moves and
# add more without having to touch the actual social warfare scene.

# Also, it'll get really tiring if we just store all the data about each
# move on the social warfare script

# To make a resource, make a script, extend Resource, and create a
# class_name. You can then create a Resource of the class. You can
# load it into a script by writing preload() and then the path.

# Move template: each move has a name, a description, a set power,
# variance in power, and intensity effect. In the future, I'm sure we'll
# add textures and whatnot, so we can come back and add them here.

@export var move_name : String
@export var move_desc : String
@export var move_text_player : Array[String] # Potential dialogue lines that plays when you do the move
@export var move_text_enemy : Array[String] # Potential dialogue lines that plays when you do the move
@export var move_power : int
@export var move_variance : int
@export var move_intensity : int
