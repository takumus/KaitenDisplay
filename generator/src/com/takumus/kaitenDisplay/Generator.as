package com.takumus.kaitenDisplay
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class Generator
	{
		private var _centerRadiusRatio:Number;
		private var _ledLength:Number;
		public function Generator()
		{
		}
		public function init(ledLength:int, ledArrayLengthCM:Number, centerRadiusCM:Number):void
		{
			var lengthCM:Number = ledArrayLengthCM + centerRadiusCM;
			_centerRadiusRatio = centerRadiusCM / lengthCM;
			_ledLength = ledLength;
		}
		public function generate(bmd:BitmapData, dataLength:int = 360):String
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
			var endRadius:Number = size / 2;
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
			var data:Array = [];
			for(var rad:Number = 0; rad < radMax; rad += radRate){
				var childData:Array = [];
				data.push(childData);
				for(var ledId:int = 0; ledId < _ledLength; ledId ++){
					var radius:Number = ledId * ledInterval + beginRadius;
					var x:Number = Math.cos(rad)* radius + cx;
					var y:Number = Math.sin(rad)* radius + cy;
					if(bmd.getPixel(x, y) == 0){
						Canvas.sprite.graphics.beginFill(0xff0000);
						Canvas.sprite.graphics.drawCircle(x, y, 1);
						childData.push(1);
						continue;
					}
					childData.push(0);
				}
			}
			Canvas.sprite.cacheAsBitmap = true;
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
}