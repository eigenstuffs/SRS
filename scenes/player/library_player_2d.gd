extends Player2D

class_name LibraryPlayer2D

const STATIC_BOOK = preload("res://tools/minigames/library/items/book/static_book.tscn")

@onready var bookstack_origin = $Catchbox.position

var hurt: bool = false
var failed: bool = false

func _on_hurtbox_body_entered(body):
	if body is Bomb2D:
		body.queue_free()
		hurt = true
		can_move = false
		MinigameEventBus.emit_signal("player_hurt")
		call_deferred("clear_books_and_reset_box")
		
		await get_tree().create_timer(1).timeout
		
		hurt = false
		if !failed: can_move = true

func _on_catchbox_body_entered(body):
	if body is Book2D:
		body.queue_free()
		MinigameEventBus.emit_signal("player_scored")
		call_deferred("add_book_and_shift_box")

func anim_handler():
	if velocity != Vector2.ZERO:
		sprite.play("Walk")
	elif failed:
		sprite.play("Fail")
	elif hurt:
		sprite.play("Hurt")
	else:
		sprite.play("Idle")
		
func add_book_and_shift_box():
	var a = STATIC_BOOK.instantiate()
	$BookStack.add_child(a)
	a.global_position = $Catchbox.global_position
	
	$Catchbox.position -= Vector2(0, 60) #height of the book

func clear_books_and_reset_box():
	for child in $BookStack.get_children():
		$BookStack.remove_child(child)
	$Catchbox.position = bookstack_origin
