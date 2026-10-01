/**
 * Helper utility to format ISO / YYYY-MM-DD date strings into human-readable Indonesian date strings
 * Example: '2026-07-10' -> '10 Juli 2026' (or '10 Jul 2026' if short)
 */

const MONTHS_ID_LONG = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
];

const MONTHS_ID_SHORT = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];

export function formatDateString(dateInput, format = 'long') {
  if (!dateInput && dateInput !== 0) return '';
  const str = String(dateInput).trim();
  if (!str) return '';

  // Handle date ranges like "2024-01-01 s/d 2024-03-31" or "2024-01-01 - 2024-03-31"
  if (str.includes(' s/d ')) {
    return str.split(' s/d ').map(p => formatDateString(p.trim(), format)).join(' s/d ');
  }
  if (str.includes(' - ') && /^\d{4}-\d{2}-\d{2}/.test(str)) {
    return str.split(' - ').map(p => formatDateString(p.trim(), format)).join(' - ');
  }

  // Handle YYYY-MM-DD or YYYY-MM-DDTHH:mm:ss
  const match = str.match(/^(\d{4})[-/](\d{1,2})[-/](\d{1,2})/);
  if (match) {
    const year = match[1];
    const monthIndex = parseInt(match[2], 10) - 1;
    const day = parseInt(match[3], 10);

    if (monthIndex >= 0 && monthIndex < 12) {
      const monthName = format === 'short' ? MONTHS_ID_SHORT[monthIndex] : MONTHS_ID_LONG[monthIndex];
      return `${day} ${monthName} ${year}`;
    }
  }

  // Return original text if not standard YYYY-MM-DD (e.g., 'T+5', 'Hari Ini')
  return str;
}

export function formatDateShort(dateInput) {
  return formatDateString(dateInput, 'short');
}

export function formatDateRange(rangeStr, format = 'long') {
  return formatDateString(rangeStr, format);
}
