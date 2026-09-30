import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import Modul2ForecastingArimaEvaluasiNutricast1 from '../views/Modul2ForecastingArimaEvaluasiNutricast1.vue'

vi.mock('vue-router', () => ({
  useRouter: () => ({
    push: vi.fn()
  })
}))

describe('Modul2ForecastingArimaEvaluasiNutricast1 View', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('renders empty state when no dataset exists in backend', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: false,
        commodities: [],
        chart_series: [],
        kpi: {}
      })
    })

    const wrapper = mount(Modul2ForecastingArimaEvaluasiNutricast1, {
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

    expect(wrapper.text()).toContain('Dataset Belum Tersedia')
    expect(wrapper.text()).toContain('Buka Modul 1: Unggah Dataset')
  })

  it('renders commodities and grid search options when dataset is present', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: true,
        commodities: [
          {
            id: 'beras',
            name: 'Beras Premium',
            latest_price: 14500,
            volatility: 1.25,
            color: '#006948'
          }
        ],
        chart_series: [
          {
            id: 'beras',
            name: 'Beras Premium',
            color: '#006948',
            history: [14000, 14200, 14500],
            forecast: [14600, 14700]
          }
        ],
        kpi: {
          total_komoditas: 1,
          avg_mape: 2.15
        }
      })
    })

    const wrapper = mount(Modul2ForecastingArimaEvaluasiNutricast1, {
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

    expect(wrapper.text()).toContain('Beras Premium')
    expect(wrapper.text()).toContain('Jalankan Auto-ARIMA Grid Search')
  })
})
