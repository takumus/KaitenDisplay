package com.takumus.kaitenDisplay
{
	public class DisplayOptions
	{
		private var _ledLength:int, _ledArrayLengthCM:Number, _centerRadiusCM:Number, _resolution:int;
		public function DisplayOptions()
		{
		}
		public function setOptions(ledLength:int, ledArrayLengthCM:Number, centerRadiusCM:Number, resolution:int):void
		{
			_ledLength = ledLength;
			_ledArrayLengthCM = ledArrayLengthCM;
			_centerRadiusCM = centerRadiusCM;
			_resolution = resolution;
		}
		public function get ledLength():int
		{
			return _ledLength;
		}
		public function get ledArrayLengthCM():Number
		{
			return _ledArrayLengthCM;
		}
		public function get centerRadiusCM():Number
		{
			return _centerRadiusCM;
		}
		public function get resolution():int
		{
			return _resolution;
		}
	}
}