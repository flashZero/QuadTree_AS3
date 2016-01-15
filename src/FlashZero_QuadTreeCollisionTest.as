package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import quadTree.Node;
	import quadTree.QuadTree;
	import utils.Collision;
	import utils.FPSCounter;

	[SWF(frameRate="60",width="1440",height="900",backgroundColor="0x00ff00")]
	public class FlashZero_QuadTreeCollisionTest extends Sprite
	{
		private var fps:FPSCounter;
		protected var qt:QuadTree;
		protected var _nodeArr:Vector.<Node>=new Vector.<Node>();
		protected var _nodeNum:int;
		private var _flashZeroLogo:TextField;
		private var _info:TextField
		private var _collisedText:TextField;
		private var collisedNum:int=0;
		private var maxCollisedNum:int=0;
		private var _grid:Shape;
		protected var _maxDepth:int;
		protected var stageWidth:Number;
		protected var stageHeight:Number;
		public function FlashZero_QuadTreeCollisionTest()
		{
			// constructor code
			super();
			if(stage)initStageFunc();
			else this.addEventListener(Event.ADDED_TO_STAGE,initStageFunc);
		}
		private function initStageFunc(evt:Event=null):void
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE,initStageFunc);
			stageWidth=stage.stageWidth;
			stageHeight=stage.stageHeight;
				
			dataInit()
			init();
			
			buildUI();
			randerInit();
			keyboardInit();
			randerFunc();
			//runFunc(MouseEvent.CLICK);
			runFunc();
		}
		protected function randerInit():void
		{
			
		}
		
		protected function keyboardInit():void
		{
			stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN,keyDownFunc);
		}
		
		protected function keyDownFunc(evt:KeyboardEvent):void
		{
			switch(evt.keyCode){
				case flash.ui.Keyboard.UP:
				addNode();
				break;
				case Keyboard.DOWN:
				reduceNode();
				break;
				default:
				break;
			}
		}
		
		protected function addNode():void
		{
			for(var i:int=0;i<50;i++)
			{
				createSingleNode();
			}
			_nodeNum+=50;
		}
		protected function reduceNode():void
		{
			if(_nodeNum<=0)return;
			for(var i:int=0;i<50;i++)
			{
				var n:Node=_nodeArr.pop();
				n.remove();
			}
			_nodeNum-=50;
		}
		protected function dataInit():void
		{
			_nodeNum=1000;
			_maxDepth=4;
			var sw:Number = this.stageWidth;
			var sh:Number = this.stageHeight;
			stageRect= new Rectangle(0,0,sw,sh);
		}
		protected function init():void
		{
			//qt=new ActiveQuadTree(new Rectangle(0,0,this.stageWidth,this.stageHeight));
		 	qt=new QuadTree();
			 qt.buildTree(_maxDepth,new Rectangle(0,0,this.stageWidth,this.stageHeight));
			
			 for(var i:int=0;i<_nodeNum;i++)
			{
				 createSingleNode();
			}
			this.mouseChildren=this.mouseEnabled=false;
			
		}
		protected function createSingleNode():void
		{
			var nWidth:Number=randomNumberByRange(10,30)>>0;
			var nHeight:Number=randomNumberByRange(10,30)>>0;
			var nx:Number=randomNumberByRange(0,this.stageWidth-nWidth)>>0;
			var ny:Number=randomNumberByRange(0,this.stageHeight-nHeight)>>0;
			var n:Node=createNewNode(nWidth,nHeight,nx,ny,7,15);
			qt.insert(n);
			_nodeArr[_nodeArr.length]=n;
		}
		protected function createNewNode(width:Number,height:Number,x:Number,y:Number,minSpeed:Number,maxSpeed:Number):Node
		{

			var n:Node=new Node();
			n.x=x;
			n.y=y;
			n.width=width;
			n.height=height;
			n.minSpeed=minSpeed;
			n.maxSpeed=maxSpeed;
			return n;
		}
		protected function runFunc(type:String=Event.MOUSE_LEAVE):void
		{
			switch(type)
			{
				case Event.ENTER_FRAME:
				stage.addEventListener(Event.ENTER_FRAME,randerFunc);
				break;
				case MouseEvent.CLICK:
				stage.addEventListener(MouseEvent.CLICK,randerFunc);
				break;
				case Event.MOUSE_LEAVE:
					stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveFunc);
					stage.addEventListener(Event.MOUSE_LEAVE,onMouseLeaveFunc,false,1);
					break;
				default:

				break;
			}
			
		}
		private function onMouseMoveFunc(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveFunc);
			if(stage.hasEventListener(Event.ENTER_FRAME))return;
			else{
				stage.addEventListener(Event.ENTER_FRAME,randerFunc);
			}
		}
		private function onMouseLeaveFunc(evt:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveFunc);
			stage.removeEventListener(Event.ENTER_FRAME,randerFunc);
