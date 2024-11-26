shader_type canvas_item;

uniform vec4 damage_color : source_color;// Rojo
uniform float damage_intensity : hint_range(0.0, 1.0, 0.01) = 0.0; // Intensidad del efecto

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    // Mezcla el color del daño con el color de la textura
    COLOR = mix(texture_color, damage_color, damage_intensity);
}
