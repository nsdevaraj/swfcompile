package com.adams.swfbuilder.util
{ 
	
	public class GraphicTools
	{
		private static var _instance:GraphicTools;
		 
		
		public static function getInstance():GraphicTools
		{
			if(_instance == null)
			{
				_instance = new GraphicTools();
				_instance.initialize();
			}
			
			return _instance;
		}
		
		private function initialize():void
		{ 
		}
		public function drawFrame(p_target:Object):void 
		{		
			try
			{    
			    // Draw a simple border around the child components.
			    p_target.graphics.lineStyle(1, 0xcccccc, 1.0);
			    p_target.graphics.drawRect(0, 0, p_target.width, p_target.height);  
			}catch(e:Error)
			{ 
			}finally
			{
				
			}       
		}
	}
}