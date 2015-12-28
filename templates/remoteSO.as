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


	public class remoteSO extends MovieClip {

		private var rtmpGo:String = "rtmpt://localhost/ConnectToSharedObject";
		private var nc:NetConnection;
		private var so:SharedObject;
		private var good:Boolean;
		private var soName = "mySO";

		public function remoteSO() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(e:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			nc = new NetConnection();
			nc.connect (rtmpGo);
			nc.addEventListener(NetStatusEvent.NET_STATUS, doSO);
			this.root.loaderInfo.addEventListener(Event.UNLOAD, deInit);
			//...
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
			}else{
				trace("no connection");
				trace(e.info.code);
			}
		}

		private function checkSO(e:SyncEvent):void
		{
			for (var chng:uint; chng<e.changeList.length; chng++)
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
						//var targetName:String = e.changeList[chng].name;
						//this[targetName].x = so.data[targetName].x;
						break;
				}
			}
		}

		public function updateSO(e:MouseEvent = null):void
		{
			//var entObj = new Object();
			//entObj.x = currentLetter.x;
			//entObj.y = currentLetter.y;
			//so.setProperty(currentLetter.name, entObj);
		}

		public function deInit(e:Event){
			// remove listeners
			//...
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
