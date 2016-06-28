package com.takumus.kaitenDisplay
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.Socket;

	public class Uploader extends EventDispatcher
	{
		private var _socket:Socket;
		private var _host:String;
		private var _port:int;
		public function Uploader(host:String, port:int)
		{
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT, connected);
			_socket.addEventListener(Event.CLOSE, closed);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioError);
		}
		public function upload(timeline:Timeline):void
		{
			//開始
			_socket.writeUTFBytes("begin\n");
			//ライン
			_socket.writeUTFBytes(timeline.generatorOptions.resolution + "\n");
			//フレーム
			_socket.writeUTFBytes(timeline.frames.length + "\n");
			//フレーム秒
			_socket.writeUTFBytes(timeline.intervalMicroSec + "\n");
			//データ
			_socket.writeUTFBytes(timeline.toString());
			_socket.flush();
		}
		public function connect():void
		{
			_socket.connect(_host, _port);
		}
		
		private function connected(e:Event):void
		{
			
		}
		private function closed(e:Event):void
		{
			
		}
		private function ioError(e:IOErrorEvent):void
		{
			
		}
	}
}