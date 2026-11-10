import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import { createRouter, createMemoryHistory } from 'vue-router'
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
    expect(wrapper.text()).toContain('Data Pangan:')
    expect(wrapper.text()).toContain('Dataset:')
  })
})

describe('Sidebar Component', () => {
  async function mountSidebar(path) {
    const router = createRouter({
      history: createMemoryHistory(),
      routes: [
        { path: '/dashboard', alias: '/', name: 'Dashboard', component: { template: '<div />' } },
        { path: '/modul-1', name: 'Modul1Dataset', component: { template: '<div />' } },
        { path: '/modul-2', name: 'Modul2Forecasting', component: { template: '<div />' } },
        { path: '/modul-2/evaluasi', name: 'Modul2Evaluasi', component: { template: '<div />' } }
      ]
    })
    await router.push(path)
    await router.isReady()
    return mount(Sidebar, {
      global: {
        plugins: [router],
        stubs: {
          'router-link': {
            props: ['to'],
            template: '<a :data-to="to"><slot /></a>'
          }
        }
      }
    })
  }

  it('renders sidebar brand and navigation links', async () => {
    const wrapper = await mountSidebar('/dashboard')
    expect(wrapper.text()).toContain('NutriCast')
    expect(wrapper.text()).toContain('Modul 1: Manajemen Dataset')
    expect(wrapper.text()).toContain('Modul 2: Forecasting ARIMA')
    expect(wrapper.text()).toContain('Modul 3: Financial Pattern (FPR)')
    expect(wrapper.text()).toContain('Modul 4: Optimasi GWO')
    expect(wrapper.text()).toContain('Modul 5: Menu PMT & Export')
  })

  it('gives the current sidebar item an active background', async () => {
    const wrapper = await mountSidebar('/modul-2')

    const modul2 = wrapper.findAll('a').find(link => link.text().includes('Modul 2'))
    const dashboard = wrapper.findAll('a').find(link => link.text().includes('Ringkasan'))

    expect(modul2.attributes('aria-current')).toBe('page')
    expect(modul2.classes()).toContain('bg-blue-50')
    expect(modul2.classes()).toContain('text-blue-700')
    expect(dashboard.classes()).not.toContain('bg-blue-50')
    expect(wrapper.find('summary').classes()).toContain('bg-blue-50')
  })

  it('keeps Modul 2 active on its evaluation route', async () => {
    const wrapper = await mountSidebar('/modul-2/evaluasi')
    const modul2 = wrapper.findAll('a').find(link => link.text().includes('Modul 2'))
    expect(modul2.attributes('aria-current')).toBe('page')
    expect(modul2.classes()).toContain('bg-blue-50')
  })
})
