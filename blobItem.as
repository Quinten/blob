package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public dynamic class blobItem extends MovieClip {
		
		public var _main:MovieClip;
		
		public var projectSwf:String;
		
		public var instructionsStr:String;
		
		public function blobItem(mainInst:MovieClip, imgPath:String, swfPath:String, dialogStr:String) {
			// constructor code
			this._main = mainInst;
			this.projectSwf = swfPath;
			this.instructionsStr = dialogStr;
			//this.addEventListener(Event.ADDED_TO_STAGE, init);
			func.loadIMGExtra(imgPath, contentMC.imgContainerMC, init);
		}
		
		public function init(e:Event = null):void
		{
			func.centerToAnchor(contentMC.imgContainerMC);
			//this
			this.xOrig = this.xHome = this.x;
			this.yOrig = this.yHome = this.y;
			this.xChange = 0;
			this.yChange = 0;
			this.addEventListener(Event.ENTER_FRAME, doSpring);
			//dummyHandleMC
			dummyHandleMC.buttonMode = true;
			dummyHandleMC.addEventListener(MouseEvent.MOUSE_DOWN, startDragDummy);
			var hypoDummy:Number = 110 + Math.floor(Math.random()*50);
			var angleDummy:Number = Math.floor(Math.random()*360) * Math.PI/180;
			dummyHandleMC.xOrig = dummyHandleMC.xHome = Math.cos(angleDummy) * hypoDummy;
			dummyHandleMC.yOrig = dummyHandleMC.yHome = Math.sin(angleDummy) * hypoDummy;
			dummyHandleMC.xChange = 0;
			dummyHandleMC.yChange = 0;
			dummyHandleMC.addEventListener(Event.ENTER_FRAME, doSpring);
			//selfDummyHandleMC
			selfDummyHandleMC.buttonMode = true;
			selfDummyHandleMC.addEventListener(MouseEvent.MOUSE_DOWN, startDragSelfDummy);
			var hypoSelfDummy:Number = 110 + Math.floor(Math.random()*50);
			var angleSelfDummy:Number = angleDummy + ((30 + Math.floor(Math.random()*70)) * Math.PI/180);
			selfDummyHandleMC.xOrig = selfDummyHandleMC.xHome = Math.cos(angleSelfDummy) * hypoSelfDummy;
			selfDummyHandleMC.yOrig = selfDummyHandleMC.yHome = Math.sin(angleSelfDummy) * hypoSelfDummy;
			selfDummyHandleMC.xChange = 0;
			selfDummyHandleMC.yChange = 0;
			selfDummyHandleMC.addEventListener(Event.ENTER_FRAME, doSpring);
			//selfHandleMC
			selfHandleMC.buttonMode = true;
			selfHandleMC.addEventListener(MouseEvent.MOUSE_DOWN, startDragSelf);
			var hypoSelf:Number = 110 + Math.floor(Math.random()*50);
			var angleSelf:Number = angleDummy - ((30 + Math.floor(Math.random()*70)) * Math.PI/180);
			selfHandleMC.xOrig = selfHandleMC.xHome = Math.cos(angleSelf) * hypoSelf;
			selfHandleMC.yOrig = selfHandleMC.yHome = Math.sin(angleSelf) * hypoSelf;
			selfHandleMC.xChange = 0;
			selfHandleMC.yChange = 0;
			selfHandleMC.addEventListener(Event.ENTER_FRAME, doSpring);
			//parentHandleMC
			parentHandleMC.buttonMode = true;
			parentHandleMC.addEventListener(MouseEvent.MOUSE_DOWN, startDragParent);
			var hypoParent:Number = 110 + Math.floor(Math.random()*50);
			var angleParent:Number = angleDummy + ((120 + Math.floor(Math.random()*90)) * Math.PI/180);
			parentHandleMC.xOrig = parentHandleMC.xHome = Math.cos(angleParent) * hypoParent;
			parentHandleMC.yOrig = parentHandleMC.yHome = Math.sin(angleParent) * hypoParent;
			parentHandleMC.xChange = 0;
			parentHandleMC.yChange = 0;
			parentHandleMC.addEventListener(Event.ENTER_FRAME, doSpring);
			//contentMC
			contentMC.sOrig = contentMC.scaleX;
			contentMC.sHome = 1;
			contentMC.sChange = 0;
			contentMC.buttonMode = true;
			contentMC.addEventListener(MouseEvent.CLICK, showProject);
			this.addEventListener(Event.ENTER_FRAME, doGrow);
			this.addEventListener(Event.ENTER_FRAME, redrawLines);
		}
		
		public function startDragDummy(e:MouseEvent):void
		{
			dummyHandleMC.removeEventListener(Event.ENTER_FRAME, doSpring);
			dummyHandleMC.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragDummy);
		}
		
		public function stopDragDummy(e:MouseEvent):void
		{
			dummyHandleMC.stopDrag();
			dummyHandleMC.addEventListener(Event.ENTER_FRAME, doSpring);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragDummy);
		}
		
		public function startDragSelfDummy(e:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, doSpring);
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragSelfDummy);
		}
		
		public function stopDragSelfDummy(e:MouseEvent):void
		{
			this.stopDrag();
			this.addEventListener(Event.ENTER_FRAME, doSpring);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragSelfDummy);
		}
		
		public function startDragSelf(e:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, doSpring);
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragSelf);
		}
		
		public function stopDragSelf(e:MouseEvent):void
		{
			this.stopDrag();
			this.xOrig = this.xHome = this.x;
			this.yOrig = this.yHome = this.y;
			this.xChange = 0;
			this.yChange = 0;
			this.addEventListener(Event.ENTER_FRAME, doSpring);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragSelf);
		}
		
		public function startDragParent(e:MouseEvent):void
		{
			_main.startDragBlob();
		}
		
		public function doSpring(e:Event):void
		{
			var targetMC:MovieClip = e.currentTarget as MovieClip;
			targetMC.xChange = ((targetMC.xHome - targetMC.x)*0.2) + (targetMC.xChange * 0.9);
			targetMC.x += targetMC.xChange;
			targetMC.yChange = ((targetMC.yHome - targetMC.y)*0.2) + (targetMC.yChange * 0.9);
			targetMC.y += targetMC.yChange;
		}
		
		public function doGrow(e:Event):void
		{
			contentMC.sChange = ((contentMC.sHome - contentMC.scaleX)*0.2) + (contentMC.sChange * 0.9);
			contentMC.scaleX += contentMC.sChange;
			contentMC.scaleY = contentMC.scaleX;
		}
		
		public function redrawLines(e:Event):void
		{
			graphicsMC.graphics.clear();
			graphicsMC.graphics.lineStyle(4, 0x66cc00, 1);
			graphicsMC.graphics.moveTo(0, 0);
			graphicsMC.graphics.lineTo(dummyHandleMC.x, dummyHandleMC.y);
			graphicsMC.graphics.moveTo(0, 0);
			graphicsMC.graphics.lineTo(selfDummyHandleMC.x, selfDummyHandleMC.y);
			graphicsMC.graphics.moveTo(0, 0);
			graphicsMC.graphics.lineTo(selfHandleMC.x, selfHandleMC.y);
			graphicsMC.graphics.moveTo(0, 0);
			graphicsMC.graphics.lineTo(parentHandleMC.x, parentHandleMC.y);
		}
		
		public function contract():void
		{
			this.xHome = 0;
			this.yHome = 0;
			dummyHandleMC.xHome = 0;
			dummyHandleMC.yHome = 0;
			selfDummyHandleMC.xHome = 0;
			selfDummyHandleMC.yHome = 0;
			selfHandleMC.xHome = 0;
			selfHandleMC.yHome = 0;
			parentHandleMC.xHome = 0;
			parentHandleMC.yHome = 0;
			contentMC.sHome = contentMC.sOrig;
		}
		
		public function restoreItem():void
		{
			this.xHome = this.xOrig;
			this.yHome = this.yOrig;
			dummyHandleMC.xHome = dummyHandleMC.xOrig;
			dummyHandleMC.yHome = dummyHandleMC.yOrig;
			selfDummyHandleMC.xHome = selfDummyHandleMC.xOrig;
			selfDummyHandleMC.yHome = selfDummyHandleMC.yOrig;
			selfHandleMC.xHome = selfHandleMC.xOrig;
			selfHandleMC.yHome = selfHandleMC.yOrig;
			parentHandleMC.xHome = parentHandleMC.xOrig;
			parentHandleMC.yHome = parentHandleMC.yOrig;
			contentMC.sHome = 1;
		}
		
		public function showProject(e:MouseEvent):void
		{
			_main.loadProject(projectSwf);
			_main.showDialogBox(instructionsStr);
		}
		
	}
	
}
