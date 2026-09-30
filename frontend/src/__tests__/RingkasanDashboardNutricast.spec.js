import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import RingkasanDashboardNutricast from '../views/RingkasanDashboardNutricast.vue'

// Mock useRouter
vi.mock('vue-router', () => ({
  useRouter: () => ({
    push: vi.fn()
  })
}))

describe('RingkasanDashboardNutricast View', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('renders empty state banner when no data is available in backend', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: false,
        commodities: [],
        chart_series: [],
        kpi: {},
        pmt_menu: []
      })
    })

    const wrapper = mount(RingkasanDashboardNutricast, {
      global: {
        stubs: {
          Sidebar: true,
          Navbar: true,
          BaseButton: {
            template: '<button><slot /></button>'
          },
          'router-link': {
            template: '<a><slot /></a>'
          }
        }
      }
    })

    await flushPromises()

    expect(wrapper.text()).toContain('Dataset Belum Diunggah')
    expect(wrapper.text()).toContain('Buka Modul 1: Unggah Dataset')
  })

  it('renders dashboard with dynamic KPI cards and tables when data is available', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: true,
        commodities: [
          {
            id: 'beras',
            name: 'Beras Premium',
            latest_price: 14500,
            color: '#006948',
            volatility: 1.25,
            fpr_pattern: 'Stabil',
            gwo_action: 'Porsi Pokok'
          }
        ],
        chart_series: [
          {
            id: 'beras',
            name: 'Beras Premium',
            color: '#006948',
            points: [
              { x: 0, date: '2024-01-01', price: 14000, pct_change: 0, is_forecast: false },
              { x: 1, date: '2024-01-02', price: 14200, pct_change: 1.4, is_forecast: false },
              { x: 2, date: '2024-01-03', price: 14500, pct_change: 3.5, is_forecast: false },
              { x: 3, date: '2024-01-04', price: 14600, pct_change: 4.2, is_forecast: true, ci_upper: 14800, ci_lower: 14400 }
            ],
            history: [14000, 14200, 14500],
            forecast: [14600],
            ci_upper: [14800],
            ci_lower: [14400],
            dates: ['Jan', 'Feb', 'Mar', 'Apr']
          }
        ],
        kpi: {
          total_komoditas: 1,
          total_hari: 3,
          start_date: '2024-01-01',
          end_date: '2024-03-01',
          avg_mape: 2.62,
          pmt_cost: 8450,
          energy_pct: 98.4
        },
        pmt_menu: [
          {
            name: 'Beras Premium Pulen',
            gram: 65,
            cost: 932,
            cost_pct: 11.0,
            nutrients: 'Energi: 234 kkal'
          }
        ]
      })
    })

    const wrapper = mount(RingkasanDashboardNutricast, {
      global: {
        stubs: {
          Sidebar: true,
          Navbar: true,
          BaseButton: {
            template: '<button><slot /></button>'
          },
          'router-link': {
            template: '<a><slot /></a>'
          }
        }
      }
    })

    await flushPromises()

    expect(wrapper.text()).toContain('Beras Premium')
    expect(wrapper.text()).toContain('Proyeksi Tren Harga Komoditas Pangan (ARIMA)')
    expect(wrapper.text()).toContain('Tabel Klasifikasi Tren Finansial (FPR)')
  })
})
