package com.adams.swfbuilder.controls
{
	import mx.controls.Button;
	 
	
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import com.adams.swfbuilder.managers.StageManager;
	import com.adams.swfbuilder.util.PropertyManager;
	import mx.events.FlexEvent;

	public class MXMLButton extends Button
	{ 
		private var propertyManager:PropertyManager;
		
		public function MXMLButton()
		{ 
			
			propertyManager = new PropertyManager(this);
			addEventListener(mx.events.FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(e:FlexEvent):void
		{
			propertyManager.initializeProperties();
		}
		
		public function getProperties():Array
		{
			return propertyManager.getProperties();
		}
		
		public function setProperty(p_property:String, value:*):void
		{
			propertyManager.setProperty(p_property, value);
		}
	}
}