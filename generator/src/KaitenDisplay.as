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
	import flash.net.Socket;
	import flash.net.URLRequest;
	
	public class KaitenDisplay extends Sprite
	{
		public function KaitenDisplay()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Canvas.init(this.stage);
			var g:Generator = new Generator();
			g.init(48, 48, 0);
			
			var loader:Loader = new Loader();
			var line:int = 360;
			loader.load(new URLRequest("file:///C:/Users/takumus/Desktop/testimage.png?"+new Date().getTime()));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				stage.stageWidth = loader.width;
				stage.stageHeight = loader.height;
				
				var bmd:BitmapData = new BitmapData(loader.width, loader.height, false, 0xffffff);
				bmd.draw(loader);
				var data:String = g.generate(bmd, line);
				
				var m:Socket = new Socket();
				m.connect("raspberrypi.local", 3001);
				
				trace("connecting");
				m.addEventListener(Event.CONNECT, function(e:Event):void
				{
					var frames:int = 100;
					//開始
					m.writeUTFBytes("begin\n");
					//ライン
					m.writeUTFBytes(line + "\n");
					//フレーム
					m.writeUTFBytes(frames + "\n");
					//フレーム秒
					m.writeUTFBytes((1000000/6)+"\n");
					//データ
					var d:String = "";
					for(var i:int = 0; i < frames; i ++){
						d += data + "\n";
					}
					m.writeUTFBytes(d);
					m.flush();
					trace("send");
				});
			});
		}
	}
}