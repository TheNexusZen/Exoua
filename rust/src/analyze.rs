use std::fs;
use std::io::Read;
use flate2::read::GzDecoder;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();
    
    let input_file = if args.len() > 1 {
        &args[1]
    } else {
        "ALLOBJS EXO.exolvl"
    };

    println!("=== Analyzing: {} ===\n", input_file);
    
    // Read compressed file
    let compressed = fs::read(input_file)?;
    println!("Compressed size: {} bytes", compressed.len());
    println!("First 32 bytes (hex):");
    print_hex(&compressed[..compressed.len().min(32)]);
    
    // Try to decompress
    println!("\nAttempting to decompress with gzip...");
    let mut decoder = GzDecoder::new(&compressed[..]);
    let mut decompressed = Vec::new();
    
    match decoder.read_to_end(&mut decompressed) {
        Ok(_) => {
            println!("✓ Successfully decompressed!");
            println!("Decompressed size: {} bytes\n", decompressed.len());
            
            println!("=== Binary Structure Analysis ===\n");
            
            // Analyze the decompressed data
            if decompressed.len() >= 4 {
                println!("First 4 bytes (possible magic number):");
                let magic = u32::from_le_bytes([
                    decompressed[0], 
                    decompressed[1], 
                    decompressed[2], 
                    decompressed[3]
                ]);
                println!("  Little-endian u32: 0x{:08X} ({})", magic, magic);
                println!("  As ASCII: '{}'", 
                    String::from_utf8_lossy(&decompressed[0..4]));
                println!("  Big-endian u32: 0x{:08X}", u32::from_be_bytes([
                    decompressed[0], 
                    decompressed[1], 
                    decompressed[2], 
                    decompressed[3]
                ]));
                println!();
            }
            
            if decompressed.len() >= 8 {
                println!("Bytes 4-7 (possible version):");
                let version = u32::from_le_bytes([
                    decompressed[4], 
                    decompressed[5], 
                    decompressed[6], 
                    decompressed[7]
                ]);
                println!("  Little-endian u32: {} (0x{:08X})", version, version);
                println!();
            }
            
            println!("All bytes (hex dump):");
            print_hex(&decompressed);
            
            println!("\n=== Interpretation Attempts ===\n");
            
            // Try to find patterns
            analyze_patterns(&decompressed);
            
            // Save decompressed to file
            let output_file = format!("{}.raw", input_file);
            fs::write(&output_file, &decompressed)?;
            println!("\n✓ Raw data saved to: {}", output_file);
            
        }
        Err(e) => {
            println!("✗ Failed to decompress: {}", e);
            println!("\nFile might not be gzip compressed, or is corrupted.");
            println!("\nRaw bytes (hex dump):");
            print_hex(&compressed);
        }
    }
    
    Ok(())
}

fn print_hex(data: &[u8]) {
    for (i, chunk) in data.chunks(16).enumerate() {
        print!("{:08X}  ", i * 16);
        
        // Hex bytes
        for (j, byte) in chunk.iter().enumerate() {
            print!("{:02X} ", byte);
            if j == 7 { print!(" "); }
        }
        
        // Padding
        for _ in chunk.len()..16 {
            print!("   ");
            if chunk.len() <= 8 { print!(" "); }
        }
        
        // ASCII
        print!(" |");
        for byte in chunk {
            let c = if byte.is_ascii_graphic() || *byte == b' ' {
                *byte as char
            } else {
                '.'
            };
            print!("{}", c);
        }
        println!("|");
    }
}

fn analyze_patterns(data: &[u8]) {
    println!("Looking for string patterns...");
    
    // Look for length-prefixed strings (u32 length followed by UTF-8 data)
    let mut offset = 0;
    while offset + 4 < data.len() {
        let len = u32::from_le_bytes([
            data[offset], 
            data[offset+1], 
            data[offset+2], 
            data[offset+3]
        ]) as usize;
        
        if len > 0 && len < 1000 && offset + 4 + len <= data.len() {
            let string_data = &data[offset+4..offset+4+len];
            if let Ok(s) = std::str::from_utf8(string_data) {
                if s.chars().all(|c| c.is_ascii_graphic() || c.is_whitespace()) {
                    println!("  Offset {:#X}: String (len={}): \"{}\"", 
                             offset, len, s);
                }
            }
        }
        offset += 1;
    }
    
    println!("\nLooking for float patterns (positions/sizes)...");
    offset = 0;
    while offset + 12 < data.len() {
        let x = f32::from_le_bytes([
            data[offset], 
            data[offset+1], 
            data[offset+2], 
            data[offset+3]
        ]);
        let y = f32::from_le_bytes([
            data[offset+4], 
            data[offset+5], 
            data[offset+6], 
            data[offset+7]
        ]);
        let z = f32::from_le_bytes([
            data[offset+8], 
            data[offset+9], 
            data[offset+10], 
            data[offset+11]
        ]);
        
        // Check if values look reasonable for coordinates
        if x.is_finite() && y.is_finite() && z.is_finite() &&
           x.abs() < 10000.0 && y.abs() < 10000.0 && z.abs() < 10000.0 {
            println!("  Offset {:#X}: Vec3({:.2}, {:.2}, {:.2})", 
                     offset, x, y, z);
        }
        offset += 4;
    }
          }
