package
{
	import com.takumus.kaitenDisplay.KDFile;
	import com.takumus.kaitenDisplay.Timeline;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class UploadMaster extends EventDispatcher
	{
		private var _socket:Socket;
		private var _kdf:KDFile;
		public function UploadMaster(host:String, port:int)
		{
			_kdf = new KDFile();
			_socket = new Socket(host, port);
			_socket.addEventListener(Event.CONNECT, connected);
		}
		private function connected(event:Event):void
		{
			dispatchEvent(new Event(Event.CONNECT));
		}
		public function upload(timeline:Timeline):void
		{
			trace(timeline.intervalSec)
			var ba:ByteArray = _kdf.generateBinary(timeline);
			ba.position = 0;
			
			_socket.writeInt(ba.length);
			_socket.writeBytes(ba);
			_socket.flush();
		}
	}
}