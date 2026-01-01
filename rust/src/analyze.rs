use std::fs;
use std::io::Read;
use flate2::read::GzDecoder;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input_file = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "ALLOBJS EXO.exolvl".to_string());

    println!("=== Analyzing: {} ===\n", input_file);

    let compressed = fs::read(&input_file)?;
    println!("Compressed size: {} bytes", compressed.len());
    println!("First 32 bytes (hex):");
    print_hex(&compressed[..compressed.len().min(32)]);

    println!("\nAttempting gzip decompression…");

    let mut decoder = GzDecoder::new(&compressed[..]);
    let mut raw = Vec::new();

    decoder.read_to_end(&mut raw)?;

    println!("✓ Decompressed successfully");
    println!("Raw size: {} bytes\n", raw.len());

    println!("=== Header ===");
    if raw.len() >= 8 {
        let magic = &raw[0..4];
        let version = &raw[4..8];

        println!("Magic (ASCII): {:?}", String::from_utf8_lossy(magic));
        println!("Magic (hex): {:02X?}", magic);
        println!("Version (LE u32): {}", u32::from_le_bytes(version.try_into()?));
    }

    println!("\n=== Hex Dump ===");
    print_hex(&raw[..raw.len().min(512)]);

    println!("\n=== Pattern Scan ===");
    analyze_strings(&raw);
    analyze_vec3(&raw);

    fs::write(format!("{input_file}.raw"), &raw)?;
    println!("\n✓ Saved raw payload to {input_file}.raw");

    Ok(())
}

fn print_hex(data: &[u8]) {
    for (i, chunk) in data.chunks(16).enumerate() {
        print!("{:08X}  ", i * 16);
        for b in chunk {
            print!("{:02X} ", b);
        }
        for _ in chunk.len()..16 {
            print!("   ");
        }
        print!(" |");
        for b in chunk {
            let c = if b.is_ascii_graphic() { *b as char } else { '.' };
            print!("{}", c);
        }
        println!("|");
    }
}

fn analyze_strings(data: &[u8]) {
    let mut i = 0;
    while i + 4 < data.len() {
        let len = u32::from_le_bytes(data[i..i + 4].try_into().unwrap()) as usize;
        if len > 0 && len < 256 && i + 4 + len <= data.len() {
            if let Ok(s) = std::str::from_utf8(&data[i + 4..i + 4 + len]) {
                if s.chars().all(|c| c.is_ascii_graphic() || c.is_whitespace()) {
                    println!("String @ {:#X}: \"{}\"", i, s);
                }
            }
        }
        i += 1;
    }
}

fn analyze_vec3(data: &[u8]) {
    let mut i = 0;
    while i + 12 <= data.len() {
        let x = f32::from_le_bytes(data[i..i + 4].try_into().unwrap());
        let y = f32::from_le_bytes(data[i + 4..i + 8].try_into().unwrap());
        let z = f32::from_le_bytes(data[i + 8..i + 12].try_into().unwrap());

        if x.is_finite() && y.is_finite() && z.is_finite()
            && x.abs() < 10000.0
            && y.abs() < 10000.0
            && z.abs() < 10000.0
        {
            println!("Vec3 @ {:#X}: ({:.2}, {:.2}, {:.2})", i, x, y, z);
        }

        i += 4;
    }
}
