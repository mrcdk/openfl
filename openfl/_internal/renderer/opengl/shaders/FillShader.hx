package openfl._internal.renderer.opengl.shaders;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLUniformLocation;

class FillShader extends AbstractShader {

	public var offsetVector:GLUniformLocation;
	public var translationMatrix:GLUniformLocation;
	public var alpha:GLUniformLocation;
	public var color:GLUniformLocation;
	public var colorOffsets:GLUniformLocation;
	
	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 aVertexPosition;',
			'uniform mat3 translationMatrix;',
			'uniform vec2 projectionVector;',
			'uniform vec2 offsetVector;',
			'uniform vec3 color;',
			'uniform float alpha;',
			'uniform vec4 colorOffsets;',
			
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   vec3 v = translationMatrix * vec3(aVertexPosition , 1.0);',
			'   v -= offsetVector.xyx;',
			'   gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);',
			'   vColor = vec4(color * alpha, alpha) + colorOffsets;',
			'}'

		];
		
		fragmentSrc = [
			#if !desktop
			'precision mediump float;',
			#end
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   gl_FragColor = vColor;',
			'}'
		];
		
		init ();
		
	}
	
	public override function init ():Void {
		
		super.init ();
		
		translationMatrix = gl.getUniformLocation (program, 'translationMatrix');
		projectionVector = gl.getUniformLocation (program, 'projectionVector');
		offsetVector = gl.getUniformLocation (program, 'offsetVector');
		
		color = gl.getUniformLocation (program, 'color');
		alpha = gl.getUniformLocation (program, 'alpha');
		colorOffsets = gl.getUniformLocation (program, 'colorOffsets');
		
		aVertexPosition = gl.getAttribLocation (program, 'aVertexPosition');
		
		attributes = [aVertexPosition];
		
	}
	
}