package openfl.display; #if !flash #if (display || openfl_next || js)


import openfl._internal.renderer.RenderSession;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Transform;


interface IBitmapDrawable {
	
	var __worldTransform:Matrix;
	var __worldColorTransform:ColorTransform;
	var blendMode:BlendMode;
	
	
	function __renderCanvas (renderSession:RenderSession):Void;
	function __renderGL (renderSession:RenderSession):Void;
	function __renderMask (renderSession:RenderSession):Void;
	function __updateChildren (transformOnly:Bool):Void;
	
}


#else
typedef IBitmapDrawable = openfl._v2.display.IBitmapDrawable;
#end
#else
typedef IBitmapDrawable = flash.display.IBitmapDrawable;
#end