const fs = require('fs');

const analyzeOutput = fs.readFileSync('analyze_output.txt', 'utf16le');
const lineNumbers = new Set();
const regex = /error - translations\.dart:(\d+):\d+ - /g;
let match;
while ((match = regex.exec(analyzeOutput)) !== null) {
  lineNumbers.add(parseInt(match[1], 10));
}

let dartFile = fs.readFileSync('lib/Core/Localization/translations.dart', 'utf8');
const dartLines = dartFile.split('\n');

const sortedLines = Array.from(lineNumbers).sort((a, b) => a - b);
for (const lineNum of sortedLines) {
  console.log(`${lineNum}: ${dartLines[lineNum - 1]}`);
}
