use crate::entity::{Component , Entity};
use std::collections::HashMap;

/// A `Scene`
pub struct Scene(HashMap<usize, Vec<Box<dyn Component>>>);

impl Scene {
    /// Creates a new `Scene`
    pub fn new() -> Self {
        Scene(HashMap::new())
    }

    /// Parses a `&str` into a `Scene` struct that you can later use with `Scene::from()` or `scene.append()`
    pub fn parse(data: &str) -> Self {
        Self::new()
    }

    /// Appends the content of a existing `Scene`
    pub fn append(&mut self, scene: Self) {
        self.0.extend(scene.0);
    }

    /// Parses and appends all contents of the parsed `Scene` struct
    pub fn parse_append(&mut self, data: &str) {
        self.0.extend(HashMap::new());
    }

    /// Adds a given `Entity` to this `Scene`
    pub fn add_entity(&mut self, entity: Entity) {
        // self.0.contains_key(entity)
    }

    // pub fn add<T: Component + 'static>(&mut self, component: T) {
    //     self.0.insert(0, vec![Box::new(component)]);
    // }
}
