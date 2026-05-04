const fs = require('fs');

const file = 'c:/Users/user/Desktop/Yeni klasör/sixpack30-main/lib/Core/Localization/translations.dart';
let content = fs.readFileSync(file, 'utf8');

const additions = {
  tr: {
    total_lbl: 'toplam',
    right_left_lbl: 'sağ + sol',
    both_sides_lbl: 'her iki taraf',
  },
  en: {
    total_lbl: 'total',
    right_left_lbl: 'right + left',
    both_sides_lbl: 'both sides',
  },
  es: {
    total_lbl: 'total',
    right_left_lbl: 'derecha + izquierda',
    both_sides_lbl: 'ambos lados',
  },
  pt: {
    total_lbl: 'total',
    right_left_lbl: 'direita + esquerda',
    both_sides_lbl: 'ambos os lados',
  },
  fr: {
    total_lbl: 'total',
    right_left_lbl: 'droite + gauche',
    both_sides_lbl: 'des deux côtés',
  },
  it: {
    total_lbl: 'totale',
    right_left_lbl: 'destra + sinistra',
    both_sides_lbl: 'entrambi i lati',
  },
  de: {
    total_lbl: 'gesamt',
    right_left_lbl: 'rechts + links',
    both_sides_lbl: 'beide Seiten',
  },
  ru: {
    total_lbl: 'всего',
    right_left_lbl: 'правая + левая',
    both_sides_lbl: 'обе стороны',
  },
  ja: {
    total_lbl: '合計',
    right_left_lbl: '右 + 左',
    both_sides_lbl: '両側',
  },
  ko: {
    total_lbl: '총',
    right_left_lbl: '오른쪽 + 왼쪽',
    both_sides_lbl: '양쪽',
  },
  hi: {
    total_lbl: 'कुल',
    right_left_lbl: 'दाएं + बाएं',
    both_sides_lbl: 'दोनों तरफ',
  }
};

for (const [lang, keys] of Object.entries(additions)) {
  let toAdd = "";
  for (const [k, v] of Object.entries(keys)) {
    toAdd += `      '${k}': '${v.replace(/'/g, "\\'")}',\n`;
  }
  
  const regex = new RegExp(`('${lang}': \\{[\\s\\S]*?)(\\n\\s*\\},?\\n(?:\\s*'|\\s*\\}\\s*;))`, 'm');
  content = content.replace(regex, `$1\n${toAdd}$2`);
}

// Replace the hardcoded English in translateSets
content = content.replace(
  "translated = translated.replaceAll('toplam', 'total');",
  "translated = translated.replaceAll('toplam', translate('total_lbl', langCode));"
).replace(
  "translated = translated.replaceAll('sağ + sol', 'right + left');",
  "translated = translated.replaceAll('sağ + sol', translate('right_left_lbl', langCode));"
).replace(
  "translated = translated.replaceAll('her iki taraf', 'both sides');",
  "translated = translated.replaceAll('her iki taraf', translate('both_sides_lbl', langCode));"
);

fs.writeFileSync(file, content);
console.log('Sets Translations updated successfully.');
