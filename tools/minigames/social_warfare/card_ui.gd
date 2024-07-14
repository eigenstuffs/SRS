class_name CardButton extends TextureButton

@onready var original_pos = null
@onready var base_scale := scale
@onready var base_rotation := rotation
@onready var card_viewport := $SubViewportContainer/SubViewport

signal chosen(data)

const SFX_ERROR = preload("res://assets/sfx/switch_1.ogg")
const DISPLACEMENT_FACTOR := 0.3 ## How much the card should rotation in 3D

var card_data : Card
var origin_viewport_space : Vector2
var origin_world_space : Vector3
var base_position : Vector2
var has_mouse_entered := false
var is_selected := false

func _ready():
	await get_tree().create_timer(0.02).timeout # <- it be like that :(
	if get_parent() and get_parent().get_parent() and get_parent().get_parent().get_node("CardDeck"):
		reparent(get_parent().get_parent().get_node("CardDeck"))
	
	self.origin_world_space = $SubViewportContainer/SubViewport/Camera3D.global_position*Vector3(1,1,-1)
	card_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	rotation = base_rotation # FIXME: why is this needed?!?!
	base_position = position

func _process(delta: float) -> void:
	run_3d_displacement(delta)

func _on_pressed():
	if is_selected: return
	is_selected = true
	
	if not card_data: return # For running the scene independently
	if Global.data_dict["player_mp"] >= card_data.points_req:
		await run_fancy_animation() # FIXME: Prevents asynchronous game logic!?!!
		emit_signal("chosen", card_data)
	else:
		EffectAnim.SfxPlayer.stream = SFX_ERROR
		EffectAnim.SfxPlayer.play()
		is_selected = false

func run_3d_displacement(delta : float) -> void:
	if is_selected: return
	
	# Below logic handles the 3D displacement of the card
	var card : Node3D = $SubViewportContainer/SubViewport/Elements
	if has_mouse_entered: # If mouse is in the bounding box
		self.origin_viewport_space = get_global_transform_with_canvas().origin + size*0.5
		var uv := (get_global_mouse_position() - origin_viewport_space) / (size*0.5) # Position on card in [-1,1]
		_rotate_towards_point(origin_world_space - Vector3(uv.x, -uv.y, 0)*DISPLACEMENT_FACTOR, delta*10.0)
		# FIXME: i wrote this before i remembered godot tween existed, so using that might make
		#        this code more readable! sorry!
		rotation = move_toward(rotation, 0.0, delta*1.4)
		scale = scale.move_toward(base_scale*1.2, delta*1.4)
		position = position.move_toward(base_position - Vector2(0, 200), delta*2e3)
		
		card_viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_PARENT_VISIBLE
	elif Vector3.FORWARD.dot(-card.global_basis.z) != 1.0: # If card is not yet back in rest position
		_rotate_towards_point(Vector3.FORWARD, delta*10.0)
		rotation = move_toward(rotation, base_rotation, delta*1.4)
		scale = scale.move_toward(base_scale, delta*1.4)
		position = position.move_toward(base_position, delta*2e3)
	else:
		# For performance reasons, we stop further rendering when the card is not moving.
		card_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED

## Handles 3D rotation of card towards a 3D point. This is different from control rotation!
func _rotate_towards_point(target : Vector3, delta : float) -> void:
	var card : Node3D = $SubViewportContainer/SubViewport/Elements
	var current_rotation = card.quaternion
	card.look_at(target)
	var target_rotation = card.quaternion
	card.quaternion = current_rotation.slerp(target_rotation, delta)

func run_fancy_animation() -> void:
	# We keep this separate from position tween because this takes longer to finish
	# (that is, the card will begin dropping before it finishes rotating)
	var tween_rot = create_tween().set_parallel(true)
	var base_card_rotation : Vector3 = $SubViewportContainer/SubViewport/Elements.rotation
	tween_rot.tween_property($SubViewportContainer/SubViewport/Elements, 'rotation:y', PI, 2.2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	# We also rotate the text so that its readable from the other side (LMAO THIS SUCKS ASS)
	tween_rot.tween_property($SubViewportContainer/SubViewport/Elements/Text, 'scale:x', -$SubViewportContainer/SubViewport/Elements/Text.scale.x, 0.25)
	# This tween moves the the card to the center of the screen
	var tween_pos = create_tween().set_parallel(true)
	tween_pos.tween_property(self, 'global_position', get_viewport_rect().size*0.5 - size*0.5, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween_pos.tween_property(self, 'scale', base_scale*1.5, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# After moving to center, we 'drop' the card before exploding (from callback)
	tween_pos.chain().tween_property(self, 'scale', base_scale*0.4, 0.27).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween_pos.chain().tween_callback(func(): 
		# Screen space effects
		EffectReg.start_effect(EffectReg, 'RadialShockwave', [EffectReg])
		EffectReg.start_effect(EffectReg, 'Flash', [EffectReg, Color(0.8, 0.8, 0.95, 0.8), 1.0])
		EffectReg.start_effect(EffectReg, 'Bloom', [EffectReg,  1.0, 0.0, 0.4, 0.6])
		# Reset card transform (both 2D and 3D)
		position = base_position
		scale = base_scale
		rotation = base_rotation
		$SubViewportContainer/SubViewport/Elements/Text.scale.x *= -1
		$SubViewportContainer/SubViewport/Elements.rotation = base_card_rotation
		is_selected = false
		# Cleanup logic
		tween_rot.kill())
	await tween_pos.finished

func apply_assets():
	var card := $SubViewportContainer/SubViewport/Elements/Card
	var title := $SubViewportContainer/SubViewport/Elements/Text/Title
	var description := $SubViewportContainer/SubViewport/Elements/Text/Description
	var type := $SubViewportContainer/SubViewport/Elements/Text/Type
	
	card.set_surface_override_material(0, card.get_surface_override_material(0).duplicate(true))
	card.get_surface_override_material(0).set_shader_parameter('face_texture', card_data.image)
	description.text = card_data.desc
	if card_data.effect:
		match card_data.effect:
			0: type.text = str("Attack, Cost: ", card_data.points_req)
			1: type.text = str("Restore, Cost: ", card_data.points_req)
			2: type.text = str("Buff, Cost: ", card_data.points_req)
			3: type.text = str("Debuff, Cost: ", card_data.points_req)
	else:
		type.text = str("Cost: ", card_data.points_req)
	title.text = card_data.title

func _on_mouse_entered() -> void:
	z_index += 1.0
	has_mouse_entered = true

func _on_mouse_exited() -> void:
	z_index -= 1.0
	has_mouse_entered = false
