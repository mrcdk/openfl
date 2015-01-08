package openfl._internal.renderer.opengl.shaders2;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;


class DrawTrianglesShader extends Shader {

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
			// the passed color is ARGB format
			'   vColor = ${Attrib.Color}.bgra;',
			'}',

		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision lowp float;',
			'#endif',
			
			'uniform sampler2D ${Uniform.Sampler};',
			'uniform vec3 ${Uniform.Color};',
			'uniform bool ${Uniform.UseTexture};',
			'uniform float ${Uniform.Alpha};',
			'uniform vec4 ${Uniform.ColorMultiplier};',
			'uniform vec4 ${Uniform.ColorOffset};',
			
			'varying vec2 vTexCoord;',
			'varying vec4 vColor;',
			
			'vec4 tmp;',
			
			'void main(void) {',
			'   if(${Uniform.UseTexture}) {',
			'       tmp = texture2D(${Uniform.Sampler}, vTexCoord);',
			'   } else {',
			'       tmp = vec4(${Uniform.Color}, 1.);',
			'   }',
			
			'   vec4 vc = vColor;',
			'   vec4 cm = ${Uniform.ColorMultiplier};',

			'   vec4 mult = clamp(tmp * vc * cm, 0., 1.);',
			'   mult = mult + ${Uniform.ColorOffset};',
			'   mult = vec4(mult.rgb * mult.a, mult.a);',
			'   gl_FragColor = mult;',
			'}'
		];
		
		init ();
	}
	
	override function init() {
		super.init();
		
		// TODO Modify graphicsrenderer to draw projection -y
		getAttribLocation(Attrib.Position);
		getAttribLocation(Attrib.TexCoord);
		getAttribLocation(Attrib.Color);
		
		getUniformLocation(Uniform.Sampler);
		getUniformLocation(Uniform.ProjectionVector);
		getUniformLocation(Uniform.OffsetVector);
		getUniformLocation(Uniform.Color);
		getUniformLocation(Uniform.Alpha);
		getUniformLocation(Uniform.UseTexture);
		getUniformLocation(Uniform.ColorMultiplier);
		getUniformLocation(Uniform.ColorOffset);
		
	}
	
}

@:enum private abstract Attrib(String) from String to String {
	var Position = DefAttrib.Position;
	var TexCoord = DefAttrib.TexCoord;
	var Color = DefAttrib.Color;
}

@:enum private abstract Uniform(String) from String to String {
	var UseTexture = "uUseTexture";
	var Sampler = DefUniform.Sampler;
	var ProjectionVector = DefUniform.ProjectionVector;
	var OffsetVector = DefUniform.OffsetVector;
	var Color = DefUniform.Color;
	var Alpha = DefUniform.Alpha;
	var ColorMultiplier = DefUniform.ColorMultiplier;
	var ColorOffset = DefUniform.ColorOffset;	
}

typedef DrawTrianglesAttrib = Attrib;
typedef DrawTrianglesUniform = Uniform;