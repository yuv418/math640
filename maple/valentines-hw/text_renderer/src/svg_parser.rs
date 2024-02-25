use std::{fs::File, io::Write};

use svg::{
    node::element::path::{Command, Data, Position},
    Document,
};
use ttf_parser::OutlineBuilder;

use crate::renderer::MaplePathBuilder;

fn line_output((x1, y1): (f32, f32), (x2, y2): (f32, f32), cmd_list: &mut Vec<String>) {
    // output maple
    // desmos:
    // \left(x_{1}+\left(x_{2}-x_{1}\right)t,\ y_{1}+\left(y_{1}-y_{2}\right)t\right)
    cmd_list.push(format!(
        "[{} + ({} - {})*t, {} + ({} - {})*t, t=0..1]",
        x1,
        x2,
        x1,
        -1.0 * y1,
        y1,
        y2
    ));
}

pub fn parse_svg(
    input_file: &str,
    thickness: u32,
    color: &str,
    scale: f32,
    offset: (f32, f32),
    var_name: &str,
    out_file: &mut File,
) {
    let mut content = String::new();
    let mut cmd_list = Vec::new();
    let mut builder: MaplePathBuilder = MaplePathBuilder::new(1.0, offset);
    for event in svg::open(input_file, &mut content).unwrap() {
        match event {
            svg::parser::Event::Tag(inp, _, attributes) => {
                if inp == "path" {
                    // we have this code
                    let d: String = attributes.get("d").unwrap().parse().unwrap();
                    let data = Data::parse(&d).unwrap();
                    let cmds: Vec<Command> = Into::<Vec<Command>>::into(data);

                    let mut end_ctrl_pt: (f32, f32) = (0.0, 0.0);

                    for it in cmds {
                        println!("Data it {:?}", it);
                        match it {
                            Command::Move(Position::Absolute, param) => {
                                builder.move_to(scale * param[0], -1.0 * scale * param[1]);
                            }
                            Command::Line(Position::Absolute, param) => {
                                builder.line_to(scale * param[0], -1.0 * scale * param[1])
                            }
                            Command::Line(Position::Relative, param) => builder.line_to(
                                builder.current_point.0 + (scale * param[0]),
                                builder.current_point.1 + (-1.0 * scale * param[1]),
                            ),
                            Command::HorizontalLine(Position::Relative, param) => builder.line_to(
                                builder.current_point.0 + (scale * param[0]),
                                builder.current_point.1,
                            ),
                            Command::HorizontalLine(Position::Absolute, param) => {
                                builder.line_to(scale * param[0], builder.current_point.1)
                            }

                            Command::VerticalLine(Position::Relative, param) => builder.line_to(
                                builder.current_point.0,
                                builder.current_point.1 + (-1.0 * scale * param[0]),
                            ),
                            Command::VerticalLine(Position::Absolute, param) => {
                                builder.line_to(builder.current_point.0, -1.0 * scale * param[0])
                            }
                            Command::VerticalLine(_, _) => todo!(),
                            Command::QuadraticCurve(Position::Absolute, param) => {
                                for j in 0..(param.len() / 4) {
                                    let i = j * 4;
                                    builder.quad_to(
                                        scale * param[i + 0],
                                        -1.0 * scale * param[i + 1],
                                        scale * param[i + 2],
                                        -1.0 * scale * param[i + 3],
                                    )
                                }
                            }
                            Command::SmoothQuadraticCurve(_, _) => todo!(),
                            Command::CubicCurve(Position::Absolute, param) => {
                                for j in 0..(param.len() / 6) {
                                    let i = j * 6;
                                    builder.curve_to(
                                        scale * param[i + 0],
                                        -1.0 * scale * param[i + 1],
                                        scale * param[i + 2],
                                        -1.0 * scale * param[i + 3],
                                        scale * param[i + 4],
                                        -1.0 * scale * param[i + 5],
                                    );
                                }
                            }
                            Command::CubicCurve(Position::Relative, param) => {
                                for j in 0..(param.len() / 6) {
                                    let i = j * 6;
                                    builder.curve_to(
                                        builder.current_point.0 + (scale * param[i + 0]),
                                        builder.current_point.1 + (-1.0 * scale * param[i + 1]),
                                        builder.current_point.0 + (scale * param[i + 2]),
                                        builder.current_point.1 + (-1.0 * scale * param[i + 3]),
                                        builder.current_point.0 + (scale * param[i + 4]),
                                        builder.current_point.1 + (-1.0 * scale * param[i + 5]),
                                    );
                                }
                            }
                            Command::SmoothCubicCurve(Position::Relative, param) => {
                                // reflect control point
                                let xr = (2.0 * builder.current_point.0) - builder.end_control_pt.0;
                                let yr = (2.0 * builder.current_point.1) - builder.end_control_pt.1;
                                builder.curve_to(
                                    xr,
                                    yr,
                                    builder.current_point.0 + (scale * param[0]),
                                    builder.current_point.1 + (-1.0 * scale * param[1]),
                                    builder.current_point.0 + (scale * param[2]),
                                    builder.current_point.1 + (-1.0 * scale * param[3]),
                                );
                            }
                            Command::EllipticalArc(_, _) => todo!(),
                            Command::Close => {}
                            _ => {
                                todo!()
                            }
                        }
                    }

                    // cmd_list.append(&mut builder.function_list);
                } else if inp == "line" {
                    let x1: f32 = attributes.get("x1").unwrap().parse().unwrap();
                    let x2: f32 = attributes.get("x2").unwrap().parse().unwrap();
                    let y1: f32 = attributes.get("y1").unwrap().parse().unwrap();
                    let y2: f32 = attributes.get("y2").unwrap().parse().unwrap();

                    let stroke: String = attributes.get("stroke").unwrap().parse().unwrap();

                    line_output((x1, y1), (x2, y2), &mut cmd_list);
                } else if inp == "polygon" {
                    let points: String = attributes.get("points").unwrap().parse().unwrap();
                    let points_op: Vec<(f32, f32)> = points
                        .split_ascii_whitespace()
                        .map(|it| {
                            let sp: Vec<&str> = it.split(",").collect();
                            (sp[0].parse().unwrap(), sp[1].parse().unwrap())
                        })
                        .collect();
                    // for each two points, create a line.
                    for i in 0..points_op.len() {
                        let p1 = points_op[i % points_op.len()];
                        let p2 = points_op[(i + 1) % points_op.len()];

                        line_output(p1, p2, &mut cmd_list);
                    }
                }
            }
            _ => {}
        }
    }
    cmd_list.append(&mut builder.function_list);
    out_file.write(
        format!(
            "{}:=plot([{}], thickness={}, color={}):\n\n",
            var_name,
            cmd_list.join(","),
            thickness,
            color
        )
        .as_bytes(),
    );
    // println!("plot([{}])", builder.function_list.join(","));
}
