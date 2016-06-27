package com.takumus.kaitenDisplay
{
	public class Frame
	{
		private var _data:Array;
		public function Frame(data:Array)
		{
			this._data = data;
		}
		public function get data():Array
		{
			return _data;
		}
		public function toString():String
		{
			var str:String = "";
			for(var i:int = 0; i < _data.length; i ++){
				str += _data[i].join("") + "\n";
			}
			return str;
		}
		public function get length():int
		{
			return _data.length;
		}
	}
}