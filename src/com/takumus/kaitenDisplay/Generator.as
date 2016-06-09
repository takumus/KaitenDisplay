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
		public function generate(bmd:BitmapData, dataLength:int = 360):void
		{
			//正方形を想定してるのでwidth優先でいく
			var bs:int = bmd.width;
			var br:Rectangle = bmd.rect;
			//中心
			var bcx:Number = bs / 2;
			var bcy:Number = bs / 2;
			//角度の刻み
			var radRate:Number = (Math.PI*2)/dataLength;
			var radMax:Number = Math.PI*2;
			//終了半径(ただの半径)
			var endRadius:Number = bs / 2;
			//開始半径
			var beginRadius:Number = endRadius * _centerRadiusRatio;
			//中心を抜いた半径
			var diffRadius:Number = endRadius - beginRadius;
		}
	}
}