class_name CanvasItemEffect extends Effect
	
var parent : Control
var render_passes : Array[CanvasItemRenderPass]

func start(args := []) -> void:
	assert(len(args) > 0 and args[0] is Control, 'First argument must be a parent Control node!')
	parent = args[0]
	
	super.start(args.slice(1)) # We dont include the required parent argument when calling `on_start`
	
	# FIXME: Potentially super slow
	for render_pass in render_passes:
		CanvasItemEffect.insert_render_pass(parent, render_pass)

func queue_free() -> void:
	super.queue_free()
	for render_pass in render_passes:
		if render_pass: parent.remove_child(render_pass)

static func insert_render_pass(parent_ : Control, render_pass : CanvasItemRenderPass) -> void:
	if render_pass.get_parent(): return
	
	var children := parent_.get_children()
	if len(children) == 0:
		parent_.add_child(render_pass)
		return
		
	# Find child with priority greater than own, then insert right before
	for i in range(len(children)):
		if not (children[i] is CanvasItemRenderPass) or children[i].priority <= render_pass.priority: 
			continue
		if i - 1 < 0: # Add node as first child
			parent_.add_child(render_pass)
			parent_.move_child(render_pass, 0)
		else: # Add node previous sibling of current child
			children[i - 1].add_sibling(render_pass)
		return
	parent_.add_child(render_pass)
	
