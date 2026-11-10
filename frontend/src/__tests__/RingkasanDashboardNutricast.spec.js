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

  function mountDashboard(chartSeries) {
    global.fetch = vi.fn().mockResolvedValue({
      json: () => Promise.resolve({
        status: 'success',
        has_data: true,
        commodities: chartSeries.map(series => ({
          id: series.id,
          name: series.name,
          latest_price: 14000,
          color: series.color,
          volatility: 1.2,
          fpr_pattern: 'Stabil',
          gwo_action: 'Porsi Pokok',
          return_pct: 0
        })),
        chart_series: chartSeries,
        kpi: { mape_avg: 2.6, estimasi_biaya: 8000, energi_tercapai: 1350, gwo_fitness: 0.01 },
        pmt_menu: []
      })
    })

    return mount(RingkasanDashboardNutricast, {
      global: {
        stubs: {
          Sidebar: true,
          Navbar: true,
          BaseButton: { template: '<button><slot /></button>' },
          'router-link': { template: '<a><slot /></a>' }
        }
      }
    })
  }

  it('shows the ARIMA price when a future forecast date is searched', async () => {
    const wrapper = mountDashboard([
      {
        id: 'beras',
        name: 'Beras Premium',
        color: '#006948',
        points: [
          { day: 0, date: '2026-09-14', price: 14200, pct_change: 0, type: 'historic', ci_lower: 14200, ci_upper: 14200 },
          { day: 1, date: '2026-09-15', price: 14600, pct_change: 2.8, type: 'forecast', ci_lower: 14200, ci_upper: 15000 }
        ]
      },
      {
        id: 'telur',
        name: 'Telur Ayam Ras',
        color: '#d97706',
        points: [
          { day: 0, date: '2026-09-14', price: 28000, pct_change: 0, type: 'historic', ci_lower: 28000, ci_upper: 28000 },
          { day: 1, date: '2026-09-15', price: 28650, pct_change: 2.3, type: 'forecast', ci_lower: 28100, ci_upper: 29200 }
        ]
      }
    ])

    await flushPromises()

    const input = wrapper.find('#forecast-date-search')
    await input.setValue('2026-09-15')
    await flushPromises()

    const results = wrapper.get('[data-testid="prediction-search-results"]')
    expect(results.text()).toContain('Hasil prediksi 15 September 2026')
    expect(results.text()).toContain('Beras Premium')
    expect(results.text()).toContain('Telur Ayam Ras')
    expect(results.text()).toMatch(/14[.,]600/)
    expect(results.text()).toMatch(/28[.,]650/)
    expect(results.text()).not.toContain('T+')
    const chartText = wrapper.find('svg').text()
    expect(chartText).toContain('15 Sep 2026')
    expect(chartText).toContain('14 Sep 2026')
    expect(chartText).not.toContain('Hari Ini')
    expect(chartText).not.toContain('T-15')
    expect(chartText).not.toContain('T+15')
  })

  it('resolves a T+ label from the last historic date', async () => {
    const wrapper = mountDashboard([
      {
        id: 'beras',
        name: 'Beras Premium',
        color: '#006948',
        points: [
          { day: 0, date: '2026-09-14', price: 14200, pct_change: 0, type: 'historic' },
          { day: 2, date: 'T+2', price: 15100, pct_change: 6.3, type: 'forecast', ci_lower: 14700, ci_upper: 15500 }
        ]
      }
    ])

    await flushPromises()
    await wrapper.find('#forecast-date-search').setValue('2026-09-16')
    await flushPromises()

    expect(wrapper.get('[data-testid="prediction-search-results"]').text()).toMatch(/15[.,]100/)
  })

  it('tells the user when the searched date is outside the forecast horizon', async () => {
    const wrapper = mountDashboard([
      {
        id: 'beras',
        name: 'Beras Premium',
        color: '#006948',
        points: [
          { day: 0, date: '2026-09-14', price: 14200, pct_change: 0, type: 'historic' },
          { day: 1, date: '2026-09-15', price: 14600, pct_change: 2.8, type: 'forecast', ci_lower: 14200, ci_upper: 15000 }
        ]
      }
    ])

    await flushPromises()
    await wrapper.find('#forecast-date-search').setValue('2026-12-01')
    await flushPromises()

    expect(wrapper.text()).toContain('berada di luar horizon prediksi')
    expect(wrapper.text()).toContain('15 September 2026')
    expect(wrapper.find('[data-testid="prediction-search-results"]').exists()).toBe(false)
  })

  it('clears the prediction result when reset is clicked', async () => {
    const wrapper = mountDashboard([
      {
        id: 'beras',
        name: 'Beras Premium',
        color: '#006948',
        points: [
          { day: 0, date: '2026-09-14', price: 14200, pct_change: 0, type: 'historic' },
          { day: 1, date: '2026-09-15', price: 14600, pct_change: 2.8, type: 'forecast', ci_lower: 14200, ci_upper: 15000 }
        ]
      }
    ])

    await flushPromises()
    await wrapper.find('#forecast-date-search').setValue('2026-09-15')
    await flushPromises()
    expect(wrapper.find('[data-testid="prediction-search-results"]').exists()).toBe(true)

    await wrapper.find('form button[type="button"]').trigger('click')
    await flushPromises()

    expect(wrapper.find('[data-testid="prediction-search-results"]').exists()).toBe(false)
    expect(wrapper.text()).toContain('Pilih tanggal ke depan dalam horizon')
  })
})
