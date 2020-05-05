let project = new Project('Cake');

project.addAssets('assets');
project.addShaders('shaders');
project.addSources('source');
project.addParameter("--macro include('cake.engine')")

resolve(project);
