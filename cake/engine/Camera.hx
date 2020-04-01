package cake.engine;

import lime.utils.Float32Array;

class Camera extends Component {
	public static var cameras:Array<Camera>;

	public var fieldOfView:Float = 60.0;
	public var zNear:Float = 1.0;
	public var zFar:Float = 10000.0;

	private var hasChanged:Bool = true;
	private var matrix:Matrix4x4 = new Matrix4x4();

	// #region setters

	private inline function set_fieldOfView(value:Float):Float {
		fieldOfView = value;
		hasChanged = true;
		return fieldOfView;
	}

	private inline function set_zNear(value:Float):Float {
		zNear = value;
		hasChanged = true;
		return zNear;
	}

	private inline function set_zFar(value:Float):Float {
		zFar = value;
		hasChanged = true;
		return zFar;
	}

	// #endregion
	// #region functions

	private function render():Void {
		if (hasChanged) {
			rebuildMatrix();
			hasChanged = false;
		}

		@:privateAccess entity.transform.rebuildMatrix(true);
		@:privateAccess var viewProj = matrix * entity.transform.matrix;
		var location = Main.gl.getUniformLocation(Main.shader.program, "u_matrix");
		var temp = new Matrix4x4();
		var f32a = new Float32Array(new Matrix4x4());
		@:privateAccess for (renderer in MeshRenderer.all) {
			renderer.entity.transform.rotation += Time.deltaTime * 5.0;
			renderer.entity.transform.rebuildMatrix(false);
			temp.copy(viewProj);
			temp *= renderer.entity.transform.matrix;
			// for(i in 0...16) {
			// 	f32a[i] = temp[i];
			// }
			Main.gl.uniformMatrix4fv(location, false, new Float32Array(temp));
			Main.gl.drawArrays(Main.gl.TRIANGLES, 0, 96);
		}
	}

	private function rebuildMatrix():Void {
		var f = Math.tan(Math.PI * 0.5 - 0.5 * fieldOfView * Math.DEG_2_RAD);
		var rangeInv = 1.0 / (zNear - zFar);
		matrix[0] = f / (Screen.width / Screen.height);
		matrix[15] = matrix[13] = matrix[12] = matrix[9] = matrix[8] = matrix[7] = matrix[6] = matrix[4] = matrix[3] = matrix[2] = matrix[1] = 0.0;
		matrix[5] = f;
		matrix[10] = (zNear + zFar) * rangeInv;
		matrix[11] = -1.0;
		matrix[14] = zNear * zFar * rangeInv * 2.0;
	}

	public override function onUpdate() {
		var speed = Time.deltaTime * 100.0;
		if (Input.keyHeld(W)) {
			entity.transform.position -= entity.transform.forward * speed;
		}
		if (Input.keyHeld(S)) {
			entity.transform.position += entity.transform.forward * speed;
		}
		if (Input.keyHeld(A)) {
			entity.transform.position -= entity.transform.right * speed;
		}
		if (Input.keyHeld(D)) {
			entity.transform.position += entity.transform.right * speed;
		}
		if (Input.keyHeld(LEFT_SHIFT)) {
			entity.transform.position -= entity.transform.up * speed;
		}
		if (Input.keyHeld(SPACE)) {
			entity.transform.position += entity.transform.up * speed;
		}
		if (Input.keyHeld(MOUSE_0)) {
			entity.transform.rotation -= new Vector3(Input.mouseDelta.y, Input.mouseDelta.x, 0.0) * Time.deltaTime * 10.0;
		}
	}

	// #endregion
}
