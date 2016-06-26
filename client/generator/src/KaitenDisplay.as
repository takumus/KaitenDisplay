package
{
	import com.takumus.kaitenDisplay.Generator;
	
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
			g.init(48, 48, 0);
			
			var loader:Loader = new Loader();
			var line:int = 660;
			loader.load(new URLRequest("file:///C:/Users/takumus/Desktop/testimage.png?"+new Date().getTime()));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				stage.stageWidth = loader.width;
				stage.stageHeight = loader.height;
				
				var bmd:BitmapData = new BitmapData(loader.width, loader.height, false, 0xffffff);
				bmd.draw(loader);
				//var data:String = g.generate(threshold_filter(bmd), line, false);
				
				var m:Socket = new Socket();
				m.connect("raspberrypi.local", 3001);
				
				trace("connecting");
				m.addEventListener(Event.CONNECT, function(e:Event):void
				{
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
					var d:String = "";
					for(var i:int = 0; i < frames; i ++){
						//d += data + "\n";
					}
					m.writeUTFBytes(g.generate(threshold_filter(bmd), line, false)+"\n");
					m.writeUTFBytes(g.generate(threshold_filter(bmd), line, true)+"\n");
					m.flush();
					trace("send");
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