package  {
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.FullScreenEvent;
	import flash.net.URLLoader;
	import flash.text.TextFieldAutoSize;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	public class Blob extends MovieClip {

		// flashvars
		public var paramObj:Object;
		public var basePath:String = "";
		
		public var blobXML:XML;
		
		public var blobItemArr:Array = new Array();
		
		public var lineShape:Shape = new Shape();
		
		public var initButtonMC:MovieClip;
		
		public var restoreButtonMC:MovieClip;
		
		public var loadedProject:Loader;
		
		public var dialogTO:uint;
		
		public function Blob() {
			// constructor code
			//trace(Math.sqrt(180000));
			//textMC.textbox.text = "Aliquam erat volutpat. Mauris molestie augue in lacus aliquam aliquet. Nullam sodales luctus porttitor. In hac habitasse platea dictumst.";
			// collect flashvars
			paramObj = this.root.loaderInfo.parameters;
			basePath = (paramObj["basePath"]) ? paramObj["basePath"] : basePath;
			this.addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		public function init(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			benchMarkerMC.visible = false;
			escButtonMC.visible = false;
			escButtonMC.buttonMode = true;
			escButtonMC.addEventListener(MouseEvent.CLICK, doEscape);
			dialogBoxMC.xHome = 0;
			dialogBoxMC.yHome = dialogBoxMC.y = stage.stageHeight;
			dialogBoxMC.textbox.autoSize = TextFieldAutoSize.LEFT;
			dialogBoxMC.textbox.wordWrap = true;
			dialogBoxMC.textbox.width = stage.stageWidth;
			dialogBoxMC.dialogBGMC.width = stage.stageWidth;
			dialogBoxMC.addEventListener(Event.ENTER_FRAME, doSlide);
			blobMC.xOrig = blobMC.xHome = blobMC.x;
			blobMC.yOrig = blobMC.yHome = blobMC.y;
			blobMC.addEventListener(Event.ENTER_FRAME, doSlide);
			func.loadXML(basePath + "data.xml", xmlLoaded);
		}
		
		public function xmlLoaded(e:Event):void
		{
			var urlLoader:URLLoader = URLLoader(e.target);
			blobXML = new XML(urlLoader.data);
			//trace(blobXML.toXMLString());
			//blobItemArr[0] = new blobItem(this);
			//blobMC.addChildAt(blobItemArr[0], 0);
			//blobItemArr[1] = new blobItem(this);
			//blobItemArr[1].x = 250;
			//blobMC.addChildAt(blobItemArr[1], 0);
			initButtonMC = new blobButton();
			initButtonMC.x = stage.stageWidth/2;
			initButtonMC.y = stage.stageHeight/2;
			initButtonMC.buttonMode = true;
			initButtonMC.addEventListener(MouseEvent.CLICK, initBlob);
			this.addChild(initButtonMC);
			restoreButtonMC = new blobButton();
			restoreButtonMC.buttonMode = true;
			restoreButtonMC.addEventListener(MouseEvent.CLICK, restoreBlob);
			showDialogBox("Click the circles to enter the blob.");
		}
		
		public function initBlob(e:MouseEvent):void
		{
			if(stage.displayState == StageDisplayState.NORMAL){
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}else{
				stage.displayState = StageDisplayState.NORMAL;
			}
			dialogBoxMC.yHome = dialogBoxMC.y = stage.stageHeight;
			//initButtonMC.visible = false;
			this.removeChild(initButtonMC);
			initButtonMC.removeEventListener(MouseEvent.CLICK, initBlob);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, restoreFromFS);
			benchMarkerMC.visible = true;
			benchMarkerMC.x = stage.stageWidth;
			benchMarkerMC.y = stage.stageHeight;
			escButtonMC.visible = true;
			escButtonMC.x = stage.stageWidth;
			escButtonMC.y = 0;
			dialogBoxMC.textbox.width = stage.stageWidth;
			dialogBoxMC.dialogBGMC.width = stage.stageWidth;
			blobMC.xOrig = blobMC.xHome = stage.stageWidth/2;
			blobMC.yOrig = blobMC.yHome = stage.stageHeight/2;
			var angleBlob:Number = Math.floor(Math.random()*360) * Math.PI/180;
			var xBlob:Number = 0;
			var yBlob:Number = 0;
			for(var b in blobXML.blob)
			{
				//trace(blobXML.blob[b].blobPic);
				blobItemArr[b] = new blobItem(this, basePath + blobXML.blob[b].blobPic, basePath + blobXML.blob[b].blobSwf, blobXML.blob[b].blobText);
				blobItemArr[b].x = xBlob;
				blobItemArr[b].y = yBlob;
				blobMC.addChildAt(blobItemArr[b], 0);
				angleBlob += (30 - Math.floor(Math.random()*60)) * Math.PI/180;
				xBlob += Math.cos(angleBlob) * 250;
				yBlob += Math.sin(angleBlob) * 250;
			}
			blobMC.addChildAt(lineShape, 0);
			this.addEventListener(Event.ENTER_FRAME, drawLineShape);
			showDialogBox("Click and drag the circles to navigate.");
		}
		
		public function startDragBlob(e:MouseEvent = null):void
		{
			blobMC.removeEventListener(Event.ENTER_FRAME, doSlide);
			blobMC.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragBlob);
		}
		
		public function stopDragBlob(e:MouseEvent):void
		{
			blobMC.stopDrag();
			blobMC.xOrig = blobMC.xHome = blobMC.x;
			blobMC.yOrig = blobMC.yHome = blobMC.y;
			blobMC.addEventListener(Event.ENTER_FRAME, doSlide);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragBlob);
		}
		
		public function doSlide(e:Event):void
		{
			var targetMC:MovieClip = e.currentTarget as MovieClip;
			targetMC.x += (targetMC.xHome - targetMC.x)*0.2;
			targetMC.y += (targetMC.yHome - targetMC.y)*0.2;
		}
		
		public function drawLineShape(e:Event):void
		{
			lineShape.graphics.clear();
			lineShape.graphics.lineStyle(4, 0x66cc00, 1);
			lineShape.graphics.moveTo(blobItemArr[0].x, blobItemArr[0].y);
			for(var b:int = 1; b < blobItemArr.length; b++){
				lineShape.graphics.lineTo(blobItemArr[b].x, blobItemArr[b].y);
			}
		}
		
		public function loadProject(swfPath:String):void
		{
			trace(swfPath);
			//projectContainer
			loadedProject = func.grabLoader(swfPath);
			projectContainer.addChild(loadedProject);
			blobMC.addChild(restoreButtonMC);
			for(var b:int = 0; b < blobItemArr.length; b++){
				blobItemArr[b].contract();
			}
			blobMC.xHome = 30;
			blobMC.yHome = 30;
		}
		
		public function restoreBlob(e:MouseEvent):void
		{
			if(loadedProject != null){
				projectContainer.removeChild(loadedProject);
				loadedProject.unloadAndStop();
				loadedProject = null;
			}
			blobMC.removeChild(restoreButtonMC);
			for(var b:int = 0; b < blobItemArr.length; b++){
				blobItemArr[b].restoreItem();
			}
			blobMC.xHome = blobMC.xOrig;
			blobMC.yHome = blobMC.yOrig;
		}
		
		public function restoreFromFS(e:FullScreenEvent):void
		{
			if(!e.fullScreen){
				if(loadedProject != null){
					projectContainer.removeChild(loadedProject);
					loadedProject.unloadAndStop();
					loadedProject = null;
					blobMC.removeChild(restoreButtonMC);
				}
				initButtonMC.addEventListener(MouseEvent.CLICK, restoreFromSS);
				initButtonMC.x = 0;
				initButtonMC.y = 0;
				blobMC.addChild(initButtonMC);
				for(var b:int = 0; b < blobItemArr.length; b++){
					blobItemArr[b].contract();
				}
				blobMC.xHome = stage.stageWidth/2;
				blobMC.yHome = stage.stageHeight/2;
				benchMarkerMC.visible = false;
				escButtonMC.visible = false;
				dialogBoxMC.textbox.width = stage.stageWidth;
				dialogBoxMC.dialogBGMC.width = stage.stageWidth;
				showDialogBox("You escaped the blob. You are always welcome to check out fresh blobs at another time.");
			}
		}
		
		//restoreFromSS
		public function restoreFromSS(e:MouseEvent):void
		{
			if(stage.displayState == StageDisplayState.NORMAL){
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}else{
				stage.displayState = StageDisplayState.NORMAL;
			}
			blobMC.removeChild(initButtonMC);
			for(var b:int = 0; b < blobItemArr.length; b++){
				blobItemArr[b].restoreItem();
			}
			blobMC.xHome = blobMC.xOrig;
			blobMC.yHome = blobMC.yOrig;
			benchMarkerMC.visible = true;
			benchMarkerMC.x = stage.stageWidth;
			benchMarkerMC.y = stage.stageHeight;
			escButtonMC.visible = true;
			escButtonMC.x = stage.stageWidth;
			escButtonMC.y = 0;
			dialogBoxMC.textbox.width = stage.stageWidth;
			dialogBoxMC.dialogBGMC.width = stage.stageWidth;
			dialogBoxMC.yHome = dialogBoxMC.y = stage.stageHeight;
		}
		
		public function doEscape(e:MouseEvent):void
		{
			if(stage.displayState == StageDisplayState.FULL_SCREEN){
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function showDialogBox(textStr:String):void
		{
			dialogBoxMC.yHome = dialogBoxMC.y = stage.stageHeight;
			dialogBoxMC.textbox.text = textStr;
			dialogBoxMC.yHome = stage.stageHeight - (dialogBoxMC.textbox.height + 20);
			dialogBoxMC.dialogBGMC.height = dialogBoxMC.textbox.height + 20;
			clearTimeout(dialogTO);
			dialogTO = setTimeout(hideDialogBox, 12000);
			//stage.addEventListener(MouseEvent.CLICK, hideDialogBox);
		}
		
		public function hideDialogBox(e:MouseEvent = null):void
		{
			dialogBoxMC.yHome = stage.stageHeight;
			//stage.removeEventListener(MouseEvent.CLICK, hideDialogBox);
		}
		
	}
	
}
