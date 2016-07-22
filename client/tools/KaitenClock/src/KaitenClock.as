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
	import com.takumus.kaitenDisplay.UploaderEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.setInterval;
	
	public class KaitenClock extends Sprite
	{
		public const SIZE:Number = 500;
		public const CENTER:Number = SIZE / 2;
		private var _canvas:Sprite;
		public function KaitenClock()
		{
			var opt:GeneratorOptions = new GeneratorOptions(48, 48, 10, 360, false, 150);
			var g:Generator = new Generator();
			var renderer:Renderer = new Renderer();
			var tbmd:BitmapData = new BitmapData(SIZE, SIZE, true, 0x00000000);
			var bitmap:Bitmap = new Bitmap(tbmd);
			var uploader:Uploader = new Uploader("raspberrypi.local", 3001);
			uploader.connect();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.stageWidth = SIZE;
			stage.stageHeight = SIZE;
			_canvas = new Sprite();
			//addChild(_canvas);
			addChild(bitmap);
			
			for(var t:int = 0; t < 12; t ++){
				var tr:Number = (Math.PI*2) * ((t+1)/12) - Math.PI * 0.5;
				var num:ClockNumber = new ClockNumber((t+1) + "");
				var x:Number = Math.cos(tr) * CENTER*0.85 + CENTER;
				var y:Number = Math.sin(tr) * CENTER*0.85 + CENTER;
				num.x = x;
				num.y = y;
				//num.rotation = tr;
				_canvas.addChild(num);
			}
			g.addEventListener(GeneratorEvent.COMPLETE, function(e:GeneratorEvent):void
			{
				renderer.render(e.data, SIZE, SIZE, opt);
				var v:Vector.<Frame> = new Vector.<Frame>();
				v.push(e.data);
				uploader.upload(new Timeline(v, opt, 1));
			});
			renderer.addEventListener(RendererEvent.COMPLETE, function(e:RendererEvent):void
			{
				bitmap.bitmapData = e.data;
			});
			var tick:Function = function():void
			{
				var date:Date = new Date();
				var h:int = date.hours;
				var m:int = date.minutes;
				var s:int = date.seconds;
				_canvas.graphics.clear();
				
				//min
				var mr:Number = (m/60)*Math.PI*2 - Math.PI* 0.5;
				var mx:Number = Math.cos(mr)*CENTER*0.7 + CENTER;
				var my:Number = Math.sin(mr)*CENTER*0.7 + CENTER;
				_canvas.graphics.lineStyle(8);
				_canvas.graphics.moveTo(CENTER, CENTER);
				_canvas.graphics.lineTo(mx, my);
				
				//sec
				var sr:Number = (s/60)*Math.PI*2 - Math.PI* 0.5;
				var sx:Number = Math.cos(sr)*CENTER*0.7 + CENTER;
				var sy:Number = Math.sin(sr)*CENTER*0.7 + CENTER;
				//_canvas.graphics.lineStyle(2);
				//_canvas.graphics.moveTo(CENTER, CENTER);
				//_canvas.graphics.lineTo(sx, sy);
				
				//hou
				var hr:Number = (h*60+m)/(60*12)*Math.PI*2 - Math.PI* 0.5;
				var hx:Number = Math.cos(hr)*CENTER*0.6 + CENTER;
				var hy:Number = Math.sin(hr)*CENTER*0.6 + CENTER;
				_canvas.graphics.lineStyle(16);
				_canvas.graphics.moveTo(CENTER, CENTER);
				_canvas.graphics.lineTo(hx, hy);
				tbmd.fillRect(tbmd.rect, 0x00000000);
				tbmd.draw(_canvas);
				g.generate(tbmd, opt);
			};
			uploader.addEventListener(UploaderEvent.CONNECT, function(e:UploaderEvent):void
			{
				trace(11);
				setInterval(tick, 60000);
				
				tick();
			});
		}
	}
}
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class ClockNumber extends Sprite{
	private var _textFormat:TextFormat;
	private var _text:TextField;
	public function ClockNumber(n:String)
	{
		_textFormat = new TextFormat("Arial", 70, 0, true);
		_text = new TextField();
		_text.defaultTextFormat = _textFormat;
		_text.autoSize = TextFieldAutoSize.LEFT;
		_text.text = n;
		_text.x = -_text.width / 2;
		_text.y = -_text.height / 2;
		this.addChild(_text);
	}
}