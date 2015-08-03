package 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	public class FPSCounter extends Sprite
	{
		private var _framesNum:Number;//帧数
		private var _startTime:Number;//开始时间
		private var _fps:Number;//帧频
		private var _fresh:Number;//刷新速度(秒)
		private var _tf:TextField;
		
		protected var $color:uint = 0;
		public function FPSCounter(fresh:Number=.5,color:uint=0xffff00)
		{
			_fresh = fresh;
			$color = color;
			this.mouseChildren=this.mouseEnabled=false;
			init();
			
		}
		
		private function init():void
		{
			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("Consolas",20,$color);
			_tf.selectable = false;
			addChild(_tf);
			
			}
		public function start():void
		{
			_startTime = getTimer();
			_framesNum = 0;
			this.addEventListener(Event.ENTER_FRAME,checkFPS);
		}
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME,checkFPS);
		}
		private function checkFPS(evt:Event=null):void
		{
			var currentTime:Number = (getTimer() - _startTime) * .001;
			_framesNum++;//加帧频数量
			//如果currentTime大于刷新速度
			if (currentTime > _fresh)
			{
				_fps = Math.floor((_framesNum / currentTime) * 10)/10;
				_framesNum = 0;
				_startTime = getTimer();
				_tf.text = "FPS:" + _fps;
				//this.dispatchEvent(new Event("fps"));
			}
		}
	}
}