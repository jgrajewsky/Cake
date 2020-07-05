use std::time::Instant;

static mut START_TIME: Option<Instant> = None;
static mut TIME_SCALE: f32 = 1.0;
static mut FRAME_TIME: f32 = 0.0;
static mut DELTA_TIME: f32 = 0.0;
static mut UNSCALED_TIME: f32 = 0.0;
static mut UNSCALED_DELTA_TIME: f32 = 0.0;
static mut FRAME_COUNT: u32 = 0;

pub fn init() {
    unsafe {
        START_TIME = Some(Instant::now());
    }
}

pub fn update() {
    unsafe {
        FRAME_COUNT += 1;
        let time = START_TIME.unwrap().elapsed().as_secs_f32();
        let unscaled_delta = time - FRAME_TIME;
        UNSCALED_TIME = unscaled_delta;
        UNSCALED_DELTA_TIME = unscaled_delta;
        let scaled_delta = unscaled_delta * TIME_SCALE;
        FRAME_TIME += scaled_delta;
        DELTA_TIME = scaled_delta;
    }
}

/// The scale at which time passes. Default is `1.0`
pub fn time_scale() -> f32 {
    unsafe { TIME_SCALE }
}

pub fn set_time_scale(new_scale: f32) {
    unsafe {
        TIME_SCALE = new_scale;
    }
}

/// The time in seconds since the start of the game.
pub fn time() -> f32 {
    unsafe { START_TIME.unwrap().elapsed().as_secs_f32() }
}

/// The time in seconds at the beginning of this frame.
pub fn frame_time() -> f32 {
    unsafe { FRAME_TIME }
}

/// The time in seconds between the last and the current frame.
pub fn delta() -> f32 {
    unsafe { DELTA_TIME }
}

/// The `timeScale` independent time in seconds since the start of the game.
pub fn unscaled_time() -> f32 {
    unsafe { UNSCALED_TIME }
}

/// The `timeScale` independent time in seconds between the last and the current frame.
pub fn unscaled_delta() -> f32 {
    unsafe { UNSCALED_DELTA_TIME }
}

/// The total number of frames that have passed.
pub fn frame_count() -> u32 {
    unsafe { FRAME_COUNT }
}
