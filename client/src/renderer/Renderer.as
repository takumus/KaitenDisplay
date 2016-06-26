package renderer
{
	import com.takumus.kaitenDisplay.DisplayOptions;
	
	import flash.display.Sprite;
	
	public class Renderer extends Sprite
	{
		private var _frames:Array;
		private var _centerRadiusRatio:Number;
		public function Renderer()
		{
			super();
			_frames = [];
		}
		public function setData(data:String, frameLength:int, displayOptions:DisplayOptions):void
		{
			var lengthCM:Number = displayOptions.ledArrayLengthCM + displayOptions.centerRadiusCM;
			_centerRadiusRatio = displayOptions.centerRadiusCM / lengthCM;
			
			_frames = [];
			var tmpDatas:Array = data.split("\n");
			for(var frame:int = 0; frame < frameLength; frame ++){
				var tmpFrame:Array = []
				for(var line:int = 0; line < displayOptions.resolution; line ++){
					var tmpLine:Array = tmpDatas[frame * displayOptions.resolution + line].split("").map(function(v:String, index:int, arr:Array):int{
						return Number(v);
					});
					tmpFrame.push(tmpLine);
				}
				_frames.push(tmpFrame);
			}
		}
		public function render(frameId:int, width:Number, height:Number):void
		{
			var frame:Array = _frames[frameId];
			var size:Number = width < height ? width : height;
			var cx:Number = width / 2;
			var cy:Number = height / 2;
			var radius:Number = size / 2;
			var centerRadius:Number = radius * _centerRadiusRatio;
			var ledRadius:Number = radius - centerRadius;
			var resolution:int = 360;
			resolution =  resolution < frame.length ? frame.length : resolution;
			var radianInterval:Number = Math.PI*2/resolution;
			for(var radian:Number = 0; radian < Math.PI*2; radian += radianInterval){
				var id:int = radian / (Math.PI*2) * frame.length;
				var lines:Array = frame[id];
				for(var l:int = 0; l < lines.length; l ++){
					var x:Number = cx + Math.cos(radian) * (centerRadius + ledRadius * (l / lines.length));
					var y:Number = cy + Math.sin(radian) * (centerRadius + ledRadius * (l / lines.length));
					if(lines[l] == 1){
						this.graphics.beginFill(0xff0000);
						this.graphics.drawCircle(x, y, 3);
					}
				}
			}
		}
	}
}