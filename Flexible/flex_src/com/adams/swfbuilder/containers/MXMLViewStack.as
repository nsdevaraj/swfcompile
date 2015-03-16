package com.adams.swfbuilder.containers
{
	import mx.containers.ViewStack;
	 
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.containers.Panel;
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	
	import com.adams.swfbuilder.dialogs.WidthHeight;
	import com.adams.swfbuilder.events.WidthHeightEvent;
	import com.adams.swfbuilder.managers.StageManager;
	import com.adams.swfbuilder.util.MXMLTools;
	import com.adams.swfbuilder.util.PropertyManager;
	import com.adams.swfbuilder.util.PropertiesTools;
	import com.adams.swfbuilder.ControlEditor;
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;

	public class MXMLViewStack extends ViewStack
	{ 
		private var propertyManager:PropertyManager;
		
		public function MXMLViewStack()
		{
			super();
			width=200;
			height=200;
			 
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