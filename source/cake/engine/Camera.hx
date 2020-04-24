package cake.engine;

// import lime.utils.Float32Array;

class Camera extends Component {
	// public static var cameras:Array<Camera>;

	// public var perspective:Bool = true;
	// public var size:Float = 1000.0;
	// public var fieldOfView:Float = 80.0;
	// public var zNear:Float = 1.0;
	// public var zFar:Float = 5000.0;

	// private var matrix:Matrix4x4 = new Matrix4x4();
	// private var floatArray:Float32Array = new Float32Array(new Matrix4x4());
	// // #region functions

	// public override function onUpdate() {
	// 	var speed = Time.deltaTime * 100.0;
	// 	if (Input.keyHeld(W)) {
	// 		entity.transform.localPosition -= entity.transform.forward * speed;
	// 	}
	// 	if (Input.keyHeld(S)) {
	// 		entity.transform.localPosition += entity.transform.forward * speed;
	// 	}
	// 	if (Input.keyHeld(A)) {
	// 		entity.transform.localPosition -= entity.transform.right * speed;
	// 	}
	// 	if (Input.keyHeld(D)) {
	// 		entity.transform.localPosition += entity.transform.right * speed;
	// 	}
	// 	if (Input.keyHeld(LEFT_SHIFT)) {
	// 		entity.transform.localPosition -= entity.transform.up * speed;
	// 	}
	// 	if (Input.keyHeld(SPACE)) {
	// 		entity.transform.localPosition += entity.transform.up * speed;
	// 	}
	// 	if (Input.keyHeld(MOUSE_0)) {
	// 		entity.transform.localRotation.x = Math.fclamp(entity.transform.localRotation.x - Input.mouseDelta.y * 0.05, -90.0, 90.0);
	// 		entity.transform.localRotation.y -= Input.mouseDelta.x * 0.05;
	// 	}
	// }

	// private function render():Void {
	// 	rebuildMatrix();
	// 	@:privateAccess entity.transform.rebuildMatrix(true);
	// 	@:privateAccess matrix *= entity.transform.matrix;
	// 	var location = Main.gl.getUniformLocation(Main.shader.program, "u_matrix");
	// 	var render = new Matrix4x4();
	// 	@:privateAccess
	// 	for (renderer in MeshRenderer.all) {
	// 		renderer.entity.transform.localRotation += Time.deltaTime * 5.0;

	// 		renderer.entity.transform.rebuildMatrix(false);
	// 		render.copy(matrix);
	// 		render *= renderer.entity.transform.matrix;
	// 		floatArray[0] = render[0];
	// 		floatArray[1] = render[1];
	// 		floatArray[2] = render[2];
	// 		floatArray[3] = render[3];
	// 		floatArray[4] = render[4];
	// 		floatArray[5] = render[5];
	// 		floatArray[6] = render[6];
	// 		floatArray[7] = render[7];
	// 		floatArray[8] = render[8];
	// 		floatArray[9] = render[9];
	// 		floatArray[10] = render[10];
	// 		floatArray[11] = render[11];
	// 		floatArray[12] = render[12];
	// 		floatArray[13] = render[13];
	// 		floatArray[14] = render[14];
	// 		floatArray[15] = render[15];
	// 		Main.gl.uniformMatrix4fv(location, false, floatArray);
	// 		var x = renderer.entity.transform.localScale.x >= 0.0,
	// 			y = renderer.entity.transform.localScale.y >= 0.0,
	// 			z = renderer.entity.transform.localScale.z >= 0.0;
	// 		Main.gl.cullFace((x && y && z) || (!x && y && z) || (x && !y && z) || (x && y && !z) ? Main.gl.BACK : Main.gl.FRONT);
	// 		Main.gl.drawArrays(Main.gl.TRIANGLES, 0, 96);
	// 	}
	// }

	// private function rebuildMatrix():Void {
	// 	var ratio = Screen.width / Screen.height;
	// 	if (perspective) {
	// 		var tan = Math.tan(fieldOfView * Math.DEG_2_RAD / 2.0);
	// 		matrix[0] = 1.0 / (ratio * tan);
	// 		matrix[15] = matrix[13] = matrix[12] = matrix[9] = matrix[8] = matrix[7] = matrix[6] = matrix[4] = matrix[3] = matrix[2] = matrix[1] = 0.0;
	// 		matrix[5] = 1.0 / tan;
	// 		matrix[10] = -(zFar + zNear) / (zFar - zNear);
	// 		matrix[11] = -1.0;
	// 		matrix[14] = -(2.0 * zFar * zNear) / (zFar - zNear);
	// 	} else {
	// 		matrix[0] = 1.0 / (size * ratio);
	// 		matrix[13] = matrix[12] = matrix[11] = matrix[9] = matrix[8] = matrix[7] = matrix[6] = matrix[4] = matrix[3] = matrix[2] = matrix[1] = 0.0;
	// 		matrix[5] = 1.0 / size;
	// 		matrix[10] = -2.0 / (zFar - zNear);
	// 		matrix[14] = -(zFar + zNear) / (zFar - zNear);
	// 		matrix[15] = 1.0;
	// 	}
	// }

	// // #endregion
}
