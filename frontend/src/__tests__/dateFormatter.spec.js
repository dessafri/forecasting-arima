import { describe, it, expect } from 'vitest'
import { formatDateString, formatDateShort, formatDateRange } from '../utils/dateFormatter'

describe('dateFormatter Utility', () => {
  it('formats YYYY-MM-DD date into "DD MMMM YYYY" string (e.g. 12 Januari 2026)', () => {
    expect(formatDateString('2026-01-12')).toBe('12 Januari 2026')
    expect(formatDateString('2026-07-10')).toBe('10 Juli 2026')
    expect(formatDateString('2024-03-05')).toBe('5 Maret 2024')
    expect(formatDateString('2024-12-31')).toBe('31 Desember 2024')
  })

  it('formats date with timestamp properly', () => {
    expect(formatDateString('2026-01-12 00:00:00')).toBe('12 Januari 2026')
    expect(formatDateString('2026-07-10T14:30:00Z')).toBe('10 Juli 2026')
  })

  it('formats date range string properly', () => {
    expect(formatDateRange('2024-01-01 s/d 2024-03-31')).toBe('1 Januari 2024 s/d 31 Maret 2024')
    expect(formatDateRange('2026-01-01 - 2026-01-12')).toBe('1 Januari 2026 - 12 Januari 2026')
  })

  it('formats short month format properly', () => {
    expect(formatDateShort('2026-01-12')).toBe('12 Jan 2026')
    expect(formatDateShort('2026-07-10')).toBe('10 Jul 2026')
  })

  it('handles non-date strings gracefully', () => {
    expect(formatDateString('T+5')).toBe('T+5')
    expect(formatDateString('Hari Ini')).toBe('Hari Ini')
    expect(formatDateString('')).toBe('')
    expect(formatDateString(null)).toBe('')
    expect(formatDateString(undefined)).toBe('')
  })
})
