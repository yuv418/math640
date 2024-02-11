use lrc::Lyrics;
use std::path::PathBuf;
use ttf_parser as ttf;

use crate::renderer::generate_sentence_fns;

pub fn lrc_to_timings(
    face: &mut ttf::Face,
    scale: f32,
    offset: (f32, f32),
    lyric_display_shift: i64,
    lyric_time_scale: f32,
    lrc_file: PathBuf,
) -> Result<Vec<(i64, Vec<String>)>, Box<dyn std::error::Error>> {
    let lrc = std::fs::read_to_string(lrc_file)?;
    let parsed_lrc = Lyrics::from_str(lrc)?;
    let mut output = vec![];
    let mut current_time_diff = 0.0;
    let timed_lines = parsed_lrc.get_timed_lines();

    // Supposedly some LRC files have nothing on the last tag, highlighting that it's the end of the song.
    // So we can skip the last one, since each i actually inserts the lyrics for the
    // i - 1th entry
    for i in 1..timed_lines.len() {
        // time is in milliseconds
        current_time_diff =
            (timed_lines[i].0.get_timestamp() - timed_lines[i - 1].0.get_timestamp()) as f32;
        let line = timed_lines[i - 1].1.clone();
        let line_fns = generate_sentence_fns(face, &line, scale, offset);
        output.push(((lyric_time_scale * (lyric_display_shift as f32 + current_time_diff as f32) as f32) as i64, line_fns))
    }
    Ok(output)
}
