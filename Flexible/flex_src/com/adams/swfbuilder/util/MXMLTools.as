package com.adams.swfbuilder.util
{
	import com.adams.swfbuilder.ControlCreator;
	import com.adams.swfbuilder.ControlEditor;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;

	public class MXMLTools extends EventDispatcher
	{
		private static var _instance:MXMLTools
		public static var RENDER:String = "render";
		public static var LOAD:String = "load";
		
		 
		private var xmlDoc:XML;
		private var loading:Boolean = false;
		private var lastTask:String = MXMLTools.RENDER;
		private var mainStage:Canvas;
		private var lastMXMLExport:String;
		
		public static function getInstance():MXMLTools
		{
			if(_instance == null)
			{
				_instance = new MXMLTools();
				_instance.init();
			}
			return _instance;
		}
		
		public function registerMainStage(p_mainStage:Canvas):void
		{
			mainStage = p_mainStage;
		}
		
		public function getLoading():Boolean
		{
			return loading;
		}
		
		public function setLoading(p_loading:Boolean):void
		{
			 
			loading = p_loading;
		}
		
		public function getLastTask():String
		{
			return lastTask;
		}
		
		public function setLastTask(p_task:String):void
		{
			 
			lastTask = p_task;
		}
		
		private function init():void
		{
			 
		} 
		// IMPORT =======================================
		
		public function loadMXML():void
		{ 
			var request:URLRequest = new URLRequest(File.applicationDirectory.nativePath+File.separator+"mxml"+File.separator+"test.mxml");
            var variables:URLLoader = new URLLoader();
            variables.dataFormat = URLLoaderDataFormat.TEXT;
            variables.addEventListener(Event.COMPLETE, completeHandler);
            try {
                variables.load(request);
            } catch (error:Error) {
                 
            }
		}
		
		private function completeHandler(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
            xmlDoc = XML(loader.data);

            // set to the children of application
            var app:XMLList = xmlDoc.children();
            
            // setloading so that whatever objects that require input, don't ask for it
            setLoading(true);
            
            // start the recursion
            if(app.length()>0) parseMXML(app, mainStage);
            
            // reset the loading flag
            setLoading(false);
            
            // setLastTask so objects that are created/instantiated later than this build process will know what to do
            setLastTask(MXMLTools.LOAD);
		}
		
		public function buildApp(app:XMLList):void
		{
			 // setloading so that whatever objects that require input, don't ask for it
            setLoading(true);
            
            // start the recursion
            if(app.length()>0) parseMXML(app, mainStage);
            
            // reset the loading flag
            setLoading(false);
            
            // setLastTask so objects that are created/instantiated later than this build process will know what to do
            setLastTask(MXMLTools.LOAD);
		}
		
		private function parseMXML(o:XMLList, display:UIComponent):void
		{
			for(var i:int=0;i<o.length();i++)
			{
				var node:XML = XML(o[i]);
				//  create the object on stage
				var childObj:UIComponent = createObject(node, display);
				if(node.children().length()>0) parseMXML(node.children(), childObj);
			}
		}
		
		private function createObject(node:XML, display:UIComponent):UIComponent
		{
			ControlEditor.getInstance().setCurrentTarget(display);
			var obj:UIComponent = ControlCreator.getInstance().createObject(node.localName());
			//log.debug("createObject", obj.toString() + " :: " + display.toString());
			//display.addChild(obj);
			
			try
			{
				// setup properties
				var attributes:XMLList = XMLList(node.@*);
				
				for(var i:int=0;i<attributes.length();i++)
				{
					var variable:String = attributes[i].localName();
					var value:* = attributes[i];
					try
					{ 
						obj["setProperty"](variable, value);
						
					}catch(e:Error)
					{ 
					}finally
					{
						
					}
				}
				
				return obj;
			}catch(e:Error)
			{ 
			}finally
			{
				return obj
			}
		}
		
		// EXPORT =======================================
		
		public function exportMXML(o:Canvas):String
		{
			MXMLCreator.getInstance().resetApplicationString();
			
			var list:Array = o.getChildren();
			var compiledList:Array = [];
			
			if(list.length > 0) 
			{
				compiledList = parseDisplayList(list, compiledList);
			}
			MXMLCreator.getInstance().closeApplicationString();
			lastMXMLExport = MXMLCreator.getInstance().getApplicationString() 
			return lastMXMLExport;
		}
		
		private function parseDisplayList(list:Array, compiledList:Array):Array
		{
			var tabCount:Number = MXMLCreator.getInstance().increaseTabCount();
			var completed:Boolean;
			for(var i:int=0;i<list.length;i++)
			{
				var id:String = list[i].name;
				compiledList.push(id);
				MXMLCreator.getInstance().addOpeningTag(list[i], tabCount);
				
				var children:Array;
				try
				{
					children = list[i].getChildren();
					if(children.length > 0)
					{
						compiledList = parseDisplayList(children,compiledList);
					}
				}catch(e:Error)
				{ 
				}finally
				{
					
				}
				MXMLCreator.getInstance().addClosingTag(list[i], tabCount);
			}
			return compiledList;
		}
	}
}