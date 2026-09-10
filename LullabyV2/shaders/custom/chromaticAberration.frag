#pragma header

uniform float amount = 4;

vec2 uv = openfl_TextureCoordv.xy;
vec2 pixel = uv*openfl_TextureSize.xy;
vec2 size = openfl_TextureSize;
void main(void){
	vec4 col;

	col.r = flixel_texture2D(bitmap,vec2(uv.x+amount/openfl_TextureSize.x,uv.y)).r;
	col.g = flixel_texture2D(bitmap,uv).g;
	col.b = flixel_texture2D(bitmap,vec2(uv.x-amount/openfl_TextureSize.x,uv.y)).b;
	col.a = flixel_texture2D(bitmap,uv).a;

	gl_FragColor = col;
}