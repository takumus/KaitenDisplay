package com.takumus.kaitenDisplay
{
	public class Timeline
	{
		private var _frames:Vector.<Frame>;
		private var _intervalSec:Number;
		private var _generatorOptions:GeneratorOptions
		public function Timeline(frames:Vector.<Frame>, generatorOptions:GeneratorOptions, intervalSec:int = 1)
		{
			_frames = new Vector.<Frame>();
			this.intervalSec = intervalSec;
			this.frames = frames;
			this.generatorOptions = generatorOptions;
		}
		public function set frames(frames:Vector.<Frame>):void
		{
			for(var i:int = 0; i < frames.length; i ++){
				_frames.push(frames[i]);
			}
		}
		public function set intervalSec(intervalSec:int):void
		{
			_intervalSec = intervalSec;
		}
		public function get intervalMicroSec():int
		{
			return 1000000 * _intervalSec;
		}
		public function get intervalSec():int
		{
			return 1000000 * _intervalSec;
		}
		public function get frames():Vector.<Frame>
		{
			return _frames;
		}
		public function get generatorOptions():GeneratorOptions
		{
			return _generatorOptions;
		}
		
		public function set generatorOptions(value:GeneratorOptions):void
		{
			_generatorOptions = value;
		}
		public function toString():String
		{
			var str:String = "";
			for(var i:int = 0; i < _frames.length; i ++){
				str += _frames[i].toString();
			}
			return str;
		}
	}
}