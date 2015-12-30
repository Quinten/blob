package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import hype.framework.display.BitmapCanvas;
	
	public class Pointgravity extends MovieClip{
		
		private var pointArr:Array = new Array();
		private var graphicsMC:MovieClip = new MovieClip();
		private var bmc:BitmapCanvas;
		
		public function Pointgravity() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.root.loaderInfo.addEventListener(Event.UNLOAD, deInit);
			// entry point
			trace("ready");
			bmc = new BitmapCanvas(stage.stageWidth, stage.stageHeight);
			this.addChild(bmc);
			this.addChild(graphicsMC);
			bmc.startCapture(graphicsMC, true);
			for(var i:int = 0; i < 4; i++){
				pointArr[i] = new Object();
				//pointArr[i].x = Math.floor(Math.random() * stage.stageWidth);
				//pointArr[i].y = Math.floor(Math.random() * stage.stageHeight);
				pointArr[i].x = i * 100;
				pointArr[i].y = i * 100;
				//pointArr[i].xSpeed = (3 - (Math.random() * 7)) * 4;
				pointArr[i].xSpeed = 7;
				pointArr[i].ySpeed = 0;
				pointArr[i].gravity = 1;
			}
			this.addEventListener(Event.ENTER_FRAME, animationLoop);
		}
		
		public function animationLoop(e:Event):void
		{
			//...
			graphicsMC.graphics.clear();
			graphicsMC.graphics.lineStyle(1, 0x336699, 1);
			graphicsMC.graphics.beginFill(0xffffff, 1);
			for(var i in pointArr){
				pointArr[i].x += pointArr[i].xSpeed;
				pointArr[i].ySpeed += pointArr[i].gravity;
				pointArr[i].y += pointArr[i].ySpeed;
				if(pointArr[i].x < 0){
					pointArr[i].x = 0;
					pointArr[i].xSpeed *= -1;
				}
				if(pointArr[i].x > stage.stageWidth){
					pointArr[i].x = stage.stageWidth;
					pointArr[i].xSpeed *= -1;
				}
/*				if(pointArr[i].y < 0){
					pointArr[i].y = 0;
					pointArr[i].ySpeed *= -1;
				}*/
				if(pointArr[i].y > stage.stageHeight){
					pointArr[i].y = stage.stageHeight;
					pointArr[i].ySpeed *= -1;
				}
				if(i == 0){
					graphicsMC.graphics.moveTo(pointArr[i].x, pointArr[i].y);
				}else{
					graphicsMC.graphics.lineTo(pointArr[i].x, pointArr[i].y);
				}
			}
			graphicsMC.graphics.lineTo(pointArr[0].x, pointArr[0].y);
		}
		
		public function deInit(e:Event){
			// remove listeners
			//...
			this.removeEventListener(Event.ENTER_FRAME, animationLoop);
			this.root.loaderInfo.removeEventListener(Event.UNLOAD, deInit);
		}
		
		

	}
	
}
