package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;

class PatternFillShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 ${Attrib.Position};',
			'uniform mat3 ${Uniform.TranslationMatrix};',
			'uniform vec2 ${Uniform.ProjectionVector};',
			'uniform vec2 ${Uniform.OffsetVector};',
			'uniform mat3 ${Uniform.PatternMatrix};',
			
			'varying vec2 vPosition;',
			
			'void main(void) {',
			'   vec3 v = ${Uniform.TranslationMatrix} * vec3(${Attrib.Position} , 1.0);',
			'   v -= ${Uniform.OffsetVector}.xyx;',
			'   gl_Position = vec4( v.x / ${Uniform.ProjectionVector}.x -1.0, v.y / - ${Uniform.ProjectionVector}.y + 1.0 , 0.0, 1.0);',
			'   vPosition = (${Uniform.PatternMatrix} * vec3(${Attrib.Position}, 1)).xy;',
			'}'

		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'uniform float ${Uniform.Alpha};',
			'uniform vec2 ${Uniform.PatternTL};',
			'uniform vec2 ${Uniform.PatternBR};',
			'uniform vec4 ${Uniform.ColorOffset};',
			'uniform sampler2D ${Uniform.Sampler};',
			
			'varying vec2 vPosition;',
			
			'void main(void) {',
			'   vec2 pos = mix(${Uniform.PatternTL}, ${Uniform.PatternBR}, vPosition);',
			'   vec4 tcol = texture2D(${Uniform.Sampler}, pos);',
			'   gl_FragColor = (tcol * ${Uniform.Alpha}) + ${Uniform.ColorOffset};',
			'}'
		];
		
		init();
	}
	
	override function init() 
	{
		super.init();
		
		getAttribLocation(Attrib.Position);
		
		getUniformLocation(Uniform.TranslationMatrix);
		getUniformLocation(Uniform.PatternMatrix);
		getUniformLocation(Uniform.ProjectionVector);
		getUniformLocation(Uniform.OffsetVector);
		getUniformLocation(Uniform.Sampler);
		getUniformLocation(Uniform.PatternTL);
		getUniformLocation(Uniform.PatternBR);
		getUniformLocation(Uniform.Alpha);
		getUniformLocation(Uniform.ColorOffset);
	}
	
}

@:enum private abstract Attrib(String) to String from String {
	var Position = "aPosition";
}

@:enum private abstract Uniform(String) from String to String {
	var TranslationMatrix = "uTranslationMatrix";
	var PatternMatrix = "uPatternMatrix";
	var ProjectionVector = "uProjectionVector";
	var OffsetVector = "uOffsetVector";
	var Sampler = "uSampler0";
	var PatternTL = "uPatternTL";
	var PatternBR = "uPatternBR";
	var Alpha = "uAlpha";
	var ColorOffset = "uColorOffset";
}