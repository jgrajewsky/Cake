let project = new Project('Cake');

project.addAssets('assets');
project.addShaders('shaders');
project.addSources('source');
project.addParameter('-dce no');
project.addParameter("--macro keep('cake.engine.Transform')");

resolve(project);
