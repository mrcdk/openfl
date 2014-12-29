package openfl._internal.renderer.opengl.utils;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.*;

class ShaderManager2 {

	public var gl:GLRenderContext;
	public var currentShader:Shader;
	
	public var defaultShader:DefaultShader;
	public var fillShader:FillShader;
	public var patternFillShader:PatternFillShader;
	public var drawTrianglesShader:DrawTrianglesShader;
	
	public function new(gl:GLRenderContext) {
		setContext(gl);
	}
	
	public function setContext(gl:GLRenderContext) {
		this.gl = gl;
		
		defaultShader = new DefaultShader(gl);
		fillShader = new FillShader(gl);
		patternFillShader = new PatternFillShader(gl);
		drawTrianglesShader = new DrawTrianglesShader(gl);
		
		setShader(defaultShader, true);
		
	}
	
	public function destroy ():Void {
		
		defaultShader.destroy();
		fillShader.destroy();
		patternFillShader.destroy();
		drawTrianglesShader.destroy();
		
		gl = null;
		
	}
	
	public function setShader(shader:Shader, ?force:Bool = false) {
		if (!force && currentShader.ID == shader.ID) return false;
		currentShader = shader;
		
		gl.useProgram(shader.program);
		return true;
	}
	
}