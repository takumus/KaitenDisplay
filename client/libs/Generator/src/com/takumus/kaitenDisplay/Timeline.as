package com.takumus.kaitenDisplay
{
	public class Timeline
	{
		private var _frames:Vector.<Frame>;
		public function Timeline(frames:Vector.<Frame>)
		{
			_frames = new Vector.<Frame>();
			this.frames = frames;
		}
		public function set frames(frames:Vector.<Frame>):void
		{
			for(var i:int = 0; i < frames.length; i ++){
				_frames.push(frames[i]);
			}
		}
		public function get frames():Vector.<Frame>
		{
			return _frames;
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