use clap::Parser;

#[derive(Parser)]
/// Creates UUIDs with different combinations
struct Cli {
    /// Use random case for characters in UUID
    #[arg(short = 'r', long)]
    random_case: bool,

    /// Replace ambiguous 0 by Q
    #[arg(short = 'a', long)]
    replace_ambiguous: bool,

    /// Amount of characters
    #[arg(short, long)]
    chars: Option<usize>,
}

impl Cli {
    fn replace_ambiguous_char(&self, c: char) -> char {
        if self.replace_ambiguous && c == '0' {
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
    use crate::Cli;

    #[test]
    fn test_replace_ambiguous_char() {
        let cli = Cli {
            chars: None,
            random_case: false,
            replace_ambiguous: true,
        };
        let uuid = uuid::uuid!("0f48752f-ceb0-4e19-985d-d855f5e65db0");
        let uuid = cli.update_uuid(uuid);

        assert!(!uuid.contains("0"));
    }

    #[test]
    fn test_random_case() {
        // This test depends heavy on randomness - as a easy hack we just try it multiple times

        let cli = Cli {
            chars: None,
            random_case: true,
            replace_ambiguous: false,
        };
        let uuid = uuid::uuid!("4f2b1eb0-1719-4306-b25f-48770954e990");
        let mut succeed = false;

        for _ in 0..=100 {
            let uuid_str = cli.update_uuid(uuid);

            if uuid_str.chars().any(|c| c.is_uppercase()) {
                succeed = true;
                break;
            }
        }

        assert!(succeed, "Did not uppercase any char in 100 tries");
    }

    #[test]
    fn test_char_amount() {
        let cli = Cli {
            chars: Some(6),
            random_case: true,
            replace_ambiguous: false,
        };
        let uuid = uuid::uuid!("eed62095-27f4-4df5-aa6b-812d6d495d2c");
        let uuid = cli.update_uuid(uuid);

        assert_eq!(uuid.len(), 6);
    }
}
