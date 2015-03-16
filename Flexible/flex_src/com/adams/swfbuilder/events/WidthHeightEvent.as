package com.adams.swfbuilder.events
{
	import flash.events.Event;

	public class WidthHeightEvent extends Event
	{
		public static var OK:String = "ok";
		public static var CANCEL:String = "cancel";
		
		public var width:* = 200;
		public var height:* = 200;
		public var percentWidth:* = null;
		public var percentHeight:* = null;
		
		public function WidthHeightEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, p_width:Number=200, p_height:Number=200, p_percentWidth:*=null, p_percentHeight:*=null)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
			width = p_width <= 0 ? width : p_width;
			height = p_height <= 0 ? height : p_height;
			percentWidth = p_percentWidth;
			percentHeight = p_percentHeight;
		}
		
	}
}