import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import Modul2ForecastingArimaEvaluasiNutricast2 from '../views/Modul2ForecastingArimaEvaluasiNutricast2.vue'

vi.mock('vue-router', () => ({
  useRouter: () => ({
    push: vi.fn()
  })
}))

describe('Modul2ForecastingArimaEvaluasiNutricast2 View', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('renders diagnostic view and evaluations properly', async () => {
    const wrapper = mount(Modul2ForecastingArimaEvaluasiNutricast2, {
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

    expect(wrapper.text()).toContain('Modul 2: Time Series Forecasting ARIMA & Evaluasi Diagnostik')
    expect(wrapper.text()).toContain('Jalankan Auto-ARIMA Grid Search')
    expect(wrapper.text()).toContain('Ekspor Parameter (.JSON)')
  })
})
