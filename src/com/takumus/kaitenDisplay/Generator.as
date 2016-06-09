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
		}
	}
}