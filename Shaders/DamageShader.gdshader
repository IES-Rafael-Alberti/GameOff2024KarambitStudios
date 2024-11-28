shader_type canvas_item;

uniform vec4 color: source_color;
uniform float mix_color: hint_range(0.0, 1.0, 0.01);
uniform float opacity: hint_range(0.0, 1.0, 0.01);
void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (texture_color.a != 0.0){
		COLOR = vec4(mix(texture_color.rgb,color.rgb, mix_color),opacity);
	}
}

void light(){
	float cNdotL = max(1.0, dot(NORMAL, LIGHT_DIRECTION));
	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}