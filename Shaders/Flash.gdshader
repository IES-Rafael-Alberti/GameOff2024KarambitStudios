shader_type canvas_item;

uniform vec2 light_position : hint_range(0.0, 1.0); // Posición de la linterna en UV (0-1)
uniform float light_radius : hint_range(0.0, 1.0) = 0.3; // Radio de la linterna
uniform float light_intensity : hint_range(0.0, 10.0) = 5.0; // Intensidad de la luz

void fragment() {
    // Coordenadas UV del fragmento actual
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;

    // Distancia desde el centro de la linterna a cada fragmento
    float distance = length(uv - light_position);

    // Calcular la intensidad de la luz en función de la distancia
    float light = smoothstep(light_radius, 0.0, distance) * light_intensity;

    // Aplica la iluminación al color original del fondo
    COLOR = texture(TEXTURE, UV) * vec4(light, light, light, 1.0);
}
