package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;


class DefaultShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 ${Attrib.Position};',
			'attribute vec2 ${Attrib.TexCoord};',
			'attribute vec4 ${Attrib.Color};',
			'attribute vec4 ${Attrib.ColorOffset};',
			
			'uniform vec2 ${Uniform.ProjectionVector};',
			'uniform vec2 ${Uniform.OffsetVector};',
			
			'varying vec2 vTexCoord;',
			'varying vec4 vColor;',
			'varying vec4 vColorOffset;',
			
			'const vec2 center = vec2(-1.0, 1.0);',
			
			'void main(void) {',
			'   gl_Position = vec4( ((${Attrib.Position} + ${Uniform.OffsetVector}) / ${Uniform.ProjectionVector}) + center , 0.0, 1.0);',
			'   vTexCoord = ${Attrib.TexCoord};',
			'   vColor = vec4(${Attrib.Color}.rgb * ${Attrib.Color}.a, ${Attrib.Color}.a);',
			'   vColorOffset = ${Attrib.ColorOffset} / 255.;',
			'}'
		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'varying vec2 vTexCoord;',
			'varying vec4 vColor;',
			'varying vec4 vColorOffset;',
			
			'uniform sampler2D ${Uniform.Sampler};',
			
			'void main(void) {',
			'   gl_FragColor = (texture2D(${Uniform.Sampler}, vTexCoord) * vColor) + vColorOffset;',
			'}'
		
		];
		
		init();
		
	}
	
	override private function init() {
		super.init();

		getAttribLocation(Attrib.Position);
		getAttribLocation(Attrib.TexCoord);
		getAttribLocation(Attrib.Color);
		getAttribLocation(Attrib.ColorOffset);
		getUniformLocation(Uniform.ProjectionVector);
		getUniformLocation(Uniform.OffsetVector);
		getUniformLocation(Uniform.Sampler);
	}
	
}

@:enum abstract Attrib(String) from String to String {
	var Position = "aPosition";
	var TexCoord = "aTexCoord0";
	var Color = "aColor";
	var ColorOffset = "aColorOffset";
}

@:enum abstract Uniform(String) from String to String {
	var Sampler = "uSampler0";
	var ProjectionVector = "uProjectionVector";
	var OffsetVector = "uOffsetVector";
	var Color = "uColor";
	var ColorOffset = "uColorOffset";
}