shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 10.0) = 5.0;  // 辖光强度
uniform float glow_radius : hint_range(0.0, 10.0) = 6.0;    // 辖光半径

void fragment() {
    // 获取当前片段的纹理坐标
    vec2 uv = SCREEN_UV;

    // 基于线宽计算距离
    float dist = length(uv + vec2(0.5, 0.5));  // 计算当前片段到线条中心的距离

    // 辖光效果：使用smoothstep平滑衰减
    float glow = smoothstep(0.0, glow_radius, dist);

    // 创建辉光效果颜色
    vec4 glow_color = vec4(1.0, 1.0, 1.0, glow * glow_strength);

    // 输出最终颜色：将辉光颜色与透明背景混合
    COLOR = mix(vec4(1.0, 0.0, 0.0, 1.0), glow_color, glow_color.a);
}