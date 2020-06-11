package cake.engine;

class Transform extends Component {
	// /** The local position of the transform. **/
	// public var localPosition:Vector3 = Vector3.zero();
	// /** The local rotation of the transform. **/
	// public var localRotation:Vector3 = Vector3.zero();
	// /** The local scale of the Transform. **/
	// public var localScale:Vector3 = Vector3.one();
	// // /** The world position of the transform. **/
	// // public var position(get, null):Vector3;
	// // /** The world rotation of the transform. **/
	// // public var rotation(get, null):Vector3;
	// // /** The world scale of the transform. **/
	// // public var scale(get, null):Vector3;
	// /** The world right direction of the transform. **/
	// public var localRight(get, null):Vector3;
	// /** The world up direction of the transform. **/
	// public var localUp(get, null):Vector3;
	// /** TThe world forward direction of the transform. **/
	// public var localForward(get, null):Vector3;
	// /** The world right direction of the transform. **/
	// public var right(get, null):Vector3;
	// /** The world up direction of the transform. **/
	// public var up(get, null):Vector3;
	// /** The world forward direction of the transform. **/
	// public var forward(get, null):Vector3;
	// private var matrix:Matrix4x4 = new Matrix4x4();
	// // #region getters
	// private inline function get_position():Vector3 {
	// 	var position = localPosition;
	// 	var parent = entity.parent;
	// 	while (parent != null) {
	// 		position += parent.transform.localPosition;
	// 		parent = parent.parent;
	// 	}
	// 	return position;
	// }
	// private inline function get_rotation():Vector3 {
	// 	var rotation = localRotation;
	// 	var parent = entity.parent;
	// 	while (parent != null) {
	// 		rotation += parent.transform.localRotation;
	// 		parent = parent.parent;
	// 	}
	// 	return rotation;
	// }
	// private inline function get_scale():Vector3 {
	// 	var scale = localScale;
	// 	var parent = entity.parent;
	// 	while (parent != null) {
	// 		scale *= parent.transform.localScale;
	// 		parent = parent.parent;
	// 	}
	// 	return scale;
	// }
	// private inline function get_right():Vector3 {
	// 	return rotate(localRotation, 1.0, 0.0, 0.0);
	// }
	// private inline function get_up():Vector3 {
	// 	return rotate(localRotation, 0.0, 1.0, 0.0);
	// }
	// private inline function get_forward():Vector3 {
	// 	return rotate(localRotation, 0.0, 0.0, 1.0);
	// }
	// private inline function get_localRight():Vector3 {
	// 	return rotate(localRotation, 1.0, 0.0, 0.0);
	// }
	// private inline function get_localUp():Vector3 {
	// 	return rotate(localRotation, 0.0, 1.0, 0.0);
	// }
	// private inline function get_localForward():Vector3 {
	// 	return rotate(localRotation, 0.0, 0.0, 1.0);
	// }
	// // #endregion
	// // #region functions
	// private function rotate(rotation:Vector3, x:Float, y:Float, z:Float):Vector3 {
	// 	var rotZ = rotation.z * Math.DEG_2_RAD * 0.5;
	// 	var rotY = rotation.y * Math.DEG_2_RAD * 0.5;
	// 	var rotX = rotation.x * Math.DEG_2_RAD * 0.5;
	// 	var cZ = Math.cos(rotZ);
	// 	var sZ = Math.sin(rotZ);
	// 	var cY = Math.cos(rotY);
	// 	var sY = Math.sin(rotY);
	// 	var cX = Math.cos(rotX);
	// 	var sX = Math.sin(rotX);
	// 	var qX = cZ * cY * sX - sZ * sY * cX;
	// 	var qY = sZ * cY * sX + cZ * sY * cX;
	// 	var qZ = sZ * cY * cX - cZ * sY * sX;
	// 	var qW = cZ * cY * cX + sZ * sY * sX;
	// 	var xx = qX * qX * 2.0;
	// 	var yy = qY * qY * 2.0;
	// 	var zz = qZ * qZ * 2.0;
	// 	var xy = qX * qY * 2.0;
	// 	var xz = qX * qZ * 2.0;
	// 	var yz = qY * qZ * 2.0;
	// 	var wx = qW * qX * 2.0;
	// 	var wy = qW * qY * 2.0;
	// 	var wz = qW * qZ * 2.0;
	// 	return new Vector3((1.0 - (yy + zz)) * x
	// 		+ (xy - wz) * y
	// 		+ (xz + wy) * z, (xy + wz) * x
	// 		+ (1.0 - (xx + zz)) * y
	// 		+ (yz - wx) * z,
	// 		(xz - wy) * x
	// 		+ (yz + wx) * y
	// 		+ (1.0 - (xx + yy)) * z);
	// }
	// private function rebuildMatrix(inverse:Bool):Void {
	// 	@:privateAccess
	// 	if (localPosition.hasChanged || localRotation.hasChanged || localScale.hasChanged) {
	// 		matrix[11] = matrix[9] = matrix[8] = matrix[7] = matrix[6] = matrix[4] = matrix[3] = matrix[2] = matrix[1] = 0.0;
	// 		matrix[15] = matrix[10] = matrix[5] = matrix[0] = 1.0;
	// 		matrix[12] = localPosition.x;
	// 		matrix[13] = localPosition.y;
	// 		matrix[14] = localPosition.z;
	// 		var other = new Matrix4x4();
	// 		var rad, cos, sin;
	// 		if (localRotation.y != 0.0) {
	// 			rad = localRotation.y * Math.DEG_2_RAD;
	// 			cos = Math.cos(rad);
	// 			sin = Math.sin(rad);
	// 			other[10] = other[0] = cos;
	// 			other[14] = other[13] = other[12] = other[11] = other[9] = other[7] = other[6] = other[4] = other[3] = other[1] = 0.0;
	// 			other[2] = -sin;
	// 			other[15] = other[5] = 1.0;
	// 			other[8] = sin;
	// 			matrix *= other;
	// 		}
	// 		if (localRotation.x != 0.0) {
	// 			rad = localRotation.x * Math.DEG_2_RAD;
	// 			cos = Math.cos(rad);
	// 			sin = Math.sin(rad);
	// 			other[14] = other[13] = other[12] = other[11] = other[8] = other[7] = other[4] = other[3] = other[2] = other[1] = 0.0;
	// 			other[15] = other[0] = 1.0;
	// 			other[10] = other[5] = cos;
	// 			other[6] = sin;
	// 			other[9] = -sin;
	// 			matrix *= other;
	// 		}
	// 		if (localRotation.z != 0.0) {
	// 			rad = localRotation.z * Math.DEG_2_RAD;
	// 			cos = Math.cos(rad);
	// 			sin = Math.sin(rad);
	// 			other[5] = other[0] = cos;
	// 			other[1] = sin;
	// 			other[14] = other[13] = other[12] = other[11] = other[9] = other[8] = other[7] = other[6] = other[3] = other[2] = 0.0;
	// 			other[4] = -sin;
	// 			other[15] = other[10] = 1.0;
	// 			matrix *= other;
	// 		}
	// 		if (localScale.x != 1.0 || localScale.y != 1.0 || localScale.z != 1.0) {
	// 			other[0] = localScale.x;
	// 			other[14] = other[13] = other[12] = other[11] = other[9] = other[8] = other[7] = other[6] = other[4] = other[3] = other[2] = other[1] = 0.0;
	// 			other[5] = localScale.y;
	// 			other[10] = localScale.z;
	// 			other[15] = 1.0;
	// 			matrix *= other;
	// 		}
	// 		if (inverse) {
	// 			matrix.inverse();
	// 		}
	// 		localPosition.hasChanged = localRotation.hasChanged = localScale.hasChanged = false;
	// 	}
	// }
	// // #endregion
}
