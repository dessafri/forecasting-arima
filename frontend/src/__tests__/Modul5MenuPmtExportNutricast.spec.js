import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import Modul5MenuPmtExportNutricast from '../views/Modul5MenuPmtExportNutricast.vue'

vi.mock('vue-router', () => ({
  useRouter: () => ({
    push: vi.fn()
  })
}))

describe('Modul5MenuPmtExportNutricast View', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('renders empty state banner when no dataset in backend', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: false,
        pmt_menu: [],
        kpi: {}
      })
    })

    const wrapper = mount(Modul5MenuPmtExportNutricast, {
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

    expect(wrapper.text()).toContain('Dataset Belum Tersedia untuk Formulasi Menu PMT')
  })

  it('renders PMT recipe table and export actions when data exists', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: true,
        kpi: {
          estimasi_biaya: 8450,
          energi_tercapai: 1352
        },
        pmt_menu: [
          {
            name: 'Beras Premium Pulen',
            gram: 65,
            cost: 932,
            cost_pct: 11.0,
            nutrients: 'Energi: 234 kkal | Karbohidrat: 51.2 g'
          }
        ]
      })
    })

    const wrapper = mount(Modul5MenuPmtExportNutricast, {
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

    expect(wrapper.text()).toContain('Beras Premium Pulen')
    expect(wrapper.text()).toContain('Ekspor Rekap Excel (.xlsx)')
    expect(wrapper.text()).toContain('Cetak Lembar Menu PDF (.pdf)')
  })
})
