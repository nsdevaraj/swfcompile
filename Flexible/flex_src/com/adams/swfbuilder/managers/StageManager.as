package com.adams.swfbuilder.managers
{
	import flash.events.EventDispatcher; 
	import mx.core.UIComponent;
	import com.adams.swfbuilder.managers.StageList;
	import flash.utils.getQualifiedSuperclassName;
	import com.adams.swfbuilder.*;

	public class StageManager extends EventDispatcher
	{
		private static var _instance:StageManager;
		
		private var stageList:StageList; 
		
		public static function getInstance():StageManager
		{
			if(_instance == null)
			{
				_instance = new StageManager();
				_instance.init();
			}
			return _instance;
		}
		
		private function init():void
		{ 
			stageList = new StageList();
		}
		
		public function registerObject(p_obj:UIComponent):void
		{
			stageList.addObj(p_obj);
		}
		
		public function checkHit(p_obj:UIComponent):UIComponent
		{
			var list:Array = stageList.getList();
			for(var i:Number=0;i<list.length;i++)
			{
				if(p_obj.hitTestObject(list[i]) && p_obj != list[i])
				{
					return list[i];
				}
			}
			return null;
		}
		
		public function moveAsset(p_obj:UIComponent, p_to:UIComponent):void
		{
			try
			{
				p_to.addChild(p_obj);
			}catch(e:Error)
			{
				//log.debug("unable to move container");
			}finally
			{
				
			}
			
		}
		
		public function copyAsset(p_obj:UIComponent):void
		{
			try
			{
				
				var type:String;
				var className:String =  getQualifiedSuperclassName(p_obj).split("::")[1];
				//if(className.indexOf("controls") > -1) type = "controls";
				//if(className.indexOf("containers") > -1) type = "containers";
				//com.adams.swfbuilder.containers::MXMLPanel
				//var classObj:String = className.split("::")[1];
				//var loc:* = com.adams.swfbuilder[type][classObj];
				//log.debug("copyAsset", className);
				
				var copy:UIComponent = ControlCreator.getInstance().createObject(className);
			}catch(e:Error)
			{
				//log.debug("unable to copy container");
			}finally
			{
				
			}
		}
	}
}