use std::fmt::Write;
use ttf_parser as ttf;

struct DesmosPolynomialBuilder {
    cmds: String,
    function_list: Vec<String>,
    current_point: (f32, f32),
    scale: f32,
    offset: (f32, f32),
}

impl DesmosPolynomialBuilder {
    fn new(scale: f32, offset: (f32, f32)) -> Self {
        Self {
            scale,
            offset,
            function_list: vec![],
            cmds: String::new(),
            current_point: (0.0, 0.0),
        }
    }
}

impl ttf::OutlineBuilder for DesmosPolynomialBuilder {
    fn move_to(&mut self, x: f32, y: f32) {
        let x = x * self.scale;
        let y = y * self.scale;

        // println!("Move to {} {}", x, y);
        write!(&mut self.cmds, "M {} {}", x, y).unwrap();

        self.current_point = (x, y);
    }

    fn line_to(&mut self, x: f32, y: f32) {
        let x = x * self.scale;
        let y = y * self.scale;

        // println!("Line to {} {}", x, y);
        write!(&mut self.cmds, "L {} {}", x, y).unwrap();

        // Print the function
        let x_t_slope = x - self.current_point.0;
        let y_t_slope = y - self.current_point.1;

        let l_x_t = format!("{} + {}t", self.current_point.0, x_t_slope);
        let l_y_t = format!("{} + {}t", self.current_point.1, y_t_slope);

        self.function_list.push(format!(
            "\\left({} + {},\\ {} + {}\\right)",
            l_x_t, self.offset.0, l_y_t, self.offset.1
        ));

        self.current_point = (x, y);
    }

    fn quad_to(&mut self, x1: f32, y1: f32, x: f32, y: f32) {
        let x = x * self.scale;
        let y = y * self.scale;

        let x1 = x1 * self.scale;
        let y1 = y1 * self.scale;

        // println!("Quad to {} {} {} {}", x1, y1, x, y);
        write!(&mut self.cmds, "Q {} {} {} {}", x1, y1, x, y).unwrap();

        // Print the function
        // Quadratic Bézier curve with one intermediate format

        // B_x(t) = cur_x(1-t)^2 + 2x_1(t-1) + xt^2
        // B_y(t) = cur_y(1-t)^2 + 2y_1(t-1) + yt^2

        let b_x = format!(
            "{}*\\left(1-t\\right)^{{2}} + 2*{}*\\left(1-t\\right)t + {}*t^2",
            self.current_point.0, x1, x
        );
        let b_y = format!(
            "{}*\\left(1-t\\right)^{{2}} + 2*{}*\\left(1-t\\right)t + {}*t^2",
            self.current_point.1, y1, y
        );

        self.function_list.push(format!(
            "\\left({} + {}, {} + {}\\right)",
            b_x, self.offset.0, b_y, self.offset.1
        ));

        self.current_point = (x, y);
    }

    fn curve_to(&mut self, x1: f32, y1: f32, x2: f32, y2: f32, x: f32, y: f32) {
        let x1 = x1 * self.scale;
        let y1 = y1 * self.scale;

        let x2 = x2 * self.scale;
        let y2 = y2 * self.scale;

        let x = x * self.scale;
        let y = y * self.scale;

        println!("Curve to {} {} {} {} {} {}", x1, y1, x2, y2, x, y);
        write!(&mut self.cmds, "C {} {} {} {} {} {}", x1, y1, x2, y2, x, y).unwrap();

        // Push to function list
        // todo!();

        self.current_point = (x, y);
    }

    fn close(&mut self) {
        println!("Close");
        write!(&mut self.cmds, "Z").unwrap()
    }
}

fn generate_fns_for_char(
    font_face: &mut ttf::Face,
    ch: char,
    scale: f32,
    offset: (f32, f32),
) -> (Option<ttf::Rect>, Vec<String>) {
    if let Some(a_character) = font_face.glyph_index(ch) {
        // This does nothing so we have to use the hmtx table to find the advance width
        // (not directly though, thankfully)
        if ch == ' ' {
            if let Some(advance) = font_face.glyph_hor_advance(a_character) {
                (
                    Some(ttf::Rect {
                        x_min: 0,
                        y_min: 0,
                        x_max: advance as i16,
                        y_max: 0,
                    }),
                    vec![],
                )
            } else {
                panic!("Space does not have an advance size");
            }
        } else {
            // println!("{:?}", a_character);
            // Check what kinds of information this has

            // Useless debugging information
            // println!("{:?}", font_face.glyph_svg_image(a_character));
            // println!("{:?}", font_face.glyph_raster_image(a_character, 100));
            let mut builder = DesmosPolynomialBuilder::new(scale, offset);
            let rect = font_face.outline_glyph(a_character, &mut builder);
            // println!("Commands are: {}", builder.cmds);
            // println!("Function array is: {:?}", builder.function_list);

            (rect, builder.function_list)
        }
    } else {
        (None, vec![])
    }
}

pub fn generate_sentence_fns(
    font_face: &mut ttf::Face,
    sentence: &str,
    scale: f32,
    current_offset: (f32, f32),
) -> Vec<String> {
    let mut all_fns = vec![];
    let mut current_offset = current_offset;

    for ch in sentence.chars() {
        let (rect, mut fns) = generate_fns_for_char(font_face, ch, scale, current_offset);
        if let Some(rect) = rect {
            current_offset.0 += (rect.x_max as f32) * scale;
        }
        all_fns.append(&mut fns);
    }
    all_fns
}
