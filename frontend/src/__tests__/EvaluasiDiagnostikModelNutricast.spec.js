import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import EvaluasiDiagnostikModelNutricast from '../views/EvaluasiDiagnostikModelNutricast.vue'

vi.mock('vue-router', () => ({
  useRouter: () => ({
    push: vi.fn()
  })
}))

describe('EvaluasiDiagnostikModelNutricast View', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('renders model diagnostics, residual analysis, and hypothesis testing cards', async () => {
    const wrapper = mount(EvaluasiDiagnostikModelNutricast, {
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

    expect(wrapper.text()).toContain('Evaluasi, Diagnostik Model & Validasi Saintifik')
    expect(wrapper.text()).toContain('Ljung-Box')
    expect(wrapper.text()).toContain('Distribusi Residual vs Kurva Normalitas Gauss')
  })
})
