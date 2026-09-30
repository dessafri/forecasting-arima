import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import Modul1ManajemenDatasetUploadExcel from '../views/Modul1ManajemenDatasetUploadExcel.vue'

vi.mock('vue-router', () => ({
  useRouter: () => ({
    push: vi.fn()
  })
}))

describe('Modul1ManajemenDatasetUploadExcel View', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('renders upload dropzone and empty state when no dataset uploaded', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        stats: [],
        commodities: []
      })
    })

    const wrapper = mount(Modul1ManajemenDatasetUploadExcel, {
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

    expect(wrapper.text()).toContain('Modul 1: Manajemen Dataset & Ingesti Data Excel')
    expect(wrapper.text()).toContain('Upload File Excel')
    expect(wrapper.text()).toContain('Belum ada dataset yang diunggah')
  })

  it('renders statistics table when dataset is loaded', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        stats: [
          {
            komoditas: 'Beras Premium',
            n: 90,
            mean: 14500.0,
            std: 150.0,
            min: 14200.0,
            max: 14800.0,
            cv: 1.03,
            satuan: 'Kilogram (kg)',
            status: 'Valid (Lolos ARIMA)'
          }
        ],
        commodities: ['Beras Premium']
      })
    })

    const wrapper = mount(Modul1ManajemenDatasetUploadExcel, {
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
    expect(wrapper.text()).toContain('14.500')
    expect(wrapper.text()).toContain('Valid (Lolos ARIMA)')
  })
})
