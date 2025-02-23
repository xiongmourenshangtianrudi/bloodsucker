shader_type canvas_item;
uniform vec4 color_left: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color_right: source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform float gra:hint_range(0.0, 1, 0.1) =0;
void fragment() {
	 vec2 uv = UV;

    // 计算水平渐变的插值比例（从左到右）
    float gradient = uv.x * gra; // 主要是计算坐标

    // 使用插值函数 mix() 实现颜色渐变
    vec4 gradient_color = mix(color_left, color_right, gradient);

    // 设置片段颜色
    COLOR = gradient_color;
	// Called for every pixel the material is visible on.
}
