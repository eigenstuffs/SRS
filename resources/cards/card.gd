extends Resource

class_name Card

@export var image : Texture
@export var points_req : int
@export var title : String
@export_enum("Attack", "Restore", "Buff", "Debuff") var effect
@export_enum("Attack", "Defense", "Poise") var target_stat
@export_enum("Neutral", "Backhanded", "Blunt", "Emotional") var type
@export var effect_num : float
@export var desc : String
@export var intensity_mod : int
@export var move_dialogue : Array[String]
