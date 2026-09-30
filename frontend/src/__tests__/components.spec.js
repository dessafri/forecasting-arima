import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import BaseButton from '../components/BaseButton.vue'
import MetricCard from '../components/MetricCard.vue'
import Navbar from '../components/Navbar.vue'
import Sidebar from '../components/Sidebar.vue'

describe('BaseButton Component', () => {
  it('renders default slot content', () => {
    const wrapper = mount(BaseButton, {
      slots: {
        default: 'Simpan Data'
      }
    })
    expect(wrapper.text()).toContain('Simpan Data')
    expect(wrapper.classes()).toContain('bg-blue-600')
  })

  it('renders secondary variant', () => {
    const wrapper = mount(BaseButton, {
      props: {
        variant: 'secondary'
      },
      slots: {
        default: 'Kembali'
      }
    })
    expect(wrapper.classes()).toContain('bg-slate-100')
  })

  it('renders outline variant', () => {
    const wrapper = mount(BaseButton, {
      props: {
        variant: 'outline'
      },
      slots: {
        default: 'Batal'
      }
    })
    expect(wrapper.classes()).toContain('border')
  })

  it('emits click event on click', async () => {
    const wrapper = mount(BaseButton, {
      slots: {
        default: 'Click Me'
      }
    })
    await wrapper.trigger('click')
    expect(wrapper.emitted()).toHaveProperty('click')
  })
})

describe('MetricCard Component', () => {
  it('renders title, value, and badge props properly', () => {
    const wrapper = mount(MetricCard, {
      props: {
        title: 'Total Anggaran',
        value: 'Rp 8.500.000',
        badge: 'Terkontrol'
      }
    })
    expect(wrapper.text()).toContain('Total Anggaran')
    expect(wrapper.text()).toContain('Rp 8.500.000')
    expect(wrapper.text()).toContain('Terkontrol')
  })

  it('renders value from slot if provided', () => {
    const wrapper = mount(MetricCard, {
      props: {
        title: 'Status Gizi'
      },
      slots: {
        value: 'Optimal 98.5%'
      }
    })
    expect(wrapper.text()).toContain('Optimal 98.5%')
  })
})

describe('Navbar Component', () => {
  it('renders navigation header items', () => {
    const wrapper = mount(Navbar)
    expect(wrapper.find('header').exists()).toBe(true)
    expect(wrapper.text()).toContain('Data Pangan: Jan 2024 - Mar 2024')
    expect(wrapper.text()).toContain('Dataset: TKPI & Komoditas Pangan Valid')
  })
})

describe('Sidebar Component', () => {
  it('renders sidebar brand and navigation links', () => {
    const wrapper = mount(Sidebar, {
      global: {
        stubs: {
          'router-link': {
            template: '<a><slot /></a>'
          }
        }
      }
    })
    expect(wrapper.text()).toContain('NutriCast')
    expect(wrapper.text()).toContain('Modul 1: Manajemen Dataset')
    expect(wrapper.text()).toContain('Modul 2: Forecasting ARIMA')
    expect(wrapper.text()).toContain('Modul 3: Financial Pattern (FPR)')
    expect(wrapper.text()).toContain('Modul 4: Optimasi GWO')
    expect(wrapper.text()).toContain('Modul 5: Menu PMT & Export')
  })
})
