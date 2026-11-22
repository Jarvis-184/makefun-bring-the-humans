import { copyFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

// Get directories from environment variables
const botDir = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const outputDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

try {
    // Ensure output directory exists
    mkdirSync(outputDir, { recursive: true });

    // Source and destination paths
    const src = join(botDir, 'VIDEO.json');
    const dest = join(outputDir, 'VIDEO.json');

    // Copy the file
    copyFileSync(src, dest);
    console.log(`Successfully copied ${src} to ${dest}`);
} catch (err) {
    // Print error to stderr and exit
    console.error('Error copying VIDEO.json:', err instanceof Error ? err.message : err);
    process.exit(1);
}
// Main logic completed
