package com.takumus.kaitenDisplay
{
	public class GeneratorOptions
	{
		private var _ledLength:int, _ledArrayLengthCM:Number, _centerRadiusCM:Number, _resolution:int, _negative:Boolean, _threshold:uint;
		public function GeneratorOptions(ledLength:int, ledArrayLengthCM:Number, centerRadiusCM:Number, resolution:int, negative:Boolean, threshold:uint)
		{
			setOptions(ledLength, ledArrayLengthCM, centerRadiusCM, resolution, negative, threshold);
		}
		public function setOptions(ledLength:int, ledArrayLengthCM:Number, centerRadiusCM:Number, resolution:int, negative:Boolean, threshold:uint):void
		{
			_ledLength = ledLength;
			_ledArrayLengthCM = ledArrayLengthCM;
			_centerRadiusCM = centerRadiusCM;
			_resolution = resolution;
			_negative = negative;
			_threshold = threshold;
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
		public function get negative():Boolean
		{
			return _negative;
		}
		public function get threshold():uint
		{
			return _threshold;
		}
	}
}