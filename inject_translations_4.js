const fs = require('fs');

const file = 'c:/Users/user/Desktop/Yeni klasör/sixpack30-main/lib/Core/Localization/translations.dart';
let content = fs.readFileSync(file, 'utf8');

const additions = {
  tr: {
    hour: 'Saat',
    hours: 'Saat',
    fat_status_low: 'Az',
    fat_status_normal: 'Normal',
    fat_status_high: 'Fazla',
    data_load_error: 'Veri yüklenemedi: ',
  },
  en: {
    hour: 'Hour',
    hours: 'Hours',
    fat_status_low: 'Low',
    fat_status_normal: 'Normal',
    fat_status_high: 'High',
    data_load_error: 'Data load error: ',
  },
  es: {
    hour: 'Hora',
    hours: 'Horas',
    fat_status_low: 'Bajo',
    fat_status_normal: 'Normal',
    fat_status_high: 'Alto',
    data_load_error: 'Error de carga de datos: ',
  },
  pt: {
    hour: 'Hora',
    hours: 'Horas',
    fat_status_low: 'Baixo',
    fat_status_normal: 'Normal',
    fat_status_high: 'Alto',
    data_load_error: 'Erro no carregamento de dados: ',
  },
  fr: {
    hour: 'Heure',
    hours: 'Heures',
    fat_status_low: 'Bas',
    fat_status_normal: 'Normal',
    fat_status_high: 'Élevé',
    data_load_error: 'Erreur de chargement des données: ',
  },
  it: {
    hour: 'Ora',
    hours: 'Ore',
    fat_status_low: 'Basso',
    fat_status_normal: 'Normale',
    fat_status_high: 'Alto',
    data_load_error: 'Errore di caricamento dati: ',
  },
  de: {
    hour: 'Stunde',
    hours: 'Stunden',
    fat_status_low: 'Niedrig',
    fat_status_normal: 'Normal',
    fat_status_high: 'Hoch',
    data_load_error: 'Datenladefehler: ',
  },
  ru: {
    hour: 'Час',
    hours: 'Часа',
    fat_status_low: 'Низкий',
    fat_status_normal: 'Нормальный',
    fat_status_high: 'Высокий',
    data_load_error: 'Ошибка загрузки данных: ',
  },
  ja: {
    hour: '時間',
    hours: '時間',
    fat_status_low: '低い',
    fat_status_normal: '正常',
    fat_status_high: '高い',
    data_load_error: 'データの読み込みエラー: ',
  },
  ko: {
    hour: '시간',
    hours: '시간',
    fat_status_low: '낮음',
    fat_status_normal: '보통',
    fat_status_high: '높음',
    data_load_error: '데이터 로드 오류: ',
  },
  hi: {
    hour: 'घंटा',
    hours: 'घंटे',
    fat_status_low: 'कम',
    fat_status_normal: 'सामान्य',
    fat_status_high: 'उच्च',
    data_load_error: 'डेटा लोड त्रुटि: ',
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

fs.writeFileSync(file, content);
console.log('Phase 3 (Progress View) Translations updated successfully.');
