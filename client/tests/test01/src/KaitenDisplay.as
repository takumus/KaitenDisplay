package
{
	import com.takumus.kaitenDisplay.GeneratorOptions;
	import com.takumus.kaitenDisplay.Renderer;
	import com.takumus.kaitenDisplay.RendererEvent;
	import com.takumus.kaitenDisplay.SerialGenerator;
	import com.takumus.kaitenDisplay.SerialGeneratorEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	
	public class KaitenDisplay extends Sprite
	{
		public function KaitenDisplay()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//Canvas.init(this.stage, 0x000000);
			var g:SerialGenerator = new SerialGenerator();
			
			var loader:Loader = new Loader();
			var line:int = 360;
			var r:Renderer = new Renderer();
			r.addEventListener(RendererEvent.COMPLETE, function(e:RendererEvent):void
			{
				addChild(new Bitmap(e.data));
			});
			
			var options:GeneratorOptions = new GeneratorOptions(48, 48, 10, line, true);
			
			loader.load(new URLRequest("file:///C:/Users/takumus/Desktop/testimage.png?"+new Date().getTime()));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				stage.stageWidth = loader.width;
				stage.stageHeight = loader.height;
				
				var bmd:BitmapData = new BitmapData(loader.width, loader.height, false, 0xffffff);
				bmd.draw(loader);
				bmd = threshold_filter(bmd);
				for(var i:int= 0; i < 20; i ++){
					g.add(bmd);
				}
				var t:int = getTimer();
				g.addEventListener(SerialGeneratorEvent.ERROR, function(se:SerialGeneratorEvent):void
				{
					trace("error");
				});
				g.addEventListener(SerialGeneratorEvent.COMPLETE, function(se:SerialGeneratorEvent):void
				{
					//trace(getTimer() - t);
					var m:Socket = new Socket();
					//m.connect("raspberrypi.local", 3001);
					//trace("connecting");
					m.addEventListener(Event.CONNECT, function(e:Event):void
					{
						trace("connected");
						var frames:int = g.length;
						//開始
						m.writeUTFBytes("begin\n");
						//ライン
						m.writeUTFBytes(line + "\n");
						//フレーム
						m.writeUTFBytes(frames + "\n");
						//フレーム秒
						m.writeUTFBytes((1000000 * 0.1)+"\n");
						//データ
						m.writeUTFBytes(se.data.toString());
						m.flush();
					});
					r.render(se.data.frames[0], stage.stageWidth, stage.stageHeight, options);
				});				
				g.setOptions(options);
				g.generate();
			});
			this.stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				
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