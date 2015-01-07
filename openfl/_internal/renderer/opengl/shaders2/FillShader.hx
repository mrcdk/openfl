package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;

class FillShader extends Shader {

	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 ${Attrib.Position};',
			'uniform mat3 ${Uniform.TranslationMatrix};',
			'uniform vec2 ${Uniform.ProjectionVector};',
			'uniform vec2 ${Uniform.OffsetVector};',
			
			'uniform vec4 ${Uniform.Color};',
			'uniform float ${Uniform.Alpha};',
			'uniform vec4 ${Uniform.ColorOffset};',
			
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   vec3 v = ${Uniform.TranslationMatrix} * vec3(${Attrib.Position}, 1.0);',
			'   v -= ${Uniform.OffsetVector}.xyx;',
			'   gl_Position = vec4( v.x / ${Uniform.ProjectionVector}.x -1.0, v.y / - ${Uniform.ProjectionVector}.y + 1.0 , 0.0, 1.0);',
			'   vColor = (${Uniform.Color} * ${Uniform.Alpha}) + ${Uniform.ColorOffset};',
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
		
		init ();
	}
	
	override function init() {
		super.init();
		
		getAttribLocation(Attrib.Position);
		getUniformLocation(Uniform.TranslationMatrix);
		getUniformLocation(Uniform.ProjectionVector);
		getUniformLocation(Uniform.OffsetVector);
		getUniformLocation(Uniform.Color);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
	}
	
}

@:enum private abstract Attrib(String) from String to String {
	var Position = DefAttrib.Position;
}

@:enum private abstract Uniform(String) from String to String {
	var TranslationMatrix = "uTranslationMatrix";
	var ProjectionVector = DefUniform.ProjectionVector;
	var OffsetVector = DefUniform.OffsetVector;
	var Color = DefUniform.Color;
	var Alpha = DefUniform.Alpha;
	var ColorMultiplier = DefUniform.ColorMultiplier;
	var ColorOffset = DefUniform.ColorOffset;
}

typedef FillAttrib = Attrib;
typedef FillUniform = Uniform;