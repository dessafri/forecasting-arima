import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import Modul3FinancialPatternFprNutricast from '../views/Modul3FinancialPatternFprNutricast.vue'

vi.mock('vue-router', () => ({
  useRouter: () => ({
    push: vi.fn()
  })
}))

describe('Modul3FinancialPatternFprNutricast View', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('renders empty state banner when no data in database', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: false,
        commodities: []
      })
    })

    const wrapper = mount(Modul3FinancialPatternFprNutricast, {
      global: {
        stubs: {
          Sidebar: true,
          Navbar: true,
          BaseButton: {
            template: '<button><slot /></button>'
          }
        }
      }
    })

    await flushPromises()

    expect(wrapper.text()).toContain('Dataset Belum Tersedia untuk Analisis FPR')
  })

  it('renders FPR matrix and commodity patterns when dataset exists', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: true,
        commodities: [
          {
            id: 'daging_ayam',
            name: 'Daging Ayam Ras',
            latest_price: 36000,
            volatility: 3.45,
            fpr_pattern: 'Bullish',
            gwo_action: 'Substitusi Parsial',
            color: '#ba1a1a'
          }
        ]
      })
    })

    const wrapper = mount(Modul3FinancialPatternFprNutricast, {
      global: {
        stubs: {
          Sidebar: true,
          Navbar: true,
          BaseButton: {
            template: '<button><slot /></button>'
          }
        }
      }
    })

    await flushPromises()

    expect(wrapper.text()).toContain('Daging Ayam Ras')
    expect(wrapper.text()).toContain('BULLISH (NAIK)')
    expect(wrapper.text()).toContain('Substitusi Parsial')
  })
})
