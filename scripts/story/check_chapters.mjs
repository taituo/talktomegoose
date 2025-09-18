#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(new URL('..', import.meta.url).pathname, '..');
const outlinePath = path.join(root, 'templates', 'storyteller', 'outline.md');
const chaptersDir = path.join(root, 'templates', 'storyteller', 'chapters');

function readOutline() {
  if (!fs.existsSync(outlinePath)) {
    throw new Error(`Missing outline file at ${outlinePath}`);
  }
  return fs.readFileSync(outlinePath, 'utf-8');
}

function listChapters() {
  if (!fs.existsSync(chaptersDir)) {
    throw new Error(`Missing chapters directory at ${chaptersDir}`);
  }
  return fs
    .readdirSync(chaptersDir)
    .filter((name) => name.startsWith('chapter-') && name.endsWith('.md'))
    .sort();
}

function ensureChapterSections(chapterPath) {
  const content = fs.readFileSync(chapterPath, 'utf-8');
  const missing = [];
  if (!content.includes('## Summary')) missing.push('Summary');
  if (!content.includes('## Draft')) missing.push('Draft');
  if (!content.includes('## Revision Notes')) missing.push('Revision Notes');
  return missing;
}

function main() {
  const outline = readOutline();
  const chapterFiles = listChapters();

  const referencedChapters = new Set();
  const outlineLines = outline.split(/\r?\n/);
  const chapterRegex = /Chapter\s+(\d+)/i;

  for (const line of outlineLines) {
    const match = line.match(chapterRegex);
    if (match) {
      const index = Number.parseInt(match[1], 10);
      const file = `chapter-${String(index).padStart(2, '0')}.md`;
      referencedChapters.add(file);
    }
  }

  const missingFromOutline = chapterFiles.filter((file) => !referencedChapters.has(file));
  const missingSections = [];

  for (const file of chapterFiles) {
    const chapterPath = path.join(chaptersDir, file);
    const missing = ensureChapterSections(chapterPath);
    if (missing.length) {
      missingSections.push({ file, missing });
    }
  }

  if (!chapterFiles.length) {
    console.error('No chapter files found. Create templates/storyteller/chapters/chapter-01.md etc.');
    process.exit(1);
  }

  if (missingFromOutline.length || missingSections.length) {
    if (missingFromOutline.length) {
      console.error('Chapters missing from outline.md:');
      missingFromOutline.forEach((file) => console.error(`  - ${file}`));
    }
    if (missingSections.length) {
      console.error('Chapters missing required sections:');
      missingSections.forEach(({ file, missing }) =>
        console.error(`  - ${file}: ${missing.join(', ')}`)
      );
    }
    process.exit(1);
  }

  console.log(`Storyteller check passed: ${chapterFiles.length} chapters referenced in outline.`);
}

try {
  main();
} catch (error) {
  console.error('Storyteller check failed:', error.message);
  process.exit(1);
}
