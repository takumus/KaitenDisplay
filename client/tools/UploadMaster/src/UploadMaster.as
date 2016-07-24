package
{
	import com.takumus.kaitenDisplay.KDFile;
	import com.takumus.kaitenDisplay.Timeline;
	import com.takumus.kaitenDisplay.Uploader;
	import com.takumus.kaitenDisplay.UploaderEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	public class UploadMaster extends Sprite
	{
		private var _uploader:Uploader;
		private var _connection:LocalConnection;
		private var _log:TextField;
		private var _kdf:KDFile;
		public function UploadMaster()
		{
			_uploader = new Uploader("raspberrypi.local", 3001);
			_uploader.addEventListener(UploaderEvent.CONNECT, connected);
			_uploader.connect();
			
			_connection = new LocalConnection();
			_connection.client = {
				onData:onData
			};
			
			_kdf = new KDFile();
			
			_log = new TextField();
			this.addChild(_log);
			this.stage.addEventListener(Event.RESIZE, resize);
			resize(null);
		}
		private function connected(e:UploaderEvent):void
		{
			log("connected");
		}
		private function onData(sender:String, byteArray:ByteArray):void
		{
			log("data received from " + sender);
			var tl:Timeline = _kdf.loadBinary(byteArray);
			_uploader.upload(tl);
		}
		private function resize(e:Event):void
		{
			_log.width = stage.stageWidth;
			_log.height = stage.stageHeight;
		}
		private function log(v:*):void
		{
			_log.text += v+"\n";
			_log.scrollV = _log.maxScrollV;
		}
	}
}