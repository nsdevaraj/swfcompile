package com.adams.swfbuilder
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import com.adams.swfbuilder.util.GraphicTools;
	import com.adams.swfbuilder.util.PropertiesTools;
	import flash.display.Stage;
	import com.adams.swfbuilder.managers.StageManager;
	import com.adams.swfbuilder.events.ControlCreatorEvent;
	import mx.collections.ArrayCollection;
	import com.adams.swfbuilder.events.ControlEditorEvent;

	public class ControlEditor extends EventDispatcher
	{
		private static var _instance:ControlEditor;
		
		public var currentProperties:Array;
		 
		public var app:Object = mx.core.Application.application;
		
		private var currentTarget:UIComponent;
		private var mainStage:Canvas;
		private var shiftDown:Boolean = false;
		private var ctrlDown:Boolean = false;
		private var stage:Stage;
		
//public methods
		public static function getInstance():ControlEditor
		{
			if(_instance == null)
			{
				_instance = new ControlEditor();
				_instance.initialize();
			}
			
			return _instance;
		}
		
		public function registerMainStage(p_mainStage:Canvas):void
		{
			mainStage = p_mainStage;
		}
		
		public function registerStage(p_stage:Stage):void
		{
			stage = mainStage.stage;
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpEventHandler, false, 10, true ); //
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEventHandler, false, 10, true ); //
		}
		
		public function getCurrentTarget():Object
		{
			return currentTarget;
		}
		
		public function removeCurrentTarget():void
		{
			// we don't want to delete the mainstage ;)
			if(currentTarget == app.mainStage) return;
			if (currentTarget) currentTarget.parent.removeChild(currentTarget);
			setCurrentTarget(mainStage);
		}
		
		public function setCurrentTarget(p_target:UIComponent):void
		{
			//deselectAll();
			currentTarget = p_target;
			if(p_target == null) return;
			if(currentTarget == mainStage) 
			{
				dispatchEvent(new ControlEditorEvent(ControlEditorEvent.CHANGETARGET, new Array()));
			}else
			{
				dispatchEvent(new ControlEditorEvent(ControlEditorEvent.CHANGETARGET, currentTarget["getProperties"]()));
			}
			
		}
		
		public function setCurrentProperties():void
		{
			// dispatches propertys to app to set the Bindable property for the "properties" DataGrid
			try
			{
				currentProperties = currentTarget["getProperties"]();
				
				for(var i:int=0;i<currentProperties.length;i++)
				{
					if(PropertiesTools.getInstance().isStyle(currentProperties[i].label))
					{
						currentProperties[i].data = currentTarget.getStyle(String(currentProperties[i].label));
					}else
					{
						var value:* = currentTarget[currentProperties[i].label];
						if(value != null) 
						{
							if(typeof(value) == "number")
							{
								if(!isNaN(value)) currentProperties[i].data = value;
							}else
							{
								currentProperties[i].data = value;
							}
						}
					}					
				}
				var e:ControlCreatorEvent = new ControlCreatorEvent(ControlCreatorEvent.PROPERTIESCHANGE, new ArrayCollection(currentProperties),false, false);
				dispatchEvent(e);
			}catch(err:Error)
			{
				//log.error("getProperties not defined on target", err.message);
				var ee:ControlCreatorEvent = new ControlCreatorEvent(ControlCreatorEvent.PROPERTIESCHANGE, new ArrayCollection(),false, false);
				dispatchEvent(ee);
			}
		}
		
		// is called by the properties dataGrid when a value is changed
		public function handlePropertiesChange(e:Event):void
		{
			try
			{
				var property:String = e.target.selectedItem.label;
				var value:* = e.target.selectedItem.data;
				updateCurrentTargetProperties(property, value);
				// let the constraintPanel know
				dispatchEvent(new ControlEditorEvent(ControlEditorEvent.CHANGETARGET, currentTarget["getProperties"]()));
			}catch(e:Error)
			{
				//log.error("unable to call setProperty", e.message);
			}
		}
		
		public function handleConstraintsChange(p_property:String, value:*):void
		{
			// update object
			updateCurrentTargetProperties(p_property, value);
			
			// update datagrid
			setCurrentProperties();
		}
		
		//can be called either by a dataGrid update or by the constraintsPanel making a change
		public function updateCurrentTargetProperties(p_property:String, value:*):void
		{
			try
			{
				currentTarget["setProperty"](p_property, value);
			}catch(e:Error)
			{
				//log.error("unable to call setProperty", e.message);
			}
		}
		
		public function deselectAll(...rest):void
		{
			/*
			if(currentTarget)
			{
				dim(currentTarget);
			}
			*/
		}
		
		public function initialize():void
		{
			//log = new Xray//log();
		}
		
		public function handleDrag(e:MouseEvent,target:UIComponent):void
		{
			try
			{
				//var target:UIComponent = UIComponent(e.target);
				var className:String = getQualifiedClassName(target).split("::")[1];
				
				var mx:Number = target.mouseX;
				var my:Number = target.mouseY;
				var move:Boolean = false;
				
				var headerDragSize:Number = target.height < 50 ? 5 : 20;
				
				//if they've clicked on the outter edge, then startdrag, othewise, it's a drag into a possible container
				if((mx > 0 && mx <= 10) || (my > 0 && my <= headerDragSize)
					|| (mx >= target.width-10 && mx <= target.width)
					|| (my >= target.height-10 && my <= target.height)) move = true;
				
				if(!shiftDown && move)
				{
					target.startDrag();	
				}else
				{
					var ds:DragSource = new DragSource();
					DragManager.doDrag(target,ds,e,null, 0,0,0.5,!ctrlDown);
				}
	
				setCurrentTarget(target);
			}catch(e:Error)
			{
				//log.error("unable to handleDrag", e.message);
			}
		}
		
		public function handleDrop(e:MouseEvent):void
		{
			try
			{
				setCurrentProperties();
				e.currentTarget.stopDrag();
				e.currentTarget.invalidateDisplayList();
			}catch(e:Error)
			{
				//log.error("handleDrop error", e.message);
			}
		}
		
		public function handleDragDrop(e:DragEvent):void
		{
			try
			{
				var target:UIComponent = UIComponent(e.dragInitiator);
				setCurrentProperties();
				if(target.parent == e.target) 
				{
					//log.debug("matching parents");
					return;
				}
				var lastParent:UIComponent = UIComponent(target.parent);
				StageManager.getInstance().moveAsset(target, UIComponent(e.target));
				e.target.validateNow();
				lastParent.validateNow();
			}catch(e:Error)
			{
				//log.error("handleDragDrop", e.message);
			}
		}
		
		public function handleDragEnter(e:DragEvent):void
		{
			try
			{
				var target:UIComponent = UIComponent(e.currentTarget);
				var className:String = getQualifiedClassName(target);
				// if we happen to drop on the initiator, it causes a loop error
				if(className.indexOf("containers") == -1 || e.dragInitiator == e.currentTarget)
				{
					DragManager.showFeedback(DragManager.NONE);
				}else
				{
					DragManager.acceptDragDrop(target);
					DragManager.showFeedback(DragManager.MOVE);
				}
			}catch(e:Error)
			{
				//log.debug("handleDragEnter",e.message);
			}
			
		}
		
		private function keyDownEventHandler( event:KeyboardEvent ):void 
		{
			shiftDown = event.shiftKey;
			ctrlDown = event.ctrlKey;
			// delete key
			if(event.keyCode == 46) removeCurrentTarget();
		}
		
		private function keyUpEventHandler( event:KeyboardEvent ):void 
		{
			shiftDown = event.shiftKey;
			ctrlDown = event.ctrlKey;
		}		
		
// Private methods
		
		private function dim(p_target:Object):void
		{
			p_target.graphics.clear();
		}
	}
}