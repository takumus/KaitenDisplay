package
{
	import com.takumus.kaitenDisplay.Frame;
	import com.takumus.kaitenDisplay.Generator;
	import com.takumus.kaitenDisplay.GeneratorEvent;
	import com.takumus.kaitenDisplay.GeneratorOptions;
	import com.takumus.kaitenDisplay.Renderer;
	import com.takumus.kaitenDisplay.RendererEvent;
	import com.takumus.kaitenDisplay.Timeline;
	import com.takumus.kaitenDisplay.Uploader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		private var generator:Generator = new Generator();
		private var opt:GeneratorOptions = new GeneratorOptions(48, 48, 10, 500, false, 150);
		private var renderer:Renderer = new Renderer();
		private var uploader:UploadMaster;
		private var rendererBitmap:Bitmap;
		private var canvas:Sprite;
		public function WebUploader()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			rendererBitmap = new Bitmap();
			canvas = new Sprite();
			this.addChild(rendererBitmap);
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
			renderer.addEventListener(RendererEvent.COMPLETE, function(e:RendererEvent):void
			{
				rendererBitmap.bitmapData = e.data;
			});
			uploader = new UploadMaster("localhost", 18760);
		}
		private function receivedFromClient(dataStr:String):void
		{
			trace(dataStr);
			try{
				canvas.graphics.clear();
				canvas.graphics.lineStyle(20, 0x000000);
				var data:Object = JSON.parse(dataStr);
				var line:String = data.line;
				var lines:Array = line.split(",");
				for(var i:int = 0; i < lines.length; i ++){
					var l:String = lines[i];
					var p:Point;
					if(l == "b"){
						p = strToPoint(lines[i+1]);
						if(!p) continue;
						canvas.graphics.moveTo(p.x, p.y);
						i++;
						p = null;
						continue;
					}
					p = strToPoint(lines[i]);
					if(!p) continue;
					canvas.graphics.lineTo(p.x, p.y);
					p = null;
				}
				var bmd:BitmapData = new BitmapData(data.width, data.height, false, 0xffffff);
				bmd.draw(canvas);
				generator.generate(bmd, opt);
				generator.addEventListener(GeneratorEvent.COMPLETE, upload);
			}catch(e:Error){
				
			}
		}
		private function upload(e:GeneratorEvent):void
		{
			renderer.render(e.data, stage.stageWidth, stage.stageHeight, opt);
			var v:Vector.<Frame> = new Vector.<Frame>();
			v.push(e.data);
			uploader.upload(new Timeline(v, opt, 1));
		}
		private function strToPoint(line:String):Point{
			var tmp:Array = line.split(":");
			if(tmp.length == 1) return null;
			return new Point(Number(tmp[0]), Number(tmp[1]));
		}
	}
}