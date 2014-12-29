package openfl._internal.renderer.opengl.utils;

import lime.graphics.opengl.GL;
import openfl.utils.ArrayBufferView;
import openfl.utils.Float32Array;


class VertexAttribute {

	public var components:Int;
	public var normalized:Bool = false;
	public var type:ElementType;
	public var name:String;
	public var enabled:Bool = true;
	public var elements(get, never):Int;
	
	public var defaultValue:Float32Array;
	
	public function new(components:Int, type:ElementType, normalized:Bool = false, name:String) {
		this.components = components;
		this.type = type;
		this.normalized = normalized;
		this.name = name;
		
		defaultValue = new Float32Array(components);
	}
	
	private inline function getElementsBytes() {
		return switch(type) {
			case BYTE, UNSIGNED_BYTE: 1;
			case SHORT, UNSIGNED_SHORT: 2;
			default: 4;
		}
	}	
	
	private inline function get_elements():Int {
		return Math.floor((components * getElementsBytes()) / 4);
	}
	
}

@:enum abstract ElementType(Int) from Int to Int {
	var BYTE = GL.BYTE;
	var UNSIGNED_BYTE = GL.UNSIGNED_BYTE;
	var SHORT = GL.SHORT;
	var UNSIGNED_SHORT = GL.UNSIGNED_SHORT;
	var FLOAT = GL.FLOAT;
}