package com.adams.swfbuilder.managers
{
	import mx.core.UIComponent;
	import mx.core.IUIComponent;
	
	public class StageList
	{
		private var objList:Array = [];
		
		function StageList()
		{
			//constructor
		}
		
		public function getList():Array
		{
			return objList;
		}
		
		public function addObj(p_obj:UIComponent):void
		{
			if(checkDuplicate(p_obj)) return;
			
			objList.push(p_obj);
		}
		
		public function removeObj(p_obj:UIComponent):void
		{
			for(var i:Number=0;i<objList.length;i++)
			{
				if(objList[i] == p_obj) 
				{
					objList.splice(i,1);
					break;
				}
			}
		}
		
		private function checkDuplicate(p_obj:UIComponent):Boolean
		{
			for(var i:Number=0;i<objList.length;i++)
			{
				if(objList[i] == p_obj) return true;
			}
			return false;
		}
	}
}