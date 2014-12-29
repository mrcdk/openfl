package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;

class FillShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 ${Attrib.Position};',
			'uniform mat3 ${Uniform.TranslationMatrix};',
			'uniform vec2 ${Uniform.ProjectionVector};',
			'uniform vec2 ${Uniform.OffsetVector};',
			
			'void main(void) {',
			'   vec3 v = ${Uniform.TranslationMatrix} * vec3(${Uniform.ProjectionVector} , 1.0);',
			'   v -= ${Uniform.OffsetVector}.xyx;',
			'   gl_Position = vec4( v.x / ${Uniform.ProjectionVector}.x -1.0, v.y / - ${Uniform.ProjectionVector}.y + 1.0 , 0.0, 1.0);',
			'}'

		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'uniform vec4 ${Uniform.Color};',
			
			'void main(void) {',
			'   gl_FragColor = ${Uniform.Color};',
			'}'
		];
		
		init ();
	}
	
	override function init() {
		super.init();
		// TODO move the color calculation to the graphicsrenderer class
		getAttribLocation(Attrib.Position);
		getUniformLocation(Uniform.TranslationMatrix);
		getUniformLocation(Uniform.ProjectionVector);
		getUniformLocation(Uniform.OffsetVector);
		getUniformLocation(Uniform.Color);
	}
	
}

@:enum private abstract Attrib(String) from String to String {
	var Position = "aPosition";
}

@:enum private abstract Uniform(String) from String to String {
	var TranslationMatrix = "uTranslationMatrix";
	var ProjectionVector = "uProjectionVector";
	var OffsetVector = "uOffsetVector";
	var Color = "uColor";
}