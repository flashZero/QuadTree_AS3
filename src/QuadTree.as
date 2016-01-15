package quadTree 
{
	import flash.geom.Rectangle;
	import utils.Collision;
	

	public class QuadTree
	{
		protected var _hasChild:Boolean;
		
		protected var NW:QuadTree;
		protected var NE:QuadTree;
		protected var SW:QuadTree;
		protected var SE:QuadTree;
		
		/**
		 *深度 
		 */
		public var depth:int;
		/**
		 *四叉树的根 
		 */
		public var root:QuadTree;
		/**
		 *当前四叉树的父对象 
		 */
		public var parent:QuadTree;
		/**
		 *当前四叉树的名字 
		 */
		public var name:String;
		/**
		 *当前四叉树的node集合 
		 */
		public var node:Vector.<Node> ;
		/**
		 *当前四叉树的范围 
		 */
		public var bounds:Rectangle;
		/**
		 * 四叉树的位置
		 */
		public var index:int;
		/**
		 *四叉树的最大深度 
		 */
		public var maxdepth:int=0;
		/**
		 *四叉树的西北区域 
		 */
		public static const RECT_NW:int=8;
		/**
		 *四叉树的东北区域 
		 */
		public static const RECT_NE:int=4;
		/**
		 * 四叉树的西南区域 
		 */
		public static const RECT_SW:int=2;
		/**
		 * 四叉树的东南区域
		 */
		public static const RECT_SE:int=1;
		/**
		 * 该四叉树自身 
		 */
		public static const RECT_SELF:int=-1;
		public static const RECT_NON_INSERT:int=0;
		/**
		 *四叉树的根 
		 */
		public static const QT_ROOT:int=16;
		public function QuadTree()
		{
			// constructor code
			root = this;
		
			index=QuadTree.QT_ROOT;
		}
		/**
		*NW:3|NE:0
		*SW:2|SE:1
		*
		*/
		public function buildTree(depth:int,bounds:Rectangle):void
		{
			this.maxdepth=depth;
			this.depth = depth;
			this.node = new Vector.<Node>();
			this.bounds = bounds;
			if (depth<=0)
			{
				return;
			}
			_hasChild=true;
			var halfW:Number=bounds.width*.5;
			var halfH:Number=bounds.height*.5;
			//右上
			var bOfNE:Rectangle = new Rectangle(bounds.x + bounds.width*.5,bounds.y,halfW,halfH);
			//右下
			var bOfSE:Rectangle = new Rectangle(bounds.x + bounds.width*.5,bounds.y + bounds.height*.5,halfW,halfH);
			//左下
			var bOfSW:Rectangle = new Rectangle(bounds.x,bounds.y + bounds.height*.5,halfW,halfH);
			//左上
			var bOfNW:Rectangle = new Rectangle(bounds.x,bounds.y,halfW,halfH);

			NE=new QuadTree();
			NW=new QuadTree();
			SW=new QuadTree();
			SE=new QuadTree();
			NE.index=QuadTree.RECT_NE;
			NW.index=QuadTree.RECT_NW;
			SW.index=QuadTree.RECT_SW;
			SE.index=QuadTree.RECT_SE;
			
			NW.root = NE.root = SW.root = SE.root = this.root;
			NW.parent = NE.parent = SW.parent = SE.parent = this;
			
			NW.buildTree(depth-1,bOfNW);
			NE.buildTree(depth-1,bOfNE);
			SW.buildTree(depth-1,bOfSW);
			SE.buildTree(depth-1,bOfSE);
			
			NE.index=QuadTree.RECT_NE;
			SW.index=QuadTree.RECT_SW;
			SE.index=QuadTree.RECT_SE;
			NW.index=QuadTree.RECT_NW;
		}


		/**
		 * 向该四叉树插入一个Node对象
		 * @param n
		 * 
		 */
		public function insert(n:Node):void
		{

			var index:int=getIndex(n);

			switch(index)
			{
				case QuadTree.RECT_NE:
					NE.insert(n);
					break;
				case QuadTree.RECT_NW:
					NW.insert(n);
					break;
				case QuadTree.RECT_SE:
					SE.insert(n);
					break;
				case QuadTree.RECT_SW:
					SW.insert(n);
					break;
				case QuadTree.RECT_SELF:
					n.selfQT=this;
					//this.node.push(n);
						this.node[node.length]=n;
					break;
				default:
					break;
			}
		}

		public function retriveFunc(node:Node):Vector.<Node>
		{
			var qtp:QuadTree=node.selfQT;
			var v:Vector.<Node>=new Vector.<Node>();
			while(qtp){
				for each(var n:Node in qtp.node)
				{
					v[v.length]=n;
				}
				qtp=qtp.parent;
			}
			return v;
		}
		
		public function retriveFunc2(node:Node,v:Vector.<Node>):void
		{
			if(node.selfQT)
				this.retrive(node,v,node.selfQT);
		}
		
		private function retrive(node:Node,v:Vector.<Node>,qt:QuadTree=null):void
		{
			if(Collision.hitTestByPoint(node.x,node.y,node.width,node.height,qt.bounds.x,qt.bounds.y,qt.bounds.width,qt.bounds.height))
			{
				var n:Node;
				for each(n in qt.node)
				{
					if(node!=n)
					{
						v[v.length]=n;
					}
				}
//				n=null;
				if(qt.hasChild())
				{
					retrive(node,v,qt.NE);
					retrive(node,v,qt.NW);
					retrive(node,v,qt.SE);
					retrive(node,v,qt.SW);
				}
			}

		}
		/**
		 *清除该四叉树的Node对象集合
		 * 
		 */
		[inline]
		public function clear():void
		{
			//this.node=new Vector.<Node>();
			
			if(this.hasChild())
			{
				this.NE.clear();
				this.NW.clear();
				this.SE.clear();
				this.SW.clear();
			}
			this.node.length=0
		}
		
		
		/**
		 *删除一个node对象 
		 * @param n
		 * 
		 */
		public function remove(n:Node):void
		{
			var index:int=n.selfQT.node.indexOf(n);
			if(index==-1)throw new Error("ddfdfd");
			n.selfQT.node.splice(index,1);
			//n.selfQT=null;
		}
		
		/**
		 * 根据node对象返回该对象的区域索引 
		 * @param node node对象
		 * @return 对象的区域索引
		 * 
		 */
		public function getIndex(node:Node):int
		{
			var index:int = QuadTree.RECT_SELF;
			if(!_hasChild)
				return index;
			var xMidPoint:Number = bounds.x + bounds.width*.5;
			var yMidPoint:Number = bounds.y + bounds.height*.5;
			
			var topQuadrant:Boolean = node.y < yMidPoint && node.y + node.height < yMidPoint;//Quadrant 象限
			var bottomQuadrant:Boolean = node.y > yMidPoint;
			if(!hasChild())return QuadTree.RECT_SELF;
			if(node.x < xMidPoint && node.x + node.width <xMidPoint)
			{
				if(topQuadrant)index = QuadTree.RECT_NW;
				else if(bottomQuadrant) index = QuadTree.RECT_SW;
			}
			else if(node.x > xMidPoint)
			{
				if(topQuadrant)index = QuadTree.RECT_NE;
				else if(bottomQuadrant) index = QuadTree.RECT_SE;
			}
			
			return index;
		}
		
		/**
		 * 该四叉树是否有child 
		 * @return 
		 * 
		 */
		protected function hasChild():Boolean
		{
//			return NW||NE||SW||SE;
			return _hasChild;
		}
		
	}

}
