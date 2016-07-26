package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class Client extends EventDispatcher{
		private var _socket:Socket;
		private var _buffer:ByteArray;
		private var _began:Boolean;
		public var id:int;
		private var _bytesTotal:int;
		private static var _id:int = 0;
		private var _data:ByteArray;
		public function Client(socket:Socket){
			id = _id;
			_id ++;
			this._socket = socket;
			_buffer = new ByteArray();
			socket.addEventListener(ProgressEvent.SOCKET_DATA, progress);
		}
		private function progress(event:ProgressEvent):void
		{
			if(!_began){
				_bytesTotal = _socket.readInt();
				if(_bytesTotal <= 0) return;
				_began = true;
				//trace("total:" + _bytesTotal);
			}
			var tmp:ByteArray = new ByteArray();
			_socket.readBytes(tmp);
			_buffer.writeBytes(tmp);
			//trace("progress:" + _buffer.length + "/" + _bytesTotal);
			var e:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			e.bytesTotal = _bytesTotal;
			e.bytesLoaded = _buffer.length;
			dispatchEvent(e);
			if(_bytesTotal == _buffer.length){
				complete();
			}
		}
		private function complete():void
		{
			//trace("complete");
			_data = new ByteArray();
			_began = false;
			_buffer.position = 0;
			_data.writeBytes(_buffer);
			_data.position = 0;
			_buffer.clear();
			var e:Event = new Event(Event.COMPLETE);
			dispatchEvent(e);
		}
		public function get data():ByteArray
		{
			return _data;
		}
	}
}