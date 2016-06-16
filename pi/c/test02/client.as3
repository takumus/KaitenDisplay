package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Socket;
	
	public class tcptest extends Sprite
	{
		public function tcptest()
		{
			var m:Socket = new Socket();
			m.connect("raspberrypi.local", 3000);
			m.addEventListener(Event.CONNECT, function(e:Event):void
			{
			});
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void
			{
				var str:String = "0000000000000000";
				var arr:Array = str.split("");
				arr[int((stage.mouseY/stage.stageHeight)*16)] = "1";
				arr = arr.reverse();
				str = arr.join("");
				m.writeUTFBytes(arr.join("")+"\n");
				m.flush();
			});
		}
	}
}