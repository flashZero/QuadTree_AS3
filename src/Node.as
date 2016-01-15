package quadTree  {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;

	public class Node {
		
		public var name:String;
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var selfQT:QuadTree;
		
		protected var $speed:Number;
		
		public var x_speed:Number;
		public var y_speed:Number;
		protected var $x_direction:int;
		protected var $y_direction:int;
		
		protected var $minSpeed:Number;
		protected var $maxSpeed:Number;
		
		
		protected var $angle:int;
		public var isCollised:Boolean=false;
		public function Node(x:Number=10,y:Number=10,width:Number=10,height:Number=10,minSpeed:Number=5,maxSpeed:Number=10,angle:int=45) {
			// constructor code
			if (maxSpeed < minSpeed) throw new Error("speed have error");
			
			this.$angle = angle;
			this.$maxSpeed = maxSpeed;
			this.$minSpeed = minSpeed;
			this.x_direction = Math.random() > .5?1: -1;
			this.y_direction = Math.random() > .5?1: -1;
			this.speed = minSpeed + (Math.random() * (maxSpeed - minSpeed) >> 0);
			
			this.x=x;
			this.y=y;
			this.width=width;
			this.height=height;
		}
		
		public function clear():void
		{
			this.isCollised=false;
			this.selfQT=null;
		}
		public function check():Boolean
		{
			var qtRect:Rectangle=selfQT.bounds;
			var nodeRect:Rectangle=new Rectangle(this.x,this.y,this.width,this.height);
			return qtRect.containsRect(nodeRect);
		}
		
		public function set speed(value:Number):void
		{
			if (value > 0)$speed = value;
			else $speed = 0;
			changeXYSpeed($speed);
			
		}
		public function get speed():Number
		{
			return this.$speed;
		}
		
		private function changeXYSpeed(speed:Number):void
		{
			x_speed = (($speed * Math.cos(Math.PI / 180 * $angle))>>0)*this.$x_direction;
			y_speed = (($speed * Math.sin(Math.PI / 180 * $angle))>>0)*this.$y_direction;
		}
		
		public function set x_direction(value:int):void
		{
			$x_direction = value;
			
		}
		
		public function get x_direction():int
		{
			return $x_direction;
		}
		public function set y_direction(value:int):void
		{
			$y_direction = value;
		}
		
		public function get y_direction():int
		{
			return $y_direction;
		}
		
		public function get maxSpeed():Number
		{

			return this.$maxSpeed;
		}
		
		public function get minSpeed():Number
		{

			return this.$minSpeed;
		}
		
		public function set maxSpeed(value:Number):void
		{
			if (value < this.$minSpeed) throw new Error("maxSpeed have error");
			this.$maxSpeed=value;
			this.speed = minSpeed + (Math.random() * (this.$maxSpeed - this.$minSpeed) >> 0);
		}
		
		public function set minSpeed(value:Number):void
		{
			if(value<0||value>this.$maxSpeed)throw new Error("min speed  have error")
			this.$minSpeed=value;
			this.speed = minSpeed + (Math.random() * (this.$maxSpeed - this.$minSpeed) >> 0);
		}
		
		
		public function remove():void
		{
			if(this.selfQT)
			{
				this.selfQT.node.splice(this.selfQT.node.indexOf(this),1);
			}
			clear();
		}
	}
	
}
