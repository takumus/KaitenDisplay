package
{
	import com.takumus.kaitenDisplay.KDFile;
	import com.takumus.kaitenDisplay.Timeline;
	import com.takumus.kaitenDisplay.Uploader;
	import com.takumus.kaitenDisplay.UploaderEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.LocalConnection;
	import flash.net.ServerSocket;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	public class UploadMaster extends Sprite
	{
		private var _uploader:Uploader;
		private var _socket:ServerSocket;
		private var _log:TextField;
		private var _kdf:KDFile;
		public function UploadMaster()
		{
			_uploader = new Uploader("raspberrypi.local", 3001);
			_uploader.addEventListener(UploaderEvent.CONNECT, connected);
			//_uploader.connect();
			
			_socket = new ServerSocket();
			_socket.addEventListener(Event.ACTIVATE, trace);
			_socket.addEventListener(ServerSocketConnectEvent.CONNECT, trace);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onProgress);
			_socket.bind(18760);
			_socket.listen();
			_kdf = new KDFile();
			
			_log = new TextField();
			this.addChild(_log);
			this.stage.addEventListener(Event.RESIZE, resize);
			resize(null);
			log("init");
		}
		private function connected(e:UploaderEvent):void
		{
			log("connected");
		}
		private function onProgress(event:ProgressEvent):void
		{
			
		}
		private function onData(sender:String, byteArray:ByteArray):void
		{
			log("data received from " + sender);
			log(byteArray.length + "bytes");
			//var tl:Timeline = _kdf.loadBinary(byteArray);
			//_uploader.upload(tl);
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