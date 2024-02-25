class_name BeatmapLoader

class ObjectInfo extends Resource:
	var time : float
	var key_index : float
	var is_slider : bool
	var duration : float
	
	func _init(time_, key_index_, is_slider_, duration_):
		self.time = time_; self.key_index = key_index_; self.is_slider = is_slider_; self.duration = duration_
	
class Beatmap extends Resource:
	var title : StringName
	var start_offset : float
	var bpm : float
	var bps : float
	var num_keys : int
	var objects : Array[ObjectInfo]
	
const POSITION_MAP : Dictionary = { # (Yuck!)
	64 : 0, 192 : 1, 320 : 2, 448 : 3,                            ### 4K ###
	36 : 0, 109 : 1, 182 : 2, 256 : 3, 329 : 4, 402 : 5, 475 : 6, ### 7K ###
	# TODO: Add more position->key_index mappings as needed
}

## Parses an osu! mania beatmap ([code].osu[/code]) file returning its contents
## in the form of a [Beatmap].
##
## [i]Note: At the moment, variable BPMs are not supported![/i/
static func load(path : String) -> Beatmap:
	assert(path.ends_with('.osu'))
	var file = FileAccess.open(path, FileAccess.READ)
	var beatmap = Beatmap.new()
	var beatmap_objects : Array[ObjectInfo] = []
	var key_set = {} # (why does gdscript have little data structures??)

	# Read the file line by line
	while !file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == '[Metadata]':
			beatmap.title = file.get_line().trim_prefix('Title:')
		elif line == '[TimingPoints]':
			line = file.get_line().split(',')
			beatmap.start_offset = (line[0] as float)*1e-3
			beatmap.bpm = 1 / (line[1] as float) * 60e3
			beatmap.bps = 60.0 / beatmap.bpm as float
		elif line == '[HitObjects]':
			break
			
	# Read hit objects
	while !file.eof_reached():
		var line = file.get_line().split(',')
		var x = line[0] as int
		if not x or x == 0: continue
		
		var time = (line[2] as int)*1e-3
		var duration = (line[5].split(':')[0] as int)*1e-3
		var info = ObjectInfo.new(time, POSITION_MAP[x], (line[3] as int) != 1, 0.0 if duration == 0 else duration - time)

		key_set[POSITION_MAP[x]] = null # Dict acts like a set
		beatmap_objects.push_back(info)
	file.close()

	beatmap.num_keys = len(key_set)
	beatmap.objects = beatmap_objects
	print('(beatmap_loader) loaded: ' + path)
	print('   --- track title:  %s' % beatmap.title) 
	print('   --- bpm:          %f' % beatmap.bpm) 
	print('   --- num objects:  %d' % len(beatmap.objects))
	print('   --- num keys:     %d' % beatmap.num_keys)
	print('   --- start offset: %fs' % beatmap.start_offset)
	return beatmap
