package cake.engine;

class Raycastable extends Behaviour {
	public var raycastTarget:Bool = true;

	public function onRaycast():Void {}

	public function onPointerEnter():Void {}

	public function onPointerMove():Void {}

	public function onPointerExit():Void {}

	public function onPointerDown():Void {}

	public function onPointerUp():Void {}

	public function onPointerClick():Void {}

	public function onMouseWheel():Void {}

	public function onFocus():Void {}

	public function onBlur():Void {}

	public function onScroll():Void {}

	public function onKeyDown():Void {}

	public function onKeyUp():Void {}

	public function onKeyPress():Void {}

	public function onKeyHold():Void {}

	public function onInput():Void {}

	private function raycast():Bool {
		return false;
	}
}
