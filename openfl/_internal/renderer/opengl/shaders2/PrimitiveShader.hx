package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;

class PrimitiveShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc  = [
			'attribute vec2 ${Attrib.Position};',
			'attribute vec4 ${Attrib.Color};',
			'uniform mat3 ${Uniform.TranslationMatrix};',
			'uniform vec2 ${Uniform.ProjectionVector};',
			'uniform vec2 ${Uniform.OffsetVector};',
			
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   vec3 v = ${Uniform.TranslationMatrix} * vec3(${Attrib.Position} , 1.0);',
			'   v -= ${Uniform.OffsetVector}.xyx;',
			'   gl_Position = vec4( v.x / ${Uniform.ProjectionVector}.x -1.0, v.y / -${Uniform.ProjectionVector}.y + 1.0 , 0.0, 1.0);',
			'   vColor = ${Attrib.Color};',
			'}'
		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   gl_FragColor = vColor;',
			'}'
		];
		
		init();
	}
	
	override function init() 
	{
		super.init();
		
		getAttribLocation(Attrib.Position);
		getAttribLocation(Attrib.Color);
		getUniformLocation(Uniform.TranslationMatrix);
		getUniformLocation(Uniform.ProjectionVector);
		getUniformLocation(Uniform.OffsetVector);
	}
	
}

@:enum private abstract Attrib(String) to String from String {
	var Position = "aPosition";
	var Color = "aColor";
}

@:enum private abstract Uniform(String) from String to String {
	var TranslationMatrix = "uTranslationMatrix";
	var ProjectionVector = "uProjectionVector";
	var OffsetVector = "uOffsetVector";
}