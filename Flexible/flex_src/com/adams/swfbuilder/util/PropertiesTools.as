package com.adams.swfbuilder.util
{ 
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.events.IndexChangedEvent;
	
	public class PropertiesTools
	{
		private static var _instance:PropertiesTools;
		public static var IGNOREPROPERTY:String = "ignoreProperty";
		
		private var properties:XML; 
		private var baseProps:Array;
		private var stylesProps:Array;
		
		public static function getInstance():PropertiesTools
		{
			if(_instance == null)
			{
				_instance = new PropertiesTools();
				_instance.init();
			}
			return _instance;
		}
		
		public function getDefaultProperty(p_obj:UIComponent, p_property:String):String
		{
			var propsList:Array = [];
			var value:String = "";
			try
			{
				var component:String = getQualifiedSuperclassName(p_obj).split("::")[1];
				var className:String = getQualifiedClassName(p_obj);
				var type:String;			
				if(className.indexOf("controls") > -1) type = "controls";
				if(className.indexOf("containers") > -1) type = "containers";
				
				var list:XMLList = properties.child(type).child(component).attributes();
				
				for(var i:int=0;i<list.length();i++)
				{
					var name:String = list[i].localName();
					if(name == p_property) 
					{
						value = list[i];
						break;
					}
				}
			}catch(err:Error)
			{
				//log.error("error in getDefaultProperty");
			}
			
			return value;
		}
		
		public function getProperties(p_obj:UIComponent):ArrayCollection
		{
			var propsList:Array = [];
			try
			{
				var component:String = getQualifiedSuperclassName(p_obj).split("::")[1];
				var className:String = getQualifiedClassName(p_obj);
				var type:String;			
				if(className.indexOf("controls") > -1) type = "controls";
				if(className.indexOf("containers") > -1) type = "containers";
				
				
				var list:XMLList = properties.child(type).child(component).attributes();
				
				propsList = getBaseProperties(p_obj);
				var styleList:Array = getBaseStyles(p_obj);
				propsList.push({styles:styleList});				
				
				//propsList = propsList.concat(styleList);
				
				for(var i:int=0;i<list.length();i++)
				{
					var name:String = list[i].localName();
					var value:*;
	
					try
					{
						if(!isNaN(p_obj[String(name)])) value = p_obj[String(name)];
					}catch(e:Error)
					{
						//log.error("error getting value of UIcomponent");
						value = "";
					}finally
					{
						//
					}
					
					propsList.push({label:name, data:value});
					//log.debug(name,value);
				}
			}catch(err:Error)
			{
				
			}
			
			return new ArrayCollection(propsList);
		}
		
		public function setProperties(p_props:XML):void
		{
			properties = p_props;
		}
		
		public function getAllProperties():XML
		{
			return properties;
		}
		
		public function setAllProperties(p_props:XML):void
		{
			properties = p_props;
			//log.debug("properties", properties.toString());
		}
		
		public function verifyValidObject(obj:UIComponent):Boolean
		{
			var objType:String = getQualifiedSuperclassName(obj).split("::")[1];
			//log.debug("obj", objType);
			var controlsList:XMLList = properties.controls.children();
			var containersList:XMLList = properties.containers.children();

			
			for(var i:int=0;i<controlsList.length();i++)
			{
				if(controlsList[i].localName() == objType) return true;
			}
			
			for(var j:int=0;j<containersList.length();j++)
			{
				if(containersList[j].localName() == objType) return true;
			}

			return false;
		}
		
		public function isStyle(p_prop:String):Boolean
		{
			for(var i:int=0;i<stylesProps.length;i++)
			{
				if(stylesProps[i].label == p_prop) return true;
			}
			return false;
		}
		
		public function loadProperties():void
		{
			
			var request:URLRequest = new URLRequest("configuration/properties.xml");
            var variables:URLLoader = new URLLoader();
            variables.dataFormat = URLLoaderDataFormat.TEXT;
            variables.addEventListener(Event.COMPLETE, completeHandler);
            try {
                variables.load(request);
            } catch (error:Error) {
                //log.error("Unable to load properties", error);
            }
		}
		
		private function completeHandler(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
            setProperties(XML(loader.data));
            setBaseProperties();
            setBaseStyles();
		}
		
		private function getBaseProperties(p_obj:UIComponent):Array
		{
			var ary:Array = [];
			for(var i:int=0;i<baseProps.length;i++)
			{
				//var label:String = baseProps[i].label == "id" ? "name" : baseProps[i].label;
				var label:String = baseProps[i].label;
				try
				{
					baseProps[i].data = p_obj[label];
				}catch(e:Error)
				{
					//baseProps[i].data = "";
				}finally
				{
					
				}
				
				ary.push(baseProps[i]);
			}
			return ary;
		}
		
		private function setBaseProperties():void
		{
			try
			{
				var baseList:XMLList = properties.base.children();
				baseProps = [];
				
				var name:String;
				var type:String;
				var value:*;
				
				for(var i:int=0;i<baseList.length();i++)
				{
					var propList:XMLList = baseList[i].attributes();
					for(var j:int=0;j<propList.length();j++)
					{
						if(propList[j].localName() == "type") continue;
						name = propList[j];
						//type = baseList.attribute("type");
						value = null;
						baseProps.push({label:name, data:value});
						//log.debug(name,value);
					}
				}
			}catch(e:Error)
			{
				//log.error("setBaseProperties", e.message);
			}
		}
		
		private function getBaseStyles(p_obj:UIComponent):Array
		{
			var ary:Array = [];
			for(var i:int=0;i<stylesProps.length;i++)
			{
				//var label:String = baseProps[i].label == "id" ? "name" : baseProps[i].label;
				var label:String = stylesProps[i].label;
				try
				{
					stylesProps[i].data = p_obj.getStyle(label);
				}catch(e:Error)
				{
					stylesProps[i].data = "";
				}finally
				{
					
				}
				
				ary.push(stylesProps[i]);
			}
			return ary;
		}
		
		private function setBaseStyles():void
		{
			try
			{
				var stylesList:XMLList = properties.styles.children();
				stylesProps = [];
				
				var name:String;
				var type:String;
				var value:*;
				
				for(var i:int=0;i<stylesList.length();i++)
				{
					var propList:XMLList = stylesList[i].attributes();
					for(var j:int=0;j<propList.length();j++)
					{
						if(propList[j].localName() == "type") continue;
						name = propList[j];
						//type = baseList.attribute("type");
						value = null;
						stylesProps.push({label:name, data:value});
						//log.debug(name,value);
					}
				}
			}catch(e:Error)
			{
				//log.error("setBaseStyles", e.message);
			}
		}
		
		public function init():void
		{
			//log = new XrayLog();
		}
	}
}