package com.adams.swfbuilder.events
{
	import flash.events.Event;
	import mx.core.UIComponent;

	public class ControlEditorEvent extends Event
	{
		public static var CHANGETARGET:String = "changeTarget";
		public var properties:Array;
		public function ControlEditorEvent(type:String, p_properties:Array, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			properties = p_properties;
		}
		
	}
}