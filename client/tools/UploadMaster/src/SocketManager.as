package
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class SocketManager
	{
		private var _serverSocket:ServerSocket;
		private var _clients:Dictionary;
		
		public function SocketManager()
		{
			_clients = new Dictionary();
			_serverSocket = new ServerSocket();
			_serverSocket.addEventListener(Event.ACTIVATE, trace);
			_serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, connected);
			_serverSocket.bind(18760);
			_serverSocket.listen();
		}
		private function connected(event:ServerSocketConnectEvent):void
		{
			var socket:Socket = event.socket;
			var client:Client = new Client(socket);
			_clients[client.id] = client;
		}
	}
}
import flash.display.BitmapData;
import flash.events.ProgressEvent;
import flash.net.Socket;
import flash.utils.ByteArray;

class Client{
	public var socket:Socket;
	public var buffer:ByteArray;
	public var began:Boolean;
	public var id:int;
	private var _bytesTotal:int;
	private static var _id:int = 0;
	public function Client(socket:Socket){
		id = _id;
		_id ++;
		this.socket = socket;
		buffer = new ByteArray();
		socket.addEventListener(ProgressEvent.SOCKET_DATA, progress);
	}
	private function progress(event:ProgressEvent):void
	{
		if(!began){
			_bytesTotal = socket.readInt();
			if(_bytesTotal <= 0) return;
			began = true;
			trace("total:" + _bytesTotal);
		}
		//var tmp:ByteArray = new ByteArray();
		socket.readBytes(buffer, buffer.length, socket.bytesAvailable);
		//buffer.writeBytes(tmp);
		trace("progress:" + buffer.length + "/" + _bytesTotal);
		if(_bytesTotal == buffer.length){
			complete();
		}
	}
	private function complete():void
	{
		trace("complete");
		began = false;
		buffer.position = 0;
	}
}