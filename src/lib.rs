mod vector2;
pub use vector2::Vector2;
pub type V2 = Vector2<f32>;
pub type V2I = Vector2<i32>;
mod vector3;
pub use vector3::Vector3;
pub type V3 = Vector3<f32>;
pub type V3I = Vector3<i32>;
mod matrix4;
pub use matrix4::Matrix4;
mod time;
pub use time::{
    delta, frame_count, frame_time, set_time_scale, time, time_scale, unscaled_delta, unscaled_time,
};
mod entity;
pub use cake_derive::Component;
pub use entity::Behavior;
pub use entity::Component;
pub use entity::Entity;
mod system;
pub use system::System;

#[cfg(feature = "dx11")]
extern crate gfx_backend_dx11 as back;
#[cfg(feature = "dx12")]
extern crate gfx_backend_dx12 as back;
#[cfg(not(any(
    feature = "vulkan",
    feature = "dx11",
    feature = "dx12",
    feature = "metal",
    feature = "gl",
    feature = "wgl",
)))]
extern crate gfx_backend_empty as back;
#[cfg(any(feature = "gl", feature = "wgl"))]
extern crate gfx_backend_gl as back;
#[cfg(feature = "metal")]
extern crate gfx_backend_metal as back;
#[cfg(feature = "vulkan")]
extern crate gfx_backend_vulkan as back;

#[cfg(target_arch = "wasm32")]
#[wasm_bindgen(start)]
pub fn wasm_main() {
    start();
}

use gfx_hal::{
    adapter::Adapter,
    device::Device,
    format::Format,
    queue::QueueGroup,
    window::{Extent2D, PresentationSurface, Surface},
    Backend, Instance,
};

use std::mem::ManuallyDrop;

pub fn start() {
    let wb = winit::window::WindowBuilder::new()
        .with_inner_size(winit::dpi::Size::Physical(winit::dpi::PhysicalSize::new(
            512, 512,
        )))
        .with_title("Cake Test".to_string());

    let event_loop = winit::event_loop::EventLoop::new();

    #[cfg(not(feature = "gl"))]
    let (_window, instance, mut adapters, surface) = {
        let window = wb.build(&event_loop).unwrap();
        let instance =
            back::Instance::create("Cake Test", 1).expect("Failed to create an instance!");
        let surface = unsafe {
            instance
                .create_surface(&window)
                .expect("Failed to create a surface!")
        };
        let adapters = instance.enumerate_adapters();
        (window, Some(instance), adapters, surface)
    };
    #[cfg(feature = "gl")]
    let (_window, instance, mut adapters, surface) = {
        #[cfg(not(target_arch = "wasm32"))]
        let (window, surface) = {
            let builder =
                back::config_context(back::glutin::ContextBuilder::new(), ColorFormat::SELF, None)
                    .with_vsync(true);
            let windowed_context = builder.build_windowed(wb, &event_loop).unwrap();
            let (context, window) = unsafe {
                windowed_context
                    .make_current()
                    .expect("Unable to make context current")
                    .split()
            };
            let surface = back::Surface::from_context(context);
            (window, surface)
        };
        #[cfg(target_arch = "wasm32")]
        let (window, surface) = {
            let window = wb.build(&event_loop).unwrap();
            web_sys::window()
                .unwrap()
                .document()
                .unwrap()
                .body()
                .unwrap()
                .append_child(&winit::platform::web::WindowExtWebSys::canvas(&window));
            let surface = back::Surface::from_raw_handle(&window);
            (window, surface)
        };
        let adapters = surface.enumerate_adapters();
        (window, None, adapters, surface)
    };
    let adapter = adapters.remove(0);

    let mut renderer = Renderer::new(instance, surface, adapter);

    time::init();

    event_loop.run(move |event, _, control_flow| {
        time::update();
        match event {
            winit::event::Event::WindowEvent { event, .. } => match event {
                winit::event::WindowEvent::CloseRequested => {
                    *control_flow = winit::event_loop::ControlFlow::Exit
                }
                winit::event::WindowEvent::Resized(dims) => {
                    #[cfg(all(feature = "gl", not(target_arch = "wasm32")))]
                    {
                        let context = renderer.surface.context();
                        context.resize(dims);
                    }
                    renderer.dimensions = Extent2D {
                        width: dims.width,
                        height: dims.height,
                    };
                    renderer.recreate_swapchain();
                }
                _ => {}
            },
            winit::event::Event::RedrawEventsCleared => {
                renderer.render();
            }
            _ => {}
        }
    });
}

