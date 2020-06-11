package cake.engine;

class Behaviour extends Component {
	/** This function is called when the component is attached to an Entity. **/
	public function onAttach():Void {}

	/** This function is called every frame. **/
	public function onUpdate():Void {}

	/** This function is called when the component is detached from an Entity. **/
	public function onDetach():Void {}

	/** This function is called when the component is reseted. **/
	public function onReset():Void {}

	override inline function attach(to:Entity) {
		onAttach();
		super.attach(to);
	}
}
