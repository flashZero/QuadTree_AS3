package utils
{
	import flash.geom.Rectangle;
	import quadTree.Node;

	public class Collision
	{
		public function Collision()
		{
		}
		
		public static function hitTestByPoint(x1:Number,y1:Number,width1:Number,height1:Number,x2:Number,y2:Number,width2:Number,height2:Number):Boolean
		{
			//x1-x2+(width1-width2)*.5
			//y1-y2+(height1-height2)*.5
			if(Math.abs(x1-x2+(width1-width2)*.5)<(width1+width2)*.5
				&&
				Math.abs(y1-y2+(height1-height2)*.5)<(height1+height2)*.5
			)
				return true;
			return false;
		}
		
		public static function hitTestByRentangle(r1:Rectangle,r2:Rectangle):Boolean
		{
			if(hitTestByPoint(r1.x,r1.y,r1.width,r1.height,r2.x,r2.y,r2.width,r2.height))return true
			return false;
		}
		
		public static function hitTestByNode(n1:Node,n2:Node):Boolean
		{
			if(hitTestByPoint(n1.x,n1.y,n1.width,n1.height,n2.x,n2.y,n2.width,n2.height))return true;
			return false;
		}
	}
}
