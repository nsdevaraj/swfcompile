package com.adams.swfbuilder.containers
{
	import mx.containers.Grid;
	 
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Panel;
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	
	import com.adams.swfbuilder.ControlEditor;
	import com.adams.swfbuilder.dialogs.RowsColumns;
	import com.adams.swfbuilder.events.RowColumnEvent;
	import com.adams.swfbuilder.managers.StageManager;
	import com.adams.swfbuilder.util.MXMLTools;
	import com.adams.swfbuilder.util.PropertiesTools;
	import com.adams.swfbuilder.util.PropertyManager;
	import mx.containers.GridRow;
	import mx.containers.GridItem;

	public class MXMLGrid extends Grid
	{
		private var pop:RowsColumns; 
		private var propertyManager:PropertyManager;
		private var rows:Number;
		private var columns:Number;
		
		public function MXMLGrid()
		{
			super(); 
			propertyManager = new PropertyManager(this);
			
			if(MXMLTools.getInstance().getLoading()) 
			{
				propertyManager.initializeProperties();
				return;
			}
			pop = RowsColumns(PopUpManager.createPopUp(flash.display.DisplayObject(mx.core.Application.application), RowsColumns,true));
			PopUpManager.centerPopUp(pop);
			pop.addEventListener(RowColumnEvent.CANCEL, handleCancel);
			pop.addEventListener(RowColumnEvent.OK, handleOk);
		}
		
		public function getProperties():Array
		{
			return propertyManager.getProperties();
		}
		
		public function setProperty(p_property:String, value:*):void
		{
			propertyManager.setProperty(p_property, value);
		}
		
		private function handleOk(e:RowColumnEvent):void
		{
			//need to set the width/height passed in before setting up the propertyManager.
			//this is so the PM will grab the correct values.
			rows = e.rows;
			columns = e.columns;
			
			width = 200;
			height = 200;
			
			for(var i:int=0;i<rows;i++)
			{
				var row:GridRow = new GridRow();
				row.width = width;
				row.height = height;
				this.addChild(row);
				for(var j:int=0;j<rows;j++)
				{
					var col:GridItem = new GridItem();
					col.width = width;
					col.height = height;
					row.addChild(col);
				}
			}

			propertyManager.initializeProperties(e);
		}
		
		private function handleCancel(e:RowColumnEvent):void
		{
			parent.removeChild(this);
		}
		
	}
}