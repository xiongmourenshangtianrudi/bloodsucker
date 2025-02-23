shader_type canvas_item;
uniform sampler2D transition_texture:filter_nearest;
uniform vec4 texture_color:source_color;
uniform float persent: hint_range(0.0, 1.0);


void vertex() {
	}

void fragment() {

	vec4 transition_color = texture(transition_texture,UV);
	if (transition_color.r > persent){
		COLOR.a = 0.0;
	}else{
		COLOR = texture_color;
	}
}
