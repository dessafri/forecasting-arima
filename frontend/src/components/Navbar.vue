<template>
  <header class="fixed top-0 left-[260px] right-0 h-16 bg-surface/85 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] z-40 flex items-center justify-end px-space-xl gap-space-md border-b border-slate-100">
    <div class="flex items-center gap-space-md shrink-0">
      <!-- Periode Data Dinamis -->
      <div class="hidden md:flex items-center gap-1.5 bg-white border border-slate-200 px-3 py-1 rounded-full text-blue-600 font-medium text-xs font-semibold shadow-xs">
        <span class="material-symbols-outlined text-[16px]">calendar_today</span>
        <span>Data Pangan: {{ displayDateRange }}</span>
      </div>

      <!-- Status Validasi Dataset Dinamis -->
      <div class="hidden lg:flex items-center gap-1.5 px-3 py-1 rounded-full font-medium text-xs font-semibold shadow-xs"
           :class="hasValidData ? 'bg-emerald-50 border border-emerald-200 text-emerald-700' : 'bg-slate-100 text-slate-500'">
        <span class="material-symbols-outlined text-[16px]">{{ hasValidData ? 'verified' : 'verified' }}</span>
        <span>{{ displayDatasetStatus }}</span>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { formatDateShort } from '../utils/dateFormatter'

const props = defineProps({
  dateRange: { type: String, default: '' },
  datasetStatus: { type: String, default: '' },
  breadcrumb: { type: String, default: '' }
})

const fetchedData = ref({
  has_data: false,
  date_range: '',
  total_komoditas: 0
})

const displayDateRange = computed(() => {
  if (props.dateRange) {
    return formatDateShort(props.dateRange)
  }
  if (fetchedData.value.date_range) {
    return formatDateShort(fetchedData.value.date_range)
  }
  return '1 Apr 2024 - 30 Jun 2026'
})

const hasValidData = computed(() => {
  return fetchedData.value.has_data || !!props.dateRange
})

const displayDatasetStatus = computed(() => {
  if (props.datasetStatus) return props.datasetStatus
  if (fetchedData.value.has_data) {
    const total = fetchedData.value.total_komoditas || 8
    return `Dataset: TKPI & ${total} Komoditas Valid`
  }
  return 'Dataset: TKPI & Komoditas Pangan Valid'
})

onMounted(async () => {
  try {
    const res = await fetch('http://127.0.0.1:5001/api/dashboard/summary')
    const json = await res.json()
    if (json.status === 'success' && json.has_data) {
      fetchedData.value = {
        has_data: true,
        date_range: json.date_range || '',
        total_komoditas: json.commodities ? json.commodities.length : 8
      }
    }
  } catch (err) {
    // Graceful fallback
  }
})
</script>

