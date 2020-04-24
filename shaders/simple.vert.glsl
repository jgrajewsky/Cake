#version 450

in vec3 pos;

uniform vec2 u_size;
uniform mat3 u_matrix;

void main() {
	gl_Position = vec4((u_matrix * vec3(pos.xy * u_size, 1)).xy, 0.0, 1.0);
}
