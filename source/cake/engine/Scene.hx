package cake.engine;

@:allow(Main)
final class Scene {
	public static var currentScene:Scene;

	/** All root level entities in this Scene. (Read Only) **/
	public var entities(default, null):ReadOnlyArray<Entity> = [];

	private function new(data:String) {
		var currentEntity:Entity = null;
		var currentComponent:Component = null;
		var currentText:Null<String> = null;
		var i = 0;
		while (i < data.length) {
			var char = data.charAt(i);
			switch char {
				case "<":
					if (currentText == null) {
						currentText = "";
					}
				case "/":
					if (currentText != null) {
						i += 2;
						currentText = null;
					}
				case ">":
					if (currentText.length != null) {
						switch currentText.charAt(0) {
							case "e":
								var parent = currentEntity;
								@:privateAccess currentEntity = new Entity(currentText.substring(5, currentText.length - 1));
								if (parent == null) {
									@:privateAccess entities.push(currentEntity);
								} else {
									currentEntity.parent = parent;
								}
							case "c":
								if (currentEntity != null) {
									var type = currentText.substring(5, currentText.length - 1);
									// trace(Transform);
									trace(Type.resolveClass("Something"));
									// currentComponent = Type.createInstance(Type.resolveClass(type), []);
								}
							case "f":
								if (currentComponent != null) {
									var name = currentText.substring(5, currentText.length - 1);
									// trace(currentText);
								}
						}
						currentText = null;
					}
				case "\n":
				default:
					if (currentText != null) {
						currentText += char;
					}
			}
			++i;
		}
	}

	/** Returns a Scene with a specified index. **/
	public static function getSceneByIndex(index:Int):Scene {
		return null;
	}

	public static function loadScene(scene:Scene):Void {}

	public static function loadSceneAdditive(scene:Scene):Void {}
}
