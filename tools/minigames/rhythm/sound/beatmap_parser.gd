class_name BeatmapParser

class ObjectInfo:
	var position : float
	var time_seconds : float
	var is_slider : bool
	var duration_seconds : float

static func load(path : String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var read_hit_objects = false
	var output = {}
	var beatmap_objects = []

	# Read the file line by line
	while !file.eof_reached():
		var line = file.get_line()
		# Check if the line contains "[TimingPoints]"
		if line.strip_edges() == '[TimingPoints]':
			line = file.get_line().split(',')
			output['offset'] = (line[0] as float)*1e-3
			output['bpm'] = 1 / (line[1] as float) * 1e3 * 60
		elif line.strip_edges() == '[HitObjects]':
			read_hit_objects = true
			continue

		if read_hit_objects:
			line = line.split(',')
			var x = line[0] as int
			if not x or x == 0: continue
			# TODO: i never said this parser was robust...
			match x as int:
				64:  x = -0.75
				192: x = -0.25
				320: x = 0.25
				448: x = 0.75

			var info = ObjectInfo.new()
			info.position = x
			info.time_seconds = (line[2] as int)*1e-3
			info.is_slider = false if ((line[3] as int) == 1) else true
			info.duration_seconds = (line[5].split(':')[0] as int)*1e-3 - info.time_seconds

			beatmap_objects.push_back(info)
	file.close()

	output['objects'] = beatmap_objects
	print('(beatmap_loader) loaded: ' + path)
	print('                   --- bpm: ' + str(output['bpm']))
	return output
