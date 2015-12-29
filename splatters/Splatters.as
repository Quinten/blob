package  {

	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.SharedObject;


	public class Splatters extends MovieClip {

		private var rtmpGo:String = "rtmp://localhost/ConnectToSharedObject";
		private var nc:NetConnection;
		private var so:SharedObject;
		private var good:Boolean;
		private var soName = "splatters";

		private var nSplatters:int = 200;
		private var charList:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		private var splatterArr:Array = new Array();

		public function Splatters() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			noConnectionMC.x = stage.stageWidth/2;
			noConnectionMC.y = stage.stageHeight/2;
			clickAreaMC.width = stage.stageWidth;
			clickAreaMC.height = stage.stageHeight;
			for(var s:int = 0; s < nSplatters; s++){
				splatterArr[s] = new splatterBox();
				splatterArr[s].name = "s_" + s;
				artboardMC.addChild(splatterArr[s]);
			}
			nc = new NetConnection();
			nc.connect (rtmpGo);
			nc.addEventListener(NetStatusEvent.NET_STATUS, doSO);
			this.root.loaderInfo.addEventListener(Event.UNLOAD, deInit);
		}

		private function doSO (e:NetStatusEvent):void
		{
			good = e.info.code == "NetConnection.Connect.Success";
			if(good){
				//Set up shared object
				so = SharedObject.getRemote(soName, nc.uri, true);
				so.connect(nc);
				so.addEventListener(SyncEvent.SYNC, checkSO);
				trace("connected");
				this.removeChild(noConnectionMC);
				clickAreaMC.addEventListener(MouseEvent.CLICK, doSplash);
			}else{
				trace("no connection");
				trace(e.info.code);
			}
		}

		private function checkSO(e:SyncEvent):void
		{
			for (var chng:uint; chng<e.changeList.length; chng++)
			//for (var chng:uint = (e.changeList.length - 1); chng >= 0; chng--)
			{
				switch (e.changeList[chng].code)
				{
					case "clear":
						//...
						break;
					case "success":
						//...
						break;
					case "change" :
						var targetName:String = e.changeList[chng].name;
						//this[targetName].x = so.data[targetName].x;
						var targetMC:MovieClip = artboardMC.getChildAt(0) as MovieClip;
						//trace(targetMC.name);
						targetMC.textbox.text = so.data[targetName].text;
						targetMC.textbox.textColor = so.data[targetName].textColor;
						targetMC.x = so.data[targetName].x;
						targetMC.y = so.data[targetName].y;
						targetMC.rotation = so.data[targetName].rotation;
						artboardMC.addChild(targetMC);
						break;
				}
			}
		}

		public function doSplash(e:MouseEvent):void
		{
			trace("splets");
			var targetMC:MovieClip = artboardMC.getChildAt(0) as MovieClip;
			trace(targetMC.name);
			targetMC.textbox.text = charList.substr(Math.floor(Math.random()*52), 1);
			targetMC.textbox.textColor = int(tintColour(0x66cc00, (0.3 + Math.random()*0.7)));
			targetMC.x = artboardMC.mouseX;
			targetMC.y = artboardMC.mouseY;
			targetMC.rotation = Math.floor(Math.random()*360);
			artboardMC.addChild(targetMC);
			var entObj = new Object();
			entObj.x = targetMC.x;
			entObj.y = targetMC.y;
			entObj.text = targetMC.textbox.text;
			entObj.textColor = targetMC.textbox.textColor;
			entObj.rotation = targetMC.rotation;
			so.setProperty(targetMC.name, entObj);
		}

		public function tintColour(colour:Number, tint:Number):Number
		{
			// c nutrox
			var r:Number = ( colour & 0xFF0000 ) >> 16;
			var g:Number = ( colour & 0x00FF00 ) >> 8;
			var b:Number = ( colour & 0x0000FF );
			tint = 1 - tint;
			r = Math.round( r + ( ( 255 - r ) * tint ) );
			g = Math.round( g + ( ( 255 - g ) * tint ) );
			b = Math.round( b + ( ( 255 - b ) * tint ) );
			return ( r << 16 ) | ( g << 8 ) | b;
		}

		public function deInit(e:Event){
			// remove listeners
			//...
			clickAreaMC.removeEventListener(MouseEvent.CLICK, doSplash);
			if(so != null)
				so.addEventListener(SyncEvent.SYNC, checkSO);
			if(nc != null){
				nc.close();
				nc.removeEventListener(NetStatusEvent.NET_STATUS, doSO);
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.root.loaderInfo.removeEventListener(Event.UNLOAD, deInit);
		}
	}
}
