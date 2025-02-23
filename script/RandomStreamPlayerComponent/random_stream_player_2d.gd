extends AudioStreamPlayer2D

@export var streams:Array[AudioStream]
@export var randomize_pitch :bool = true
@export var min_pich :float = 0.9
@export var max_pich :float = 1.1

func play_random():
	if streams ==null || streams.size() ==0:
		return
		
		
	if randomize_pitch:
		self.pitch_scale = randf_range(min_pich,max_pich)	
	else :
		self.pitch_scale = 1	
	var chosen_stream =streams.pick_random()
	stream = chosen_stream
	self.play()
