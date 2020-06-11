package cake.engine;

class TestSystem extends System {
	override function onUpdate() {
        System.forEach((c:Component, b:MeshRenderer) -> {
            trace(c);
            trace(b);
        });
        // inline function forEach(c:Component, b:MeshRenderer) {
        //     trace(c);
        //     trace(b);
        // };
        // var set0 = [new Component()];
        // var set1 = [new MeshRenderer()];
        // for (i in 0...set0.length) {
        //     forEach(set0[i], set1[i]);
        // }
	}
}
