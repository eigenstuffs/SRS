extends BaseGameManager

class_name LibraryGameManager

const BACKGROUND_BOOK = preload("res://tools/minigames/library/items/background_book.tscn")
var score := 0

@export var ui_manager: CanvasLayer
@onready var library_player: LibraryPlayer = $LibraryPlayer
@onready var book_pile: Node2D = $BookPile
@onready var item_folder: Node2D = $Spawner/ItemFolder

func get_score() -> int:
	return score
	
func _on_library_player_book_caught(amount: int) -> void:
	score += amount
	ui_manager.update_points(score)

func _on_library_player_bomb_caught() -> void:
	score -= 1
	ui_manager.update_points(score)
	blow_away_items(library_player.global_position)
	
func start_game():
	$Spawner.active = true
	$LibraryPlayer.can_move = true

func end_game():
	$Spawner.active = false
	$LibraryPlayer.can_move = false

func _ready():
	$Spawner.active = false
	$LibraryPlayer.can_move = false

func spawn_background_book(pos: Vector2):
	var a = BACKGROUND_BOOK.instantiate()
	book_pile.add_child.call_deferred(a)
	a.global_position = pos + Vector2(0, -300)

func blow_away_items(origin: Vector2):
	for item in item_folder.get_children():
		if item is RigidBody2D:
			var direction = (item.global_position - origin).normalized()
			item.apply_impulse(direction * 500, Vector2.ZERO) # tweak force
