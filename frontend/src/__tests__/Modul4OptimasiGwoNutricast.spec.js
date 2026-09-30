import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import Modul4OptimasiGwoNutricast from '../views/Modul4OptimasiGwoNutricast.vue'

vi.mock('vue-router', () => ({
  useRouter: () => ({
    push: vi.fn()
  })
}))

describe('Modul4OptimasiGwoNutricast View', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('renders empty state banner when no data in backend', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: false,
        commodities: [],
        pmt_menu: [],
        kpi: {}
      })
    })

    const wrapper = mount(Modul4OptimasiGwoNutricast, {
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

    expect(wrapper.text()).toContain('Dataset Belum Tersedia untuk Optimasi GWO')
  })

  it('renders GWO convergence curve and rankings when dataset is present', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: true,
        commodities: [
          {
            id: 'ikan_kembung',
            name: 'Ikan Kembung Segar',
            latest_price: 38000,
            volatility: 1.15,
            color: '#006398'
          }
        ],
        pmt_menu: [
          {
            name: 'Ikan Kembung Kukus',
            gram: 40,
            cost: 1520,
            cost_pct: 18.0,
            nutrients: 'Protein: 8.5g'
          }
        ],
        kpi: {
          pmt_cost: 8450,
          energy_pct: 98.4
        }
      })
    })

    const wrapper = mount(Modul4OptimasiGwoNutricast, {
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

    expect(wrapper.text()).toContain('Visualisasi Kurva Konvergensi GWO')
    expect(wrapper.text()).toContain('Ikan Kembung Segar')
    expect(wrapper.find('svg').exists()).toBe(true)
  })
})
