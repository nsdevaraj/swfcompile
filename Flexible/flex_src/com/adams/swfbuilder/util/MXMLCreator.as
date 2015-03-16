package com.adams.swfbuilder.util
{
	import flash.events.EventDispatcher; 
	import mx.utils.ObjectUtil;
	import flash.utils.*;
	import mx.core.UIComponent;

	public class MXMLCreator extends EventDispatcher
	{
		private static var _instance:MXMLCreator
		 
		private var tabCount:Number;
		
		private var applicationString:String;
		
		public static function getInstance():MXMLCreator
		{
			if(_instance == null)
			{
				_instance = new MXMLCreator();
				_instance.init();
			}
			return _instance;
		}
		
		private function init():void
		{
			 
		}
		
		public function resetTabCount():void
		{
			tabCount = 0;
		}
		
		public function increaseTabCount():Number
		{
			tabCount++;
			return tabCount;
		}
		
		public function resetApplicationString():void
		{
			applicationString = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<mx:Application xmlns:mx=\"http://www.adobe.com/2006/mxml\" layout=\"absolute\" >\n";
			resetTabCount();
		}
		
		public function closeApplicationString():void
		{
			applicationString += "</mx:Application>";
		}
		
		public function addOpeningTag(obj:*, p_tabCount:Number):void
		{
			applicationString += addTabs(p_tabCount) + "<mx:" + getTagName(obj) 
			applicationString += " " + getDetails(obj);
			applicationString += ">\n";
		}
		
		public function addClosingTag(obj:*, p_tabCount:Number):void
		{
			applicationString += addTabs(p_tabCount)+ "</mx:" + getTagName(obj) + ">\n";
		}
		
		public function getApplicationString():String
		{
			return applicationString;
		}
		
		private function addTabs(p_tabCount:Number):String
		{
			var str:String = "";
			for(var i:int=0;i<p_tabCount;i++) str += "\t";
			return str;
		}
		
		private function getDetails(obj:*):String
		{
			var target:UIComponent = UIComponent(obj);
			var props:Array = target["getProperties"]();
			var str:String = "";
			
			for(var i:int=0;i<props.length;i++)
			{
				var label:String = props[i].label == "name" ? "id" : props[i].label;
				if(PropertiesTools.getInstance().isStyle(label))
				{
					str += label + "=\"" + target.getStyle(String([props[i].label])) + "\" ";
				}else
				{
					var value:* = target[props[i].label]
					if(value != null) 
					{
						if(typeof(value) == "number")
						{
							// if there's no value, then skip this property
							if(isNaN(value)) continue;
						}
					}else
					{
						// if value is null, skip property
						continue;
					}
					str += label + "=\"" + value + "\" ";
				}
			}

			return str;
		}
		
		private function getTagName(obj:*):String
		{
			var objType:String = getQualifiedSuperclassName(obj).split("::")[1];
			return objType
		}
	}
}