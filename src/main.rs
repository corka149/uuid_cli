use clap::Parser;

#[derive(Parser)]
/// Creates UUIDs with different combinations
struct Cli {
    /// Use random case for characters in UUID
    #[arg(short = 'r', long)]
    random_case: bool,

    /// Replace ambiguous chars O and 0 by Q
    #[arg(short = 'a', long)]
    replace_ambiguous: bool,

    /// Amount of characters
    #[arg(short, long)]
    chars: Option<usize>,
}

impl Cli {
    fn replace_ambiguous_char(&self, c: char) -> char {
        if self.replace_ambiguous && (c == '0' || c == 'o') {
            'q'
        } else {
            c
        }
    }

    fn maybe_to_uppercase(&self, c: char) -> char {
        if self.random_case && rand::random::<bool>() {
            c.to_ascii_uppercase()
        } else {
            c
        }
    }
}

fn main() {
    let cli = Cli::parse();

    let mut uuid: String = uuid::Uuid::new_v4().to_string()
        .chars()
        .map(|c| cli.replace_ambiguous_char(c))
        .map(|c| cli.maybe_to_uppercase(c))
        .collect();

    if let Some(chars) = cli.chars {
        uuid.truncate(chars);
    }

    println!("{}", uuid)
}
