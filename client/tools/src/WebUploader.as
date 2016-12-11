package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.net.Socket;
	
	public class WebUploader extends Sprite
	{
		private var socket:Socket = new Socket();
		public function WebUploader()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
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
		private function receivedFromClient(dataStr:String):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(10, 0xff0000);
			var data:Object = JSON.parse(dataStr);
			var line:String = data.line;
			var lines:Array = line.split(",");
			for(var i:int = 0; i < lines.length; i ++){
				var l:String = lines[i];
				var p:Point;
				if(l == "b"){
					p = strToPoint(lines[i+1]);
					if(!p) continue;
					this.graphics.moveTo(p.x, p.y);
					i++;
					p = null;
					continue;
				}
				p = strToPoint(lines[i]);
				if(!p) continue;
				this.graphics.lineTo(p.x, p.y);
				p = null;
			}
		}
		private function strToPoint(line:String):Point{
			var tmp:Array = line.split(":");
			if(tmp.length == 1) return null;
			return new Point(Number(tmp[0]), Number(tmp[1]));
		}
	}
}