package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	public class RendererWorker extends Sprite
	{
		private var _mainToWorker:MessageChannel;
		private var _workerToMain:MessageChannel;
		private var _imageBytes:ByteArray;
		private var _renderer:Renderer;
		public function RendererWorker()
		{
			_mainToWorker = Worker.current.getSharedProperty("mainToWorker");
			_workerToMain = Worker.current.getSharedProperty("workerToMain");
			_imageBytes = Worker.current.getSharedProperty("imageBytes");
			_mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, getMessage);
			
			_renderer = new Renderer();
		}
		private function getMessage(event:Event):void
		{
			var props:Object = _mainToWorker.receive();
			_workerToMain.send({
				data:"",
				status:1
			});
		}
	}
}
import com.takumus.kaitenDisplay.GeneratorOptions;

import flash.display.Sprite;

class Renderer extends Sprite
{
	private var _frames:Array;
	private var _centerRadiusRatio:Number;
	private var _generatorOptions:GeneratorOptions;
	public function Renderer()
	{
		super();
		_frames = [];
	}
	public function setData(data:String, frameLength:int, displayOptions:GeneratorOptions):void
	{
		_generatorOptions = displayOptions;
		var lengthCM:Number = displayOptions.ledArrayLengthCM + displayOptions.centerRadiusCM;
		_centerRadiusRatio = displayOptions.centerRadiusCM / lengthCM;
		
		_frames = [];
		var tmpDatas:Array = data.split("\n");
		for(var frame:int = 0; frame < frameLength; frame ++){
			var tmpFrame:Array = []
			for(var line:int = 0; line < displayOptions.resolution; line ++){
				var tmpLine:Array = tmpDatas[frame * displayOptions.resolution + line].split("").map(function(v:String, index:int, arr:Array):int{
					return Number(v);
				});
				tmpFrame.push(tmpLine);
			}
			_frames.push(tmpFrame);
		}
	}
	public function render(frameStr:String, width:Number, height:Number):void
	{
		this.cacheAsBitmap = false;
		this.graphics.clear();
		var frame:Array = [];
		
		for(var line:int = 0; line < _generatorOptions.resolution; line ++){
			var tmpLine:Array = tmpDatas[frame * displayOptions.resolution + line].split("").map(function(v:String, index:int, arr:Array):int{
				return Number(v);
			});
			tmpFrame.push(tmpLine);
		}
		
		var size:Number = width < height ? width : height;
		var cx:Number = width / 2;
		var cy:Number = height / 2;
		var radius:Number = size / 2;
		var centerRadius:Number = radius * _centerRadiusRatio;
		var ledRadius:Number = radius - centerRadius;
		var resolution:int = 600;
		resolution =  resolution < frame.length ? frame.length : resolution;
		var radianInterval:Number = Math.PI*2/resolution;
		for(var radian:Number = 0; radian < Math.PI*2; radian += radianInterval){
			var id:int = radian / (Math.PI*2) * frame.length;
			var lines:Array = frame[id];
			for(var l:int = 0; l < lines.length; l ++){
				var tmpRadius:Number = (centerRadius + ledRadius * (l / lines.length));
				var tmpRadian:Number = radian// - (Math.PI*2/frame.length/2);
				var x:Number = cx + Math.cos(tmpRadian) * tmpRadius;
				var y:Number = cy + Math.sin(tmpRadian) * tmpRadius;
				var nx:Number = cx + Math.cos(tmpRadian + radianInterval) * tmpRadius;
				var ny:Number = cy + Math.sin(tmpRadian + radianInterval) * tmpRadius;
				if(lines[l] == 1){
					this.graphics.lineStyle(3, 0xff0000);
					this.graphics.moveTo(x, y);
					this.graphics.lineTo(nx, ny);
				}
			}
		}
		this.cacheAsBitmap = true;
	}
}