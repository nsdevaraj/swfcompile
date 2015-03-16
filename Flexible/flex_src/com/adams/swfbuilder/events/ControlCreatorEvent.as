package com.adams.swfbuilder.events
{
	import flash.events.Event;
	import mx.collections.ArrayCollection;

	public class ControlCreatorEvent extends Event
	{
		public static var PROPERTIESCHANGE:String = "propertiesChange";
		public var properties:ArrayCollection;
		public function ControlCreatorEvent(type:String, p_props:ArrayCollection, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			properties = p_props;
		}
		
	}
}