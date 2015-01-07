package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;


class DefaultShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 ${Attrib.Position};',
			'attribute vec2 ${Attrib.TexCoord};',
			'attribute vec4 ${Attrib.Color};',
			
			'uniform vec2 ${Uniform.ProjectionVector};',
			'uniform vec2 ${Uniform.OffsetVector};',
			
			'varying vec2 vTexCoord;',
			'varying vec4 vColor;',
			
			'const vec2 center = vec2(-1.0, 1.0);',
			
			'void main(void) {',
			'   gl_Position = vec4( ((${Attrib.Position} + ${Uniform.OffsetVector}) / ${Uniform.ProjectionVector}) + center , 0.0, 1.0);',
			'   vTexCoord = ${Attrib.TexCoord};',
			'   vColor = ${Attrib.Color};',
			'}'
		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'uniform sampler2D ${Uniform.Sampler};',
			'uniform vec4 ${Uniform.ColorMultiplier};',
			'uniform vec4 ${Uniform.ColorOffset};',
			
			'varying vec2 vTexCoord;',
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   vec4 tc = texture2D(${Uniform.Sampler}, vTexCoord);',
			'   vec4 vc = vColor;',
			'   vec4 cm = ${Uniform.ColorMultiplier};',

			'   vec4 mult = clamp(tc * vc * cm, 0., 1.);',
			'   mult = vec4(mult.rgb * mult.a, mult.a);',
			'   gl_FragColor = mult + ${Uniform.ColorOffset};',
			'}'
		
		];
		
		init();
		
	}
	
	override private function init() {
		super.init();

		getAttribLocation(Attrib.Position);
		getAttribLocation(Attrib.TexCoord);
		getAttribLocation(Attrib.Color);
		getUniformLocation(Uniform.ProjectionVector);
		getUniformLocation(Uniform.OffsetVector);
		getUniformLocation(Uniform.Sampler);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
	}
	
}

// TODO Find a way to apply these default attributes and uniforms to other shaders
@:enum private abstract Attrib(String) from String to String {
	var Position = "aPosition";
	var TexCoord = "aTexCoord0";
	var Color = "aColor";
}

@:enum private abstract Uniform(String) from String to String {
	var Sampler = "uSampler0";
	var ProjectionVector = "uProjectionVector";
	var OffsetVector = "uOffsetVector";
	var Color = "uColor";
	var Alpha = "uAlpha";
	var ColorMultiplier = "uColorMultiplier";
	var ColorOffset = "uColorOffset";
}

typedef DefAttrib = Attrib;
typedef DefUniform = Uniform;