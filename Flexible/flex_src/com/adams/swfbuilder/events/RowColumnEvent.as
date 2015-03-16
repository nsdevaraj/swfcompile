package com.adams.swfbuilder.events
{
	import flash.events.Event;

	public class RowColumnEvent extends Event
	{
		public static var OK:String = "ok";
		public static var CANCEL:String = "cancel";
		
		public var rows:Number = 3;
		public var columns:Number = 3;
		
		public function RowColumnEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, p_rows:Number=3, p_columns:Number=3)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
			rows = p_rows <= 0 ? rows : p_rows;
			columns = p_columns <= 0 ? columns : p_columns;
		}
		
	}
}