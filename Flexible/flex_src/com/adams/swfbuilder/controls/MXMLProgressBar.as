package com.adams.swfbuilder.controls
{
	import mx.controls.ProgressBar;
	 
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import com.adams.swfbuilder.managers.StageManager;
	import com.adams.swfbuilder.util.PropertyManager;
	import mx.events.FlexEvent;

	public class MXMLProgressBar extends ProgressBar
	{ 
		private var propertyManager:PropertyManager;
		
		public function MXMLProgressBar()
		{
			super();
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