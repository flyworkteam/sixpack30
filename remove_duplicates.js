const fs = require('fs');

const analyzeOutput = fs.readFileSync('analyze_output.txt', 'utf16le');
const linesToRemove = [];

const regex = /error - translations\.dart:(\d+):\d+ - Two keys in a constant map literal can't be equal/g;
let match;
while ((match = regex.exec(analyzeOutput)) !== null) {
  linesToRemove.push(parseInt(match[1], 10));
}

if (linesToRemove.length === 0) {
  console.log('No duplicate keys found in analyze_output.txt');
  process.exit(0);
}

// Sort in descending order to avoid shifting line numbers when deleting
linesToRemove.sort((a, b) => b - a);

console.log(`Found ${linesToRemove.length} lines to remove:`, linesToRemove);

let dartFile = fs.readFileSync('lib/Core/Localization/translations.dart', 'utf8');
const dartLines = dartFile.split('\n');

for (const lineNum of linesToRemove) {
  console.log(`Removing line ${lineNum}: ${dartLines[lineNum - 1]}`);
  dartLines.splice(lineNum - 1, 1);
}

fs.writeFileSync('lib/Core/Localization/translations.dart', dartLines.join('\n'));
console.log('Successfully removed duplicate lines.');
