package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	public class WebUploader extends Sprite
	{
		private var socket:Socket = new Socket();
		public function WebUploader()
		{
			socket.connect("takumus.com", 3001);
			socket.addEventListener(Event.CONNECT, function(e:Event):void
			{
			});
			var data:String = "";
			socket.addEventListener(ProgressEvent.SOCKET_DATA, function(e:ProgressEvent):void
			{
				var tmp:String = socket.readUTFBytes(e.bytesLoaded);
				data += tmp;
				if(tmp.charAt(tmp.length-1) == "\n"){
					receivedFromClient(data);
					data = "";
				}
			});
		}
		private function receivedFromClient(data:String):void
		{
			trace(data);
		}
	}
}