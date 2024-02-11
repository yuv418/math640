use svg::Document;

fn parse_svg(input_file: &str) {
    let mut content = String::new();
    for event in svg::open(input_file, &mut content).unwrap() {
        match event {
            svg::parser::Event::Tag(inp, _, attributes) => {
                if inp == "path" {
                    // we have this code
                    unimplemented!();
                } else if inp == "line" {
                    let x1: f32 = attributes.get("x1").unwrap().parse().unwrap();
                    let x2: f32 = attributes.get("x2").unwrap().parse().unwrap();
                    let y1: f32 = attributes.get("y1").unwrap().parse().unwrap();
                    let y2: f32 = attributes.get("y2").unwrap().parse().unwrap();

                    let stroke: String = attributes.get("stroke").unwrap().parse().unwrap();

                    // flipped
                    let slope = (y2 - y1) / (x1 - x2);

                    // output maple
                    // \left(x_{1}+\left(x_{2}-x_{1}\right)t,\ y_{1}+\left(y_{1}-y_{2}\right)t\right)
                    println!("plot(f(x)=)")
                } else if inp == "polygon" {
                }
            }
            _ => {}
        }
    }
}
