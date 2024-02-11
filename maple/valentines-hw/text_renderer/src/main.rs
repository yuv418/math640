use std::error::Error;
use std::fmt::Write;
use std::path::PathBuf;

use pyo3::prelude::*;

use pyo3::types::PyList;
use ttf_parser as ttf;

mod lrc_parser;
mod renderer;
mod svg_parser;

use lrc_parser::lrc_to_timings;
use renderer::generate_sentence_fns;

// const FONT_PATH: &'static str = "comic-sans-ms/COMIC.TTF";
const FONT_PATH: &'static str = "/usr/share/fonts/liberation/LiberationSerif-Regular.ttf";

// const FONT_PATH: &'static str = "/usr/share/fonts/adobe-source-han-sans/SourceHanSansCN-Regular.otf";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let font_data = std::fs::read(FONT_PATH)?;
    let mut font_face = ttf::Face::parse(&font_data, 0)?;

    let sentence = "The quick brown fox jumped over the lazy dog";
    // let fns = generate_sentence_fns(&mut font_face, sentence, 0.01, (0., 0.));
    let fns: Vec<String> = vec![];
    if let Some(lrc_file) = std::env::args().nth(1) {
        let midi_file = std::env::args().nth(2).expect("Missing MIDI track");
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
        )?;
        // println!("{:?}", fns[0].0);

        let code = std::fs::read_to_string("../desmos_api/graph_writer.py")?;
        let song_code = std::fs::read_to_string("../desmos_api/song_gen.py")?;

        Python::with_gil(|py| {
            let graph_writer =
                PyModule::from_code(py, &code, "graph_writer.py", "graph_writer").unwrap();
            let song_gen = PyModule::from_code(py, &song_code, "song_gen.py", "song_gen").unwrap();
            let song_args = (midi_file, track, 500, octave_shift);

            let generate_piecewise_song = song_gen.getattr("generate_piecewise_song").unwrap();
            let song_fn = generate_piecewise_song
                .call(song_args, None)
                .expect("Failed to convert song to fn");

            // let function_list = builder.function_list.into_py_list(py).unwrap(); graph_writer.graph_fn(builder.function_list);
            let fns_py = PyList::new(py, fns);
            let args = (fns_py, song_fn);
            let graph_fn = graph_writer.getattr("graph_fn").unwrap();
            graph_fn.call(args, None).expect("Graph generation failed");
        });
        println!("Wrote graph to file");
    } else {
        println!("Usage: ./text_renderer [lrc-file] ")
    }

    Ok(())
}
