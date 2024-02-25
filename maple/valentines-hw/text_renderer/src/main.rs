use std::error::Error;
use std::fs::File;
use std::io::Write;
use std::path::PathBuf;

use ttf_parser as ttf;

mod lrc_parser;
mod renderer;
mod svg_parser;

use lrc_parser::lrc_to_timings;
use renderer::generate_sentence_fns;

// const FONT_PATH: &'static str = "comic-sans-ms/COMIC.TTF";
const FONT_PATH: &'static str = "Cedarville_Cursive/CedarvilleCursive-Regular.ttf";
// const FONT_PATH: &'static str = "/home/nonuser/Downloads/Indie_Flower/IndieFlower-Regular.ttf";
// const FONT_PATH: &'static str = "/usr/share/fonts/liberation/LiberationSerif-Regular.ttf";

// const FONT_PATH: &'static str = "/usr/share/fonts/adobe-source-han-sans/SourceHanSansCN-Regular.otf";

fn caesar_cipher(inp_str: &str, shift: u8) -> String {
    // if capital
    let mut out = "".to_owned();
    for ch in inp_str.chars() {
        if ch == ' ' {
            out.push(' ');
            continue;
        }
        let ch = ch as u8;
        if ch >= 65 && ch <= 90 {
            out.push(((((ch - 65) + shift) % 26) + 65) as char);
        } else if ch >= 97 && ch <= 122 {
            out.push(((((ch - 97) + shift) % 26) + 97) as char);
        }
    }
    return out;
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let font_data = std::fs::read(FONT_PATH)?;
    let mut font_face = ttf::Face::parse(&font_data, 0)?;

    let age = 19;
    let sentence = "I love";
    let mut fns = generate_sentence_fns(
        &mut font_face,
        &caesar_cipher(sentence, age),
        0.008,
        (52., -65.),
    );

    let sentence = "coding theory";
    let mut fns2 = generate_sentence_fns(
        &mut font_face,
        &caesar_cipher(sentence, age),
        0.0067,
        (38.8, -72.),
    );
    fns.append(&mut fns2);
    let mut f = File::create("output.txt").expect("cant output");

    f.write(format!("with(plots):\n\n").as_bytes());
    f.write(
        format!(
            "text_plot:=plot([{}], color=orange, scaling=constrained,thickness=3):\n\n",
            fns.join(",")
        )
        .as_bytes(),
    );

    if let Some(svg_file) = std::env::args().nth(1) {
        /*let midi_file = std::env::args().nth(2).expect("Missing MIDI track");
        let track: u32 = std::env::args().nth(3).expect("Missing track").parse()?;
        let octave_shift: u32 = std::env::args()
            .nth(4)
            .expect("Missing octave shift")
            .parse()?;
        let offset: i64 = std::env::args().nth(5).expect("Missing offset").parse()?;
        let scale_factor: f32 = std::env::args()
            .nth(6)
            .expect("Missing scale_factor")
            .parse()?;

        let lrc_path = PathBuf::from(lrc_file);
        let fns = lrc_to_timings(
            &mut font_face,
            0.0004,
            (-9., 0.),
            offset,
            scale_factor,
            lrc_path,
        )?;*/

        let svg_hearthands = "../u1faf6.svg";
        svg_parser::parse_svg(
            &svg_hearthands,
            10,
            "ColorTools:-Color(ColorTools:-HexToRGB24(\"#b98e6c\"))",
            1.0,
            (0.0, 0.0),
            "heart_hands",
            &mut f,
        );

        let svg_sparkle = "../u2728.svg";
        svg_parser::parse_svg(
            &svg_sparkle,
            5,
            "ColorTools:-Color(ColorTools:-HexToRGB24(\"#fcc441\"))",
            0.11,
            (110.0, -20.0),
            "sparkle",
            &mut f,
        );

        let svg_star = "../u1f4ab.svg";
        svg_parser::parse_svg(
            &svg_star,
            5,
            "ColorTools:-Color(ColorTools:-HexToRGB24(\"#fcc441\"))",
            0.11,
            (15.0, -100.0),
            "dizzy_star",
            &mut f,
        );

        f.write(
            format!("display(text_plot, heart_hands, sparkle, dizzy_star, size=[1000, 700]);")
                .as_bytes(),
        );

        // println!("{:?}", fns[0].0);

        println!("Wrote graph to file");
    } else {
        println!("Usage: ./text_renderer [lrc-file] ")
    }

    Ok(())
}
