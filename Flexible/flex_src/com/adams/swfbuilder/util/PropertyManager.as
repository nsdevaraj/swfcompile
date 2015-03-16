package com.adams.swfbuilder.util
{ 
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import com.adams.swfbuilder.ControlEditor;
	import com.adams.swfbuilder.util.PropertiesTools;
	import com.adams.swfbuilder.util.MXMLTools;

	public class PropertyManager extends EventDispatcher
	{
		private var target:UIComponent;
		private var propertyList:PropertyList; 
		
		public function PropertyManager(p_target:UIComponent)
		{
			super(null); 
			target = p_target;
			propertyList = new PropertyList();
		}
		
		public function getProperties():Array
		{
			return propertyList.getProperties();
		}
		
		public function setProperty(p_property:String, value:*):void
		{
			try
			{
				// if style, then we need to use setStyle
				if(PropertiesTools.getInstance().isStyle(p_property))
				{
					if(String(value).length == 0)
					{
						// if something blank was passed, we need to clear the style and remove it from the list
						setStyles(p_property, undefined);
						propertyList.removeProperty(p_property);
					}else
					{
						setStyles(p_property, value);
					}
				}else
				{
					target[p_property] = value;
					propertyList.addProperty(p_property);
				}
			}catch(e:Error)
			{
				//logror("Could not set Property");
			}
		}
		
		public function setStyles(p_style:String, value:*):void
		{
			try
			{
				target.setStyle(p_style, value);
				propertyList.addProperty(p_style);
			}catch(e:Error)
			{
				//logror("Could not set Property");
			}
		}
		
		private function initializeStyles(styleList:Array):void
		{
			for(var i:int=0;i<styleList.length;i++)
			{
				target.setStyle(styleList[i].lable, styleList[i].data);
			}
		}
		
		public function initializeProperties(userValues:Object=null):void
		{
			var currentProperties:ArrayCollection = PropertiesTools.getInstance().getProperties(target);	
			
			for(var i:int=0;i<currentProperties.length;i++)
			{
				if(currentProperties[i].styles != null)
				{
					initializeStyles(currentProperties[i].styles);
					continue;
				}
				var label:String = currentProperties[i].label;
				var value:* = currentProperties[i].data;
				var defaultValue:String = PropertiesTools.getInstance().getDefaultProperty(target, label);
				
				// if we're loading from source code, then we need to adhere to the values supplied
				// otherwise, grab default values provided by properties.xml
				if(MXMLTools.getInstance().getLastTask() != MXMLTools.LOAD) 
				{
					try
					{
						var userDefined:* = userValues[label];
						value = defaultValue.length > 0 && userDefined == null ? defaultValue : value;
					}catch(e:Error)
					{
						//logror("cannot resolve userdefined value", e.message);
						value = defaultValue.length > 0 ? defaultValue : value;
					}finally
					{
						
					}
					
				}else
				{
					//log.debug("typeof", typeof(value) + " || " + value);
					switch(typeof(value))
					{
						case "string":
							value = value.length == 0 ? defaultValue : value;
						break;
						
						case "number":
							//log.debug("number: " + label, value + " = " + defaultValue);
							value = !isNaN(value) && defaultValue.length > 0 ? defaultValue : value;
						break;
						
						default:
							value = String(value).length == 0 ? defaultValue : value;						
					}
					
				}
				
				setProperty(label, value);
			}
			
			ControlEditor.getInstance().setCurrentProperties();
		}
	}
}