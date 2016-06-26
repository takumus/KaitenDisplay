package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	public class GeneratorWorker extends Sprite
	{
		private var _mainToWorker:MessageChannel;
		private var _workerToMain:MessageChannel;
		public function GeneratorWorker()
		{
			_mainToWorker = Worker.current.getSharedProperty("mainToWorker");
			_workerToMain = Worker.current.getSharedProperty("workerToMain");
			
			_mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, getMessage);
		}
		private function getMessage(event:Event):void
		{
			_workerToMain.send("hi "+_mainToWorker.receive());
		}
	}
}


import flash.display.BitmapData;
import flash.geom.Rectangle;

class _Generator
{
	private var _centerRadiusRatio:Number;
	private var _ledLength:Number;
	public function _Generator()
	{
	}
	public function init(ledLength:int, ledArrayLengthCM:Number, centerRadiusCM:Number):void
	{
		var lengthCM:Number = ledArrayLengthCM + centerRadiusCM;
		_centerRadiusRatio = centerRadiusCM / lengthCM;
		_ledLength = ledLength;
	}
	public function generate(bmd:BitmapData, dataLength:int = 360, blackIsTrue:Boolean = true):String
	{
		//正方形を想定してるのでwidth優先でいく
		var size:int = bmd.width;
		var rect:Rectangle = bmd.rect;
		//中心
		var cx:Number = size / 2;
		var cy:Number = size / 2;
		//角度の刻み
		var radRate:Number = (Math.PI*2)/dataLength;
		var radMax:Number = Math.PI*2;
		//終了半径(ただの半径)
		var endRadius:Number = (size / 2)-1;
		//開始半径
		var beginRadius:Number = endRadius * _centerRadiusRatio;
		//中心を抜いた半径
		var diffRadius:Number = endRadius - beginRadius;
		//LEDの間隔
		var ledInterval:Number = diffRadius / (_ledLength>1?(_ledLength-1):(0));
		trace("LED開始:"+beginRadius);
		trace("LED間隔:"+ledInterval);
		trace("LED個数:"+_ledLength);
		trace("LED長さ:"+(_ledLength-1) * ledInterval);
		//Canvas.sprite.graphics.clear();
		//Canvas.sprite.cacheAsBitmap = false;
		var data:Array = [];
		for(var r:int = 0; r < dataLength; r ++){
			var rad:Number = radRate * r;
			var childData:Array = [];
			data.push(childData);
			for(var ledId:int = 0; ledId < _ledLength; ledId ++){
				var radius:Number = ledId * ledInterval + beginRadius;
				var x:Number = Math.cos(rad)* radius + cx;
				var y:Number = Math.sin(rad)* radius + cy;
				var fill:Boolean = bmd.getPixel(x, y) == 0;
				fill = blackIsTrue?fill:!fill;
				childData.push(fill?1:0);
				
			}
		}
		return convertData(data);
	}
	private function convertData(datas:Array):String
	{
		var str:String = "";
		for(var i:int = 0; i < datas.length; i ++){
			var data:Array = datas[i];
			str += data.join("")+"\n";
		}
		return str;
	}
}