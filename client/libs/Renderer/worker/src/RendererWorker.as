package
{
	import com.takumus.kaitenDisplay.GeneratorOptions;
	
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
			var options:GeneratorOptions = new GeneratorOptions();
			options.setOptions(props.generatorOptions.ledLength, props.generatorOptions.ledArrayLengthCM, props.generatorOptions.centerRadiusCM, props.generatorOptions.resolution, props.generatorOptions.negative);
			var bitmapData:BitmapData = _renderer.render(props.frame, props.width, props.height, options);
			_imageBytes.clear();
			bitmapData.copyPixelsToByteArray(bitmapData.rect, _imageBytes);
			
			_workerToMain.send({
				status:0,
				image:{
					width:props.width,
					height:props.height
				}
			});
		}
	}
}
import com.takumus.kaitenDisplay.GeneratorOptions;

import flash.display.BitmapData;
import flash.display.Sprite;

class Renderer
{
	private var _centerRadiusRatio:Number;
	private var _canvas:Sprite;
	private var _bitmapData:BitmapData;
	public function Renderer()
	{
		super();
		_canvas = new Sprite();
	}
	public function render(frame:Array, width:Number, height:Number, displayOptions:GeneratorOptions):BitmapData
	{
		if(_bitmapData){
			_bitmapData.dispose();
			_bitmapData = null;
		}
		_bitmapData = new BitmapData(width, height, false, 0x000000);
		var lengthCM:Number = displayOptions.ledArrayLengthCM + displayOptions.centerRadiusCM;
		_centerRadiusRatio = displayOptions.centerRadiusCM / lengthCM;
		
		_canvas.graphics.clear();
		var size:Number = width < height ? width : height;
		var cx:Number = width / 2;
		var cy:Number = height / 2;
		var radius:Number = size / 2;
		var centerRadius:Number = radius * _centerRadiusRatio;
		var ledRadius:Number = radius - centerRadius;
		var resolution:int = 600;
		resolution =  resolution < frame.length ? frame.length : resolution;
		var radianInterval:Number = Math.PI*2/resolution;
		var dot:BitmapData = new BitmapData(2, 2, false, 0xff0000);
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
					_canvas.graphics.lineStyle(3, 0xff0000);
					_canvas.graphics.moveTo(x, y);
					_canvas.graphics.lineTo(nx, ny);
				}
			}
		}
		_bitmapData.draw(_canvas);
		_canvas.graphics.clear();
		return _bitmapData;
	}
}