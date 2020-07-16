pub trait System {
    type Data;

    fn update(&mut self, data: Self::Data);
}
