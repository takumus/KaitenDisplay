package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.Dictionary;

	public class SocketManager extends EventDispatcher
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
			client.addEventListener(Event.COMPLETE, received);
			client.addEventListener(ProgressEvent.PROGRESS, receiving);
			client.addEventListener(Event.CLOSE, disconnected);
			
			var e:SocketManagerEvent = new SocketManagerEvent(SocketManagerEvent.CONNECTED);
			e.client = (event.target as Client);
			dispatchEvent(e);
		}
		private function received(event:Event):void
		{
			var e:SocketManagerEvent = new SocketManagerEvent(SocketManagerEvent.COMPLETE);
			e.client = (event.target as Client);
			e.data = e.client.data;
			dispatchEvent(e);
		}
		private function receiving(event:ProgressEvent):void
		{
			var e:SocketManagerEvent = new SocketManagerEvent(SocketManagerEvent.PROGRESS);
			e.bytesLoaded = event.bytesLoaded;
			e.bytesTotal = event.bytesTotal;
			e.client = (event.target as Client);
			dispatchEvent(e);
		}
		private function disconnected(event:Event):void
		{
			var e:SocketManagerEvent = new SocketManagerEvent(SocketManagerEvent.DISCONNECTED);
			e.client = (event.target as Client);
			dispatchEvent(e);
		}
	}
}