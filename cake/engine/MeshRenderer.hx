package cake.engine;

class MeshRenderer extends Component {
	private static var all:Array<MeshRenderer> = new Array<MeshRenderer>();

	public override function onCreate():Void {
		all.push(this);
	}

	public override function onDestroy():Void {
		all.remove(this);
	}
}