shader_type canvas_item;

uniform vec4 Colors: source_color ;
uniform float mix_color: hint_range(0.0, 1.0, 0.001);
uniform float alphaColor: hint_range(0.0, 1.0, 0.001);

void fragment() {

	vec4 texture_color = texture(TEXTURE,UV);

	COLOR = vec4(mix(texture_color.rgb, Colors.rgb, mix_color), texture_color.a += alphaColor);

}
