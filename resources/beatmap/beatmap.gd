@tool
class_name Beatmap extends Resource

static var _POSITION_MAP : Dictionary = { # (Yuck!)
	64 : 0, 192 : 1, 320 : 2, 448 : 3,                            ### 4K ###
	36 : 0, 109 : 1, 182 : 2, 256 : 3, 329 : 4, 402 : 5, 475 : 6, ### 7K ###
	# TODO: Add more position->key_index mappings as needed
}

## The title of the track used in the beatmap. Automatically set if [member path]
## has been specified
@export var title : StringName

@export var preview : CompressedTexture2D
@export var mod_file : BeatmapMod
@export var preview_start := 0.0
@export var volume_db_offset := 0.0

## The track associated with the beatmap. Any metadata of the track is ignored
## as beatmap will be used to extract metadata instead.
@export var track : AudioStream :
	set(value):
		track = value
		if not value: 
			self.is_initialized = false
			return
		
		self.path = '%s.osu' % value.resource_path \
			.trim_suffix('.%s' % value.resource_path.get_file().get_extension())
		
## The path of the beatmap (.osu) file. Automatically set if [member track] has
## been specified and a beatmap file exists in the same directory as the track's
## resource with the same name.
@export_file('*.osu') var path : String : 
	set(value):
		if not value: 
			self.is_initialized = false
			path = value
			return
		if not FileAccess.file_exists(value): return
		
		Beatmap.load(value, self)
		path = value

## The starting offset time (in seconds) of the specified track. Automatically 
## set if [member path] has been specified.
@export var start_offset : float
		
## The number of keys used for the beatmap. Automatically set if [member path] 
## has been specified.
@export var num_keys : int

## Automatically set if [member path] has been specified.
var objects : Array[HitObjectInfo] : 
	get:
		if is_initialized:
			assert(not objects.is_empty(), 'Beatmap object count is empty!')
		return objects
var timings : Array[TimingPoint]
var is_initialized : bool

## Parses an osu! mania beatmap ([code].osu[/code]) and sets the [Beatmap]'s
## respective fields.
##
## [i]Note: At the moment, variable BPMs are not supported![/i]
static func load(beatmap_file_path : String, beatmap : Beatmap) -> void:
	if beatmap.is_initialized:
		return
	
	assert(beatmap_file_path.ends_with('.osu'), 'Beatmap pat must be a .osu file!')
	var file := FileAccess.open(beatmap_file_path, FileAccess.READ)
	var key_set := {} # (why does gdscript have little data structures??)

	# Read the file line by line
	while !file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == '[Metadata]':
			beatmap.title = file.get_line().trim_prefix('Title:')
		elif line == '[TimingPoints]':
			# Read hit objects
			while !file.eof_reached() and line != '':
				line = file.get_line().strip_edges()
				var line_parsed = line.split(',')
				if len(line_parsed) < 3 or (line_parsed[1] as int) < 0: 
					continue
				
				beatmap.timings.push_back(TimingPoint.new((line_parsed[0] as int)*1e-3, (line_parsed[1] as float)*1e-3, (line_parsed[2] as int)))
				
				#if not beatmap.start_offset: beatmap.start_offset = (line[0] as float)*1e-3
				#beatmap.bpm = 1 / (line[1] as float) * 60e3
				
				#var time = (line[2] as int)*1e-3
				#var duration = (line[5].split(':')[0] as int)*1e-3
				#var info = HitObjectInfo.new(time, _POSITION_MAP[x], (line[3] as int) != 1, 0.0 if duration == 0 else duration - time)
#
				#key_set[_POSITION_MAP[x]] = null # Dict acts like a set
				#beatmap.objects.push_back(info)
		elif line == '[HitObjects]':
			# Read hit objects
			while !file.eof_reached():
				line = file.get_line().strip_edges()
				var line_parsed = line.split(',')
				var x = line_parsed[0] as int
				if not x or x == 0: continue
				
				var time = (line_parsed[2] as int)*1e-3
				var duration = (line_parsed[5].split(':')[0] as int)*1e-3
				var info = HitObjectInfo.new(time, _POSITION_MAP[x], (line_parsed[3] as int) != 1, 0.0 if duration == 0 else duration - time)

				key_set[_POSITION_MAP[x]] = null # Dict acts like a set
				beatmap.objects.push_back(info)
	beatmap.start_offset = beatmap.timings[0].start_time
	file.close()

	# Try to estimate the number of keys for the beatmap by the number of unique
	# note positions within the file.
	# TODO: Not robust, better to do two passes one getting unique, and the other
	#       dynamically assigning key indices and key count based on that first
	#       count!
	beatmap.num_keys = len(key_set)
	beatmap.is_initialized = true
	print('(beatmap) loaded: ' + beatmap_file_path)
	print('   --- track title:  %s' % beatmap.title) 
	print('   --- num timings:  %d' % len(beatmap.timings)) 
	print('   --- num objects:  %d' % len(beatmap.objects))
	print('   --- num keys:     %d' % beatmap.num_keys)
	print('   --- start offset: %fs' % beatmap.start_offset)
