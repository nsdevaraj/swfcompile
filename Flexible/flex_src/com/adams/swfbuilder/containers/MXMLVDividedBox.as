package com.adams.swfbuilder.containers
{
	import flash.display.DisplayObject;
	import flash.utils.*;
	
	import mx.containers.Canvas;
	import mx.containers.HDividedBox;
	import mx.containers.VDividedBox;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	import com.adams.swfbuilder.dialogs.WidthHeight;
	import com.adams.swfbuilder.events.WidthHeightEvent;
	import com.adams.swfbuilder.util.GraphicTools;
	import com.adams.swfbuilder.util.MXMLTools;
	import com.adams.swfbuilder.util.PropertiesTools;
	import com.adams.swfbuilder.util.PropertyManager;

	public class MXMLVDividedBox extends VDividedBox
	{
		private var pop:WidthHeight;
		private var propertyManager:PropertyManager;
		//private var canvas:Canvas;
		
		public function MXMLVDividedBox()
		{
			super();
			propertyManager = new PropertyManager(this);
			
			if(MXMLTools.getInstance().getLoading()) 
			{
				propertyManager.initializeProperties();
				return;
			}
			pop = WidthHeight(PopUpManager.createPopUp(flash.display.DisplayObject(mx.core.Application.application), WidthHeight,true));
			PopUpManager.centerPopUp(pop);
			pop.addEventListener(WidthHeightEvent.CANCEL, handleCancel);
			pop.addEventListener(WidthHeightEvent.OK, handleOk);
		}
		
		public function getProperties():Array
		{
			return propertyManager.getProperties();
		}
		
		public function setProperty(p_property:String, value:*):void
		{
			propertyManager.setProperty(p_property, value);
		}
		
		private function handleOk(e:WidthHeightEvent):void
		{
			//need to set the width/height passed in before setting up the propertyManager.
			//this is so the PM will grab the correct values.
			if(e.width != null) width = e.width;
			if(e.height != null) height = e.height;
			
			propertyManager.initializeProperties(e);
			GraphicTools.getInstance().drawFrame(this);
		}
		
		private function handleCancel(e:WidthHeightEvent):void
		{
			parent.removeChild(this);
		}
	}
}