package cake.engine;

class Entity {
	public var name:String;
	public var parent:Entity;
	public var transform(default, null):Transform;
	public var children:Array<Entity>;

	private var components:Array<Component>;

	public function new(name:String) {
		this.name = name;
		parent = null;
		children = [];
		components = [];
	}

	public function addComponent(type:Class<Component>):Component {
		var component = Type.createInstance(type, null);
		component.entity = this;
		if (transform == null && type == Transform) {
			transform = cast component;
			components.unshift(component);
		} else {
			components.push(component);
		}
		return component;
	}

	public function getComponent(type:Class<Component>):Component {
		for (component in components) {
			if (Type.getClass(component) == type) {
				return component;
			}
		}
		return null;
	}

	public function getComponents(type:Class<Component>):Array<Component> {
		var found = [];
		for (component in components) {
			if (Type.getClass(component) == type) {
				found.push(component);
			}
		}
		return found.length > 0 ? found : null;
	}

	public function removeComponent(type:Class<Component>):Bool {
		for (i in 0...components.length) {
			if (Type.getClass(components[i]) == type) {
				if (i == 0) {
					transform = null;
				}
				components.splice(i, 1);
				return true;
			}
		}
		return false;
	}

	public function removeComponents(type:Class<Component>):Int {
		var count = 0, i = 0;
		while (i < components.length) {
			if (Type.getClass(components[i]) == type) {
				if (i == 0) {
					transform = null;
				}
				components.splice(i--, 1);
				++count;
			}
			++i;
		}
		return count;
	}

	public function removeAllComponents():Void {
		components = [];
	}

	private final function onCreate():Void {
		for (component in components) {
			component.onCreate();
		}
		for (child in children) {
			child.onCreate();
		}
	}

	private final function onUpdate():Void {
		for (component in components) {
			component.onUpdate();
		}
		for (child in children) {
			child.onUpdate();
		}
	}

	private final function onDestroy():Void {
		for (component in components) {
			component.onDestroy();
		}
		for (child in children) {
			child.onDestroy();
		}
	}
}
