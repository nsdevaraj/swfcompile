package com.adams.swfbuilder.util
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class PropertyList extends EventDispatcher
	{
		private var properties:Array = new Array();
		
		public function PropertyList(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function addProperty(p_property:String):void
		{
			if(!checkDuplicates(p_property)) properties.push({label:p_property});
		}
		
		public function removeProperty(p_property:String):void
		{
			for(var i:int=0;i<properties.length;i++) 
			{
				if(properties[i].label == p_property) 
				{
					properties.splice(i,1);
					break;
				}
			}
		}
		
		public function getProperties():Array
		{
			return properties;
		}
		
		private function checkDuplicates(p_property:String):Boolean
		{
			for(var i:int=0;i<properties.length;i++) if(properties[i].label == p_property) return true;
			return false;
		}
		
	}
}