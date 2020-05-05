package cake.engine;

import kha.graphics4.Graphics;
import kha.graphics4.ConstantLocation;

// // canvas
// // clone()
// // remove()
// // previousSibling
// // nextSibling
// // onClick
// // click()
// // onBlur
// // blur()
// // onFocus
// // focus()
@:allow(Canvas)
class CanvasElement extends Component {
	public var tag:String = "";
	public var text:String = "";
	public var children:Array<CanvasElement> = [];

	private static var matrixLocation:ConstantLocation;
	private static var sizeLocation:ConstantLocation;
	private static var colorLocation:ConstantLocation;

	private var size:Vector2 = new Vector2(100.0, 100.0);
	private var position:Vector2 = Vector2.zero();
	private var rotation:Float = 0.0;
	private var scale:Vector2 = Vector2.one();
	private var color:Vector4 = Vector4.one();
	private var matrix:Matrix3 = new Matrix3();

	public override function onCreate() {
		color = new Vector4(Math.random(), Math.random(), Math.random(), 1.0);
		position = new Vector2(Math.random() * (Screen.width - size.x), Math.random() * (Screen.height - size.y));
	}

	/** Returns first query result.  **/
	public function getElement(query:String):CanvasElement {
		return null;
	}

	/**  Returns all query results. **/
	public function getElements(query:String):Array<CanvasElement> {
		return null;
	}

	private inline function render(graphics:Graphics) {
		if (color.w > 0.0) {
			graphics.setVertexBuffer(Mesh.quad.vertexBuffer);
			graphics.setFloat4(colorLocation, color.x, color.y, color.z, color.w);
			graphics.setFloat2(sizeLocation, size.x, size.y);
			graphics.setMatrix3(matrixLocation, rebuildMatrix(new Matrix3()));
			graphics.drawIndexedVertices();
			for (child in children) {
				child.render(graphics);
			}
		}
	}

	private inline function rebuildMatrix(other:Matrix3):Matrix3 {
		matrix._10 = matrix._02 = matrix._01 = matrix._12 = 0.0;
		matrix._00 = 2.0 / Screen.width;
		matrix._11 = -2.0 / Screen.height;
		matrix._20 = -1.0;
		matrix._21 = matrix._22 = 1.0;
		other._01 = other._02 = other._10 = other._12 = 0.0;
		other._00 = other._11 = other._22 = 1.0;
		other._20 = position.x + size.x / 2.0;
		other._21 = position.y + size.y / 2.0;
		matrix *= other;
		if (rotation != 0.0) {
			var rad = rotation * Math.DEG_2_RAD;
			var cos = Math.cos(rad);
			var sin = Math.sin(rad);
			other._20 = other._21 = other._02 = other._12 = 0.0;
			other._00 = other._11 = cos;
			other._10 = -sin;
			other._01 = sin;
			other._22 = 1.0;
			matrix *= other;
		}
		if (scale.x != 1.0 || scale.y != 1.0) {
			other._10 = other._20 = other._01 = other._21 = other._02 = other._12 = 0.0;
			other._00 = scale.x;
			other._11 = scale.y;
			other._22 = 1.0;
			matrix *= other;
		}
		return matrix;
	}
}