#[no_mangle]
extern "C" fn start_editor(
    window: &winit::window::Window,
    event_loop: winit::event_loop::EventLoop<()>,
) {
    let (instance, mut adapters, surface) = {
        let instance =
            back::Instance::create("Cake Test", 1).expect("Failed to create an instance!");
        let surface = unsafe {
            instance
                .create_surface(window)
                .expect("Failed to create a surface!")
        };
        let adapters = instance.enumerate_adapters();
        (Some(instance), adapters, surface)
    };

    let adapter = adapters.remove(0);

    let mut renderer = Renderer::new(instance, surface, adapter);

    time::init();

    event_loop.run(move |event, _, control_flow| {
        time::update();
        match event {
            winit::event::Event::WindowEvent { event, .. } => match event {
                winit::event::WindowEvent::CloseRequested => {
                    *control_flow = winit::event_loop::ControlFlow::Exit
                }
                winit::event::WindowEvent::Resized(dims) => {
                    #[cfg(all(feature = "gl", not(target_arch = "wasm32")))]
                    {
                        let context = renderer.surface.context();
                        context.resize(dims);
                    }
                    renderer.dimensions = Extent2D {
                        width: dims.width,
                        height: dims.height,
                    };
                    renderer.recreate_swapchain();
                }
                _ => {}
            },
            winit::event::Event::RedrawEventsCleared => {
                renderer.render();
            }
            _ => {}
        }
    });
}

struct Renderer<B: Backend> {
    dimensions: Extent2D,
    instance: Option<B::Instance>,
    surface: ManuallyDrop<B::Surface>,
    adapter: Adapter<B>,
    format: Format,
    device: B::Device,
    queue_group: QueueGroup<B>,
    render_pass: ManuallyDrop<B::RenderPass>,
    pipeline_layout: ManuallyDrop<B::PipelineLayout>,
    pipeline: ManuallyDrop<B::GraphicsPipeline>,
    command_pool: ManuallyDrop<B::CommandPool>,
    command_buffer: B::CommandBuffer,
    submission_complete_fence: B::Fence,
    rendering_complete_semaphore: B::Semaphore,
}