//			evt.stopImmediatePropagation();
		}
		protected function buildUI():void
		{
			fps=new FPSCounter();
			addChild(fps);
			fps.start();
			
			drawGrid();
			
			addChild(_grid);
			_flashZeroLogo=new TextField();	
			_flashZeroLogo.defaultTextFormat=new TextFormat("Consolas",20,0x0000ff);
			_flashZeroLogo.text="created by FlashZero";
			_flashZeroLogo.autoSize="left";
			_flashZeroLogo.x=this.stageWidth-_flashZeroLogo.width;
			_flashZeroLogo.y=this.stageHeight-_flashZeroLogo.height;
			addChild(_flashZeroLogo);
			
			_collisedText=new TextField();
			_collisedText.defaultTextFormat=new TextFormat("Consolas",20,0x0000ff);
			_collisedText.text="number of object:"+_nodeNum+"\ncollised times:"+String(collisedNum)+"\nmaxCollised times:"+String(this.maxCollisedNum>collisedNum?maxCollisedNum:collisedNum);
			_collisedText.autoSize="left";
			_collisedText.x=0;
			_collisedText.y=this.stageHeight-_collisedText.height;
			addChild(_collisedText);
			
			_info=new TextField();
			_info.defaultTextFormat=new TextFormat("Consolas",20,0x0000ff);
			_info.text="QuadTree Version Test\nstage size:"+this.stageWidth+"*"+this.stageHeight+"\nfp version:"+flash.system.Capabilities.version;
			_info.autoSize="left";
			_info.x=0;
			_info.y=_collisedText.y-_info.height;
			addChild(_info);
		}
		
		private function drawGrid():void
		{
			this._maxDepth=qt.maxdepth;
			if(!_grid)
			_grid=new Shape();
			_grid.graphics.clear();
			var times:int=(2<<_maxDepth-1);
			var smallWidth:Number=this.stageWidth/times;
			var smallHeight:Number=this.stageHeight/times;
			_grid.graphics.lineStyle(.5,0,.3)

			for(var i:int=0;i<times+1;i++)
			{
				if(i==times/2)_grid.graphics.lineStyle(2,0xff0000,.6)
				else _grid.graphics.lineStyle(.5,0,.3)
				
				_grid.graphics.moveTo(i*smallWidth,0)
				_grid.graphics.lineTo(i*smallWidth,this.stageHeight);
				_grid.graphics.moveTo(0,i*smallHeight)
				_grid.graphics.lineTo(this.stageWidth,i*smallHeight);
			}
		}
		private function randerFunc(evt:Event=null):void
		{
			collisionTest();
			draw();
			displayCollisedResult();
			dataUpdate();
			reInsert();
		}
		
		
		protected function reInsert():void
		{
			qt.clear();
			var n:Node;
			for each(n in _nodeArr)
			{
				n.clear();
				qt.insert(n);
			}
			n=null;
		}
		
		private var stageRect:Rectangle;
		protected function dataUpdate():void
		{
			
			var n:Node
			for each (n in _nodeArr)
			{

				handler(n);
			}
		}
		
		protected function handler(n:Node):void
		{
			
			n.x += n.x_speed;
			n.y += n.y_speed;
			
			if (n.x + n.width >= stageRect.left + stageRect.width || n.x <= stageRect.left)
			{
				n.x_direction *= -1;
				n.speed = n.minSpeed + (Math.random() * (n.maxSpeed - n.minSpeed) >> 0);
				
				if (n.x <= stageRect.left) 
				{
					n.x = stageRect.left;
				}
					//					var tx:Number = n.x + n.width;
					//					var xb:Number = stageRect.left + stageRect.width;
					//					if ( n.x + n.width >= stageRect.left + stageRect.width) n.x = xb - n.width;
				else if(n.x>=stageRect.right - n.width)
				{
					n.x = stageRect.right - n.width;
				}
				
			}
			
			if (n.y + n.height >= stageRect.top + stageRect.height || n.y <= stageRect.top)
			{
				
				n.y_direction *= -1;
				n.speed = n.minSpeed + (Math.random() * (n.maxSpeed - n.minSpeed) >> 0);
				if (n.y <= stageRect.top) n.y = stageRect.top;
					//					var ty:Number = n.y + n.height;
					//					var yb:Number = stageRect.top + stageRect.height;
					//					if (ty >= yb) n.y = yb - n.height;
				else if(n.y>=stageRect.bottom-n.height)n.y=stageRect.bottom-n.height;
			}
		}
		protected var tempV:Vector.<Node>=new Vector.<Node>();
		
		protected function collisionTest():void
		{
			//========================
			tempV.length=0;
			for each(var n:Node in this._nodeArr)
			{	
				collisionNode(n);
				tempV.length=0;
			}
//			v=null;
		}
		
		protected function collisionNode(n:Node):void
		{
			qt.retriveFunc2(n,tempV);
			for each(var n2:Node in tempV)
			{
				
				if(n==n2)continue;
				collisedNum++;
				if(Collision.hitTestByPoint(n.x,n.y,n.width,n.height,n2.x,n2.y,n2.width,n2.height))
				{	
					n.isCollised=n2.isCollised=true;
					//break;
				}
				
			}
		}
		
		private function displayCollisedResult():void
		{
			_collisedText.text="number of object:"+_nodeNum+"\ncollised times:"+String(collisedNum)+"\nmaxCollised times:"+String(this.maxCollisedNum=this.maxCollisedNum>collisedNum?maxCollisedNum:collisedNum);
			collisedNum=0;
		}
		protected function draw():void
		{
			this.graphics.clear();
			//var len:int=_nodeArr.length;
			
			for each (var node:Node in _nodeArr)
			{
				//this.graphics.lineStyle(.1,0x00CCff,1);
					if(node.isCollised)
						this.graphics.beginFill(0xff0000,1);
					else
						this.graphics.beginFill(0x0000FF,1)
					this.graphics.drawRect(node.x,node.y,node.width,node.height);
			}
//			this.graphics.endFill();
		}
		public function randomNumberByRange(v1:Number=0,v2:Number=1):Number
		{
			if(v2<v1)throw new Error("error");
			return v1+Math.random()*(v2-v1);
		}
		
	}
}
