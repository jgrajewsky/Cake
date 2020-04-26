package cake.engine;

@:allow(Main)
class RectTransform extends Component {
	public var size:Vector2 = new Vector2(100.0, 200.0);
	public var position:Vector2 = Vector2.zero();
	public var rotation:Float;
	public var scale:Vector2 = Vector2.one();

	private var matrix:Matrix3 = new Matrix3();

	private function rebuildMatrix(other:Matrix3):Matrix3 {
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