impl<B: Backend> Renderer<B> {
    fn new(
        instance: Option<B::Instance>,
        mut surface: B::Surface,
        adapter: Adapter<B>,
    ) -> Renderer<B> {
        let dimensions = Extent2D {
            width: 512,
            height: 512,
        };

        let (device, mut queue_group) = {
            use gfx_hal::queue::QueueFamily;
            let queue_family = adapter
                .queue_families
                .iter()
                .find(|family| {
                    surface.supports_queue_family(family) && family.queue_type().supports_graphics()
                })
                .expect("No compatible queue family found");
            let mut gpu = unsafe {
                use gfx_hal::adapter::PhysicalDevice;
                adapter
                    .physical_device
                    .open(&[(queue_family, &[1.0])], gfx_hal::Features::empty())
                    .expect("Failed to open device")
            };
            (gpu.device, gpu.queue_groups.pop().unwrap())
        };
        let (command_pool, mut command_buffer) = unsafe {
            use gfx_hal::command::Level;
            use gfx_hal::pool::{CommandPool, CommandPoolCreateFlags};
            let mut command_pool = device
                .create_command_pool(queue_group.family, CommandPoolCreateFlags::empty())
                .expect("Out of memory");
            let command_buffer = command_pool.allocate_one(Level::Primary);
            (command_pool, command_buffer)
        };
        let caps = surface.capabilities(&adapter.physical_device);
        let formats = surface.supported_formats(&adapter.physical_device);
        let format = formats.map_or(Format::Rgba8Srgb, |formats| {
            formats
                .iter()
                .find(|format| format.base_format().1 == gfx_hal::format::ChannelType::Srgb)
                .map(|format| *format)
                .unwrap_or(formats[0])
        });

        let swap_config = gfx_hal::window::SwapchainConfig::from_caps(&caps, format, dimensions);
        let extent = swap_config.extent;
        unsafe {
            surface
                .configure_swapchain(&device, swap_config)
                .expect("Can't configure swapchain");
        };

        let render_pass = {
            use gfx_hal::image::Layout;
            use gfx_hal::pass::{
                Attachment, AttachmentLoadOp, AttachmentOps, AttachmentStoreOp, SubpassDesc,
            };
            let color_attachment = Attachment {
                format: Some(format),
                samples: 1,
                ops: AttachmentOps::new(AttachmentLoadOp::Clear, AttachmentStoreOp::Store),
                stencil_ops: AttachmentOps::DONT_CARE,
                layouts: Layout::Undefined..Layout::Present,
            };
            let subpass = SubpassDesc {
                colors: &[(0, Layout::ColorAttachmentOptimal)],
                depth_stencil: None,
                inputs: &[],
                resolves: &[],
                preserves: &[],
            };
            unsafe {
                device
                    .create_render_pass(&[color_attachment], &[subpass], &[])
                    .expect("Out of memory")
            }
        };
        let pipeline_layout = unsafe {
            device
                .create_pipeline_layout(&[], &[])
                .expect("Out of memory")
        };
        unsafe fn make_pipeline<B: gfx_hal::Backend>(
            device: &B::Device,
            render_pass: &B::RenderPass,
            pipeline_layout: &B::PipelineLayout,
        ) -> B::GraphicsPipeline {
            use gfx_hal::pass::Subpass;
            use gfx_hal::pso::read_spirv;
            use gfx_hal::pso::{
                BlendState, ColorBlendDesc, ColorMask, EntryPoint, Face, GraphicsPipelineDesc,
                GraphicsShaderSet, Primitive, Rasterizer, Specialization,
            };
            use std::io::Cursor;
            let vertex_shader_module = device
                .create_shader_module(
                    &read_spirv(Cursor::new(
                        &include_bytes!("shaders/default.vert.spirv")[..],
                    ))
                    .unwrap(),
                )
                .expect("Failed to create vertex shader module");
            let fragment_shader_module = device
                .create_shader_module(
                    &read_spirv(Cursor::new(
                        &include_bytes!("shaders/default.frag.spirv")[..],
                    ))
                    .unwrap(),
                )
                .expect("Failed to create fragment shader module");
            let (vs_entry, fs_entry) = (
                EntryPoint {
                    entry: "main",
                    module: &vertex_shader_module,
                    specialization: Specialization::default(),
                },
                EntryPoint {
                    entry: "main",
                    module: &fragment_shader_module,
                    specialization: Specialization::default(),
                },
            );
            let shader_entries = GraphicsShaderSet {
                vertex: vs_entry,
                hull: None,
                domain: None,
                geometry: None,
                fragment: Some(fs_entry),
            };
            let mut pipeline_desc = GraphicsPipelineDesc::new(
                shader_entries,
                Primitive::TriangleList,
                Rasterizer {
                    cull_face: Face::BACK,
                    ..Rasterizer::FILL
                },
                pipeline_layout,
                Subpass {
                    index: 0,
                    main_pass: render_pass,
                },
            );
            pipeline_desc.blender.targets.push(ColorBlendDesc {
                mask: ColorMask::ALL,
                blend: Some(BlendState::ALPHA),
            });
            let pipeline = device
                .create_graphics_pipeline(&pipeline_desc, None)
                .expect("Failed to create graphics pipeline");
            device.destroy_shader_module(vertex_shader_module);
            device.destroy_shader_module(fragment_shader_module);
            pipeline
        };
        let pipeline = unsafe { make_pipeline::<B>(&device, &render_pass, &pipeline_layout) };
        let submission_complete_fence = device.create_fence(true).expect("Out of memory");
        let rendering_complete_semaphore = device.create_semaphore().expect("Out of memory");

        Renderer {
            dimensions,
            instance,
            surface: ManuallyDrop::new(surface),
            adapter,
            format,
            device,
            queue_group,
            render_pass: ManuallyDrop::new(render_pass),
            pipeline_layout: ManuallyDrop::new(pipeline_layout),
            pipeline: ManuallyDrop::new(pipeline),
            command_pool: ManuallyDrop::new(command_pool),
            command_buffer,
            submission_complete_fence,
            rendering_complete_semaphore,
        }
    }
    fn render(&mut self) {
        unsafe {
            use gfx_hal::pool::CommandPool;

            let render_timeout_ns = 1_000_000_000;

            self.device
                .wait_for_fence(&self.submission_complete_fence, render_timeout_ns)
                .expect("Out of memory or device lost");

            self.device
                .reset_fence(&self.submission_complete_fence)
                .expect("Out of memory");

            self.command_pool.reset(false);
        }

        let surface_image = unsafe {
            let acquire_timeout_ns = 1_000_000_000;

            match self.surface.acquire_image(acquire_timeout_ns) {
                Ok((image, _)) => image,
                Err(_) => {
                    self.recreate_swapchain();
                    return;
                }
            }
        };

        let framebuffer = unsafe {
            use std::borrow::Borrow;

            use gfx_hal::image::Extent;

            self.device
                .create_framebuffer(
                    &self.render_pass,
                    vec![surface_image.borrow()],
                    Extent {
                        width: self.dimensions.width,
                        height: self.dimensions.height,
                        depth: 1,
                    },
                )
                .unwrap()
        };

        let viewport = {
            use gfx_hal::pso::{Rect, Viewport};

            Viewport {
                rect: Rect {
                    x: 0,
                    y: 0,
                    w: self.dimensions.width as i16,
                    h: self.dimensions.height as i16,
                },
                depth: 0.0..1.0,
            }
        };

        unsafe {
            use gfx_hal::command::{
                ClearColor, ClearValue, CommandBuffer, CommandBufferFlags, SubpassContents,
            };

            self.command_buffer
                .begin_primary(CommandBufferFlags::ONE_TIME_SUBMIT);

            self.command_buffer.set_viewports(0, &[viewport.clone()]);
            self.command_buffer.set_scissors(0, &[viewport.rect]);
            self.command_buffer.begin_render_pass(
                &self.render_pass,
                &framebuffer,
                viewport.rect,
                &[ClearValue {
                    color: ClearColor {
                        float32: [0.0, 0.0, 0.0, 1.0],
                    },
                }],
                SubpassContents::Inline,
            );
            self.command_buffer.bind_graphics_pipeline(&self.pipeline);
            self.command_buffer.draw(0..3, 0..1);
            self.command_buffer.end_render_pass();
            self.command_buffer.finish();
        }

        unsafe {
            use gfx_hal::queue::{CommandQueue, Submission};

            let submission = Submission {
                command_buffers: vec![&self.command_buffer],
                wait_semaphores: None,
                signal_semaphores: vec![&self.rendering_complete_semaphore],
            };

            self.queue_group.queues[0].submit(submission, Some(&self.submission_complete_fence));
            let result = self.queue_group.queues[0].present_surface(
                &mut self.surface,
                surface_image,
                Some(&self.rendering_complete_semaphore),
            );
            self.device.destroy_framebuffer(framebuffer);

            if result.is_err() {
                self.recreate_swapchain();
            }
        }
    }

