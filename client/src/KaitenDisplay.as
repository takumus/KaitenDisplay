package
{
	import com.takumus.kaitenDisplay.Generator;
	import com.takumus.kaitenDisplay.GeneratorEvent;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.Socket;
	import flash.net.URLRequest;
	
	public class KaitenDisplay extends Sprite
	{
		public function KaitenDisplay()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Canvas.init(this.stage, 0x000000);
			var g:Generator = new Generator();
			
			var loader:Loader = new Loader();
			var line:int = 660;
			loader.load(new URLRequest("file:///C:/Users/takumus/Desktop/testimage.png?"+new Date().getTime()));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				stage.stageWidth = loader.width;
				stage.stageHeight = loader.height;
				
				var bmd:BitmapData = new BitmapData(loader.width, loader.height, false, 0xffffff);
				bmd.draw(loader);
				g.generate(threshold_filter(bmd), 48, 48, 20, line, false);
				g.addEventListener(GeneratorEvent.COMPLETE, function(ge:GeneratorEvent):void
				{
					var m:Socket = new Socket();
					m.connect("raspberrypi.local", 3001);
					trace("connecting");
					m.addEventListener(Event.CONNECT, function(e:Event):void
					{
						trace("connected");
						var frames:int = 2;
						//開始
						m.writeUTFBytes("begin\n");
						//ライン
						m.writeUTFBytes(line + "\n");
						//フレーム
						m.writeUTFBytes(frames + "\n");
						//フレーム秒
						m.writeUTFBytes((1000000*2)+"\n");
						//データ
						m.writeUTFBytes(ge.data+"\n");
						m.flush();
					});
				});
			});
		}
		private function threshold_filter(s:BitmapData):BitmapData {
			var d:BitmapData = new BitmapData(s.width, s.height, false, 0xffffff);
			var r:Rectangle = new Rectangle(0, 0, s.width, s.height);
			// 閾値以下を不透明黒にする
			d.threshold(s, r, new Point(0, 0), "<=", 0xCCCCCC, 0x000000, 255, false);
			return d;
		}
	}
}