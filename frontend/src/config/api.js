/**
 * API base for NutriCast. Use relative /api in dev (Vite proxy → Flask).
 * Override with VITE_API_BASE when the UI is not served behind the same proxy.
 */
const configured = (import.meta.env.VITE_API_BASE || '').replace(/\/$/, '')

export function apiUrl(path) {
  const normalized = path.startsWith('/') ? path : `/${path}`
  return configured ? `${configured}${normalized}` : normalized
}
