#version 120

uniform sampler2D texture;
uniform sampler2D mask;

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    gl_FragColor = gl_Color * texture2D(texture, uv) * texture2D(mask, uv);
}