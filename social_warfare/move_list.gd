extends Resource

class_name SocialWarfareMoveList

# this resource just serves to store all of our moves, so that we can
# reference just this list and shuffle them/call their properties.

# see social_warfare.gd for how we implement that

@export var move_list : Array[SocialWarfareMove]
