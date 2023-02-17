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

    // Updates the given uuid based on the CLI flags.
    fn update_uuid(&self, uuid: uuid::Uuid) -> String {
        let char_num = self.chars.unwrap_or(36);

        uuid.to_string()
        .chars()
        .map(|c| self.replace_ambiguous_char(c))
        .map(|c| self.maybe_to_uppercase(c))
        .take(char_num)
        .collect()
    }
}

fn main() {
    let cli = Cli::parse();

    let uuid = uuid::Uuid::new_v4();
    let uuid = cli.update_uuid(uuid);

    println!("{}", uuid)
}

#[cfg(test)]
mod tests {

}
