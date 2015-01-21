package openfl.geom; #if !flash #if (display || openfl_next || js)


import lime.math.ColorMatrix;
import lime.utils.Float32Array;


class ColorTransform {
	
	
	public var alphaMultiplier:Float;
	@:isVar public var alphaOffset(default, set):Float;
	public var blueMultiplier:Float;
	@:isVar public var blueOffset(default, set):Float;
	public var color (get, set):Int;
	public var greenMultiplier:Float;
	@:isVar public var greenOffset(default, set):Float;
	public var redMultiplier:Float;
	@:isVar public var redOffset(default, set):Float;
	
	
	public function new (redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redOffset:Float = 0, greenOffset:Float = 0, blueOffset:Float = 0, alphaOffset:Float = 0):Void {
		
		this.redMultiplier = redMultiplier;
		this.greenMultiplier = greenMultiplier;
		this.blueMultiplier = blueMultiplier;
		this.alphaMultiplier = alphaMultiplier;
		this.redOffset = redOffset;
		this.greenOffset = greenOffset;
		this.blueOffset = blueOffset;
		this.alphaOffset = alphaOffset;
		
	}
	
	
	public function concat (second:ColorTransform):Void {
		
		redMultiplier += second.redMultiplier;
		greenMultiplier += second.greenMultiplier;
		blueMultiplier += second.blueMultiplier;
		alphaMultiplier += second.alphaMultiplier;
		
	}
	
	
	@:noCompletion private function __combine (ct:ColorTransform):Void {
		redMultiplier *= ct.redMultiplier;
		greenMultiplier *= ct.greenMultiplier;
		blueMultiplier *= ct.blueMultiplier;
		alphaMultiplier *= ct.alphaMultiplier;
		
		redOffset += ct.redOffset;
		greenOffset += ct.greenOffset;
		blueOffset += ct.blueOffset;
		alphaOffset += ct.alphaOffset;
		
	}
	
	@:noCompletion private function __equals (ct:ColorTransform, ?skipAlphaMultiplier:Bool = false):Bool {
		return ( ct != null &&
			redMultiplier == ct.redMultiplier &&
			greenMultiplier == ct.greenMultiplier &&
			blueMultiplier == ct.blueMultiplier &&
			(skipAlphaMultiplier || alphaMultiplier == ct.alphaMultiplier) &&
			
			redOffset == ct.redOffset &&
			greenOffset == ct.greenOffset &&
			blueOffset == ct.blueOffset &&
			alphaOffset == ct.alphaOffset
		);
	}
	
	@:noCompletion private function __clone ():ColorTransform {
		return new ColorTransform(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
	}
	
	private inline function clampOffset(v:Float):Float {
		return Math.max(-255, Math.min(v, 255));
	}
	
	// Getters & Setters
	
	@:noCompletion private inline function set_redOffset(v:Float):Float {
		return redOffset = clampOffset(v);
	}
	@:noCompletion private inline function set_greenOffset(v:Float):Float {
		return greenOffset = clampOffset(v);
	}
	@:noCompletion private inline function set_blueOffset(v:Float):Float {
		return blueOffset = clampOffset(v);
	}
	@:noCompletion private inline function set_alphaOffset(v:Float):Float {
		return alphaOffset = clampOffset(v);
	}
	

	@:noCompletion private function get_color ():Int {
		
		return ((Std.int (redOffset) << 16) | (Std.int (greenOffset) << 8) | Std.int (blueOffset));
		
	}
	
	
	@:noCompletion private function set_color (value:Int):Int {
		
		redOffset = (value >> 16) & 0xFF;
		greenOffset = (value >> 8) & 0xFF;
		blueOffset = value & 0xFF;
		
		redMultiplier = 0;
		greenMultiplier = 0;
		blueMultiplier = 0;
		
		return color;
		
	}
	
	
	@:noCompletion private function __toLimeColorMatrix ():ColorMatrix {
		
		return cast new Float32Array ([ redMultiplier, 0, 0, 0, redOffset / 255, 0, greenMultiplier, 0, 0, greenOffset / 255, 0, 0, blueMultiplier, 0, blueOffset / 255, 0, 0, 0, alphaMultiplier, alphaOffset / 255 ]);
		
	}
	
	
}


#else
typedef ColorTransform = openfl._v2.geom.ColorTransform;
#end
#else
typedef ColorTransform = flash.geom.ColorTransform;
#end