    fn recreate_swapchain(&mut self) {
        use gfx_hal::window::SwapchainConfig;
        let caps = self.surface.capabilities(&self.adapter.physical_device);
        let mut swap_config = SwapchainConfig::from_caps(&caps, self.format, self.dimensions);

        if caps.image_count.contains(&3) {
            swap_config.image_count = 3;
        }

        self.dimensions = swap_config.extent;

        unsafe {
            self.surface
                .configure_swapchain(&self.device, swap_config)
                .expect("Can't create swapchain");
        }
    }
}

impl<B: Backend> Drop for Renderer<B> {
    fn drop(&mut self) {
        unsafe {
            use std::ptr;
            self.device
                .destroy_graphics_pipeline(ManuallyDrop::into_inner(ptr::read(&self.pipeline)));
            self.device
                .destroy_pipeline_layout(ManuallyDrop::into_inner(ptr::read(
                    &self.pipeline_layout,
                )));
            self.device
                .destroy_render_pass(ManuallyDrop::into_inner(ptr::read(&self.render_pass)));
            self.device
                .destroy_command_pool(ManuallyDrop::into_inner(ptr::read(&self.command_pool)));
            self.surface.unconfigure_swapchain(&self.device);
            self.instance
                .as_ref()
                .unwrap()
                .destroy_surface(ManuallyDrop::into_inner(ptr::read(&self.surface)));
        }
    }
}
