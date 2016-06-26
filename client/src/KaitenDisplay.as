package
{
	import com.takumus.kaitenDisplay.DisplayOptions;
	import com.takumus.kaitenDisplay.Generator;
	import com.takumus.kaitenDisplay.GeneratorEvent;
	import com.takumus.kaitenDisplay.Serial;
	import com.takumus.kaitenDisplay.SerialEvent;
	
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
	import flash.utils.getTimer;
	
	import renderer.Renderer;
	
	public class KaitenDisplay extends Sprite
	{
		public function KaitenDisplay()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//Canvas.init(this.stage, 0x000000);
			var g:Serial = new Serial();
			
			var loader:Loader = new Loader();
			var line:int = 360;
			var r:Renderer = new Renderer();
			this.addChild(r);
			
			var options:DisplayOptions = new DisplayOptions();
			options.setOptions(48, 48, 10, line);
			
			loader.load(new URLRequest("file:///C:/Users/takumus/Desktop/testimage.png?"+new Date().getTime()));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				stage.stageWidth = loader.width;
				stage.stageHeight = loader.height;
				
				var bmd:BitmapData = new BitmapData(loader.width, loader.height, false, 0xffffff);
				bmd.draw(loader);
				bmd = threshold_filter(bmd);
				for(var i:int= 0; i < 4; i ++){
					g.add(bmd);
				}
				var t:int = getTimer();
				g.addEventListener(SerialEvent.ERROR, function(se:SerialEvent):void
				{
					//trace("error");
				});
				g.addEventListener(SerialEvent.COMPLETE, function(se:SerialEvent):void
				{
					//trace(getTimer() - t);
					var m:Socket = new Socket();
					//m.connect("raspberrypi.local", 3001);
					trace("connecting");
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
						m.writeUTFBytes((1000000*2)+"\n");
						//データ
						m.writeUTFBytes(se.data);
						m.flush();
					});
					r.setData(se.data, g.length, options);
					r.render(0, stage.stageWidth, stage.stageHeight);
				});
				
				g.setOptions(options);
				g.generate();
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