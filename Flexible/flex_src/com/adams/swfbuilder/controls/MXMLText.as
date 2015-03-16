package com.adams.swfbuilder.controls
{
	import mx.controls.Text;
	 
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	
	import com.adams.swfbuilder.ControlEditor;
	import com.adams.swfbuilder.dialogs.WidthHeight;
	import com.adams.swfbuilder.events.WidthHeightEvent;
	import com.adams.swfbuilder.managers.StageManager;
	import com.adams.swfbuilder.util.MXMLTools;
	import com.adams.swfbuilder.util.PropertiesTools;
	import com.adams.swfbuilder.util.PropertyManager;

	public class MXMLText extends Text
	{
		private var pop:WidthHeight; 
		private var propertyManager:PropertyManager;
		
		public function MXMLText()
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
		}
		
		private function handleCancel(e:WidthHeightEvent):void
		{
			parent.removeChild(this);
		}
		
	}
}