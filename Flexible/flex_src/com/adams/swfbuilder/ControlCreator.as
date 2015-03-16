package com.adams.swfbuilder
{ 
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.controls.*;
	//import mx.containers.*;
	import com.adams.swfbuilder.controls.*;
	import com.adams.swfbuilder.containers.*;
	import com.adams.swfbuilder.managers.StageManager;
	import mx.core.Application;
	import flash.utils.getTimer;
	import mx.core.UIComponent;
	import flash.utils.getQualifiedClassName;
	import com.adams.swfbuilder.util.MXMLTools;
	
	public class ControlCreator extends EventDispatcher
	{
		private static var _instance:ControlCreator;
		
		public var app:Object = mx.core.Application.application;
		
		private var ce:ControlEditor;
		
		public static function getInstance():ControlCreator
		{
			if(_instance == null)
			{
				_instance = new ControlCreator();
				_instance.initialize();
			}
			
			return _instance;
		}
		
		public function initialize():void
		{
			//log = new XrayLog();
			ce = ControlEditor.getInstance();
		}
		
		public function createObjectHandler(e:Event):void
		{
			//log.debug("selectedItem", e.target.selectedItem.@label);
			var control:String = e.target.selectedItem.@label;
			// setLastTask so objects that are created/instantiated later than this build process will know what to do
           	MXMLTools.getInstance().setLastTask(MXMLTools.RENDER);
			
			createObject(control);
			
			// clear the selection so that you can add the same component over again
			e.target.selectedItem = null;
		}
		
		public function createObject(control:String):UIComponent
		{			
			var obj:*;
			switch(control)
			{
				case "Button":
					obj = new MXMLButton();
				break;
				
				case "CheckBox":
					obj = new MXMLCheckBox();
				break;
				
				case "ColorPicker":
					obj = new MXMLColorPicker();
				break;
				
				case "ComboBox":
					obj = new MXMLComboBox();
				break;
				
				case "DataGrid":
					obj = new MXMLDataGrid();
				break;
				
				case "DateChooser":
					obj = new MXMLDateChooser();
				break;
				
				case "DateField":
					obj = new MXMLDateField();
				break;
				
				case "HSlider":
					obj = new MXMLHSlider();
				break;
				
				case "HorizontalList":
					obj = new MXMLHorizontalList();
				break;
				
				case "Image":
					obj = new MXMLImage();
				break;
				
				case "Label":
					obj = new MXMLLabel();
					obj.text = "New Label";
				break;
				
				case "LinkButton":
					obj = new MXMLLinkButton();
				break;
				
				case "List":
					obj = new MXMLList();
				break;
				
				case "NumericStepper":
					obj = new MXMLNumericStepper();
				break;
				
				case "PopUpButton":
					obj = new MXMLPopUpButton();
				break;
				
				case "PopUpMenuButton":
					obj = new MXMLPopUpMenuButton();
				break;
				
				case "ProgressBar":
					obj = new MXMLProgressBar();
				break;
				
				case "RadioButton":
					obj = new MXMLRadioButton();
				break;
				
				case "RadioButtonGroup":
					obj = new MXMLRadioButtonGroup();
				break;
				
				case "RichTextEditor":
					obj = new MXMLRichTextEditor();
				break;
				
				case "SWFLoader":
					obj = new MXMLSWFLoader();
				break;
				
				case "Text":
					obj = new MXMLText();
				break;
				
				case "TextArea":
					obj = new MXMLTextArea();
				break;
				
				case "TextInput":
					obj = new MXMLTextInput();
				break;
				
				case "TileList":
					obj = new MXMLTileList();
				break;
				
				case "Tree":
					obj = new MXMLTree();
				break;
				
				case "VSlider":
					obj = new MXMLVSlider();
				break;
				
				case "VideoDisplay":
					obj = new MXMLVideoDisplay();
				break;
				
				
				//========================
				
				case "ApplicationControlBar":
					obj = new MXMLApplicationControlBar();
				break;
				
				case "Canvas":
					obj = new MXMLCanvas();
				break;
				
				case "ControlBar":
					obj = new MXMLControlBar();
				break;
				
				case "Form":
					obj = new MXMLForm();
				break;
				
				case "FormHeading":
					obj = new MXMLFormHeading();
				break;
				
				case "Grid":
					obj = new MXMLGrid();
				break;
				
				case "HBox":
					obj = new MXMLHBox();
				break;
				
				case "HDividedBox":
					obj = new MXMLHDividedBox();
				break;
				
				case "HRule":
					obj = new MXMLHRule();
				break;
				
				case "Panel":
					obj = new MXMLPanel();
				break;
				
				case "Spacer":
					obj = new MXMLSpacer();
				break;				
				
				case "Tile":
					obj = new MXMLTile();
				break;				
				
				case "TitleWindow":
					obj = new MXMLTitleWindow();
				break;
				
				case "VBox":
					obj = new MXMLVBox();
				break;
				
				case "VDividedBox":
					obj = new MXMLVDividedBox();
				break;
				
				case "VRule":
					obj = new MXMLVRule();
				break;
				
				//========================
				
				case "Accordion":
					obj = new MXMLAccordion();
				break;
				
				case "ButtonBar":
					obj = new MXMLButtonBar();
				break;
				
				case "LinkBar":
					obj = new MXMLLinkBar();
				break;
				
				case "MenuBar":
					obj = new MXMLMenuBar();
				break;
				
				case "TabBar":
					obj = new MXMLTabBar();
				break;
				
				case "TabNavigator":
					obj = new MXMLTabNavigator();
				break;
				
				case "ToggleButtonBar":
					obj = new MXMLToggleButtonBar();
				break;
				
				case "ViewStack":
					obj = new MXMLViewStack();
				break;
			}
			
			if(obj != null) 
			{
				obj.id = control + "_" + getTimer();
				obj.addEventListener("dragEnter", ce.handleDragEnter);
				obj.addEventListener("dragDrop", ce.handleDragDrop);
				
				StageManager.getInstance().registerObject(obj);
				//log.debug("currentTarget", ce.getCurrentTarget().toString());
				
				var className:String = getQualifiedClassName(ce.getCurrentTarget());
				var type:String;			
				if(className.indexOf("controls") > -1) type = "controls";
				if(className.indexOf("containers") > -1) type = "containers";
				//log.debug("type", type);
				var target:UIComponent = ce.getCurrentTarget() != null && type == "containers" ? UIComponent(ce.getCurrentTarget()) : app.mainStage;
				target.addChild(obj);
				ce.setCurrentTarget(obj);
				
				
				return UIComponent(obj);
			}
			
			return null;
		}
	}
}