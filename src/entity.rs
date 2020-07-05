pub struct Entity(u32);

impl Entity {
    pub fn new() -> Self {
        Self(0)
    }
}

pub trait Component {}

pub trait Behavior: Component {
    fn on_attach(&self) {}
    fn on_update(&self) {}
    fn on_detach(&self) {}
}
