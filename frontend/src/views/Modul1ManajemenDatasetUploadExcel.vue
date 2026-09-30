<template>
<Sidebar /><div class="pl-[260px]"><Navbar breadcrumb="Modul 1: Manajemen Dataset" /><main class="relative pt-16 bg-slate-50 min-h-screen"><div class="flex flex-col w-full">
<div class="px-margin py-space-xl flex flex-col gap-space-xl max-w-[1600px] mx-auto w-full">
<!-- 1. Header Section & Action Toolbar -->
<section class="bg-white p-space-xl rounded-xl shadow-sm flex flex-col gap-space-xl">
<!-- Header Row -->
<div class="flex flex-col xl:flex-row xl:items-center justify-between gap-space-lg">
<div class="flex flex-col gap-space-xs max-w-4xl">
<h1 class="font-display-lg text-display-lg text-slate-900 tracking-tight" style="font-size: 20px; line-height: 28px;">Modul 1: Manajemen Dataset &amp; Ingesti Data Excel</h1>
</div>
<div class="flex flex-wrap items-center gap-space-sm self-start xl:self-center shrink-0">
<BaseButton variant="secondary" id="btnDownloadTemplate" @click="downloadTemplate">
<span class="material-symbols-outlined text-[18px]">download</span>
<span>Unduh Template Excel (.xlsx)</span>
</BaseButton>
<BaseButton variant="secondary" @click="handleUploadClick">
<span class="material-symbols-outlined text-[16px]">{{ isUploaded ? 'sync' : 'upload_file' }}</span>
<span>{{ isUploaded ? 'Sinkronisasi Ulang Data' : 'Upload File Excel' }}</span>
</BaseButton>
</div>
</div>

<hr class="border-slate-100" />

<!-- Uploaded Files List (3 Sheets: Harga Pangan, TKPI, AKG) -->
<div class="flex flex-col gap-space-lg">
<div class="flex items-center gap-space-xs">
<span class="material-symbols-outlined text-blue-500 text-[22px]">folder</span>
<h2 class="text-xl font-bold text-slate-900" style="font-size: 18px; line-height: 24px;">Dataset Excel Terunggah</h2>
</div>

<div v-if="isUploaded" class="grid grid-cols-1 md:grid-cols-3 gap-space-md">
<!-- Sheet 1: Harga Pangan -->
<div class="p-space-md bg-white border border-slate-100 rounded-lg flex items-center justify-between shadow-xs">
<div class="flex items-center gap-space-sm">
<div class="w-10 h-10 rounded-lg bg-primary/10 text-blue-600 flex items-center justify-center">
<span class="material-symbols-outlined text-[24px]">query_stats</span>
</div>
<div class="flex flex-col">
<span class="text-sm font-semibold text-slate-900">Sheet 1: Harga Pangan</span>
<span class="text-xs font-medium text-slate-500">{{ totalRowsHarga > 0 ? totalRowsHarga + ' baris deret waktu' : 'Tabel harga harian' }}</span>
</div>
</div>
<span class="px-2 py-1 rounded bg-primary/10 text-blue-600 font-label-sm font-semibold flex items-center gap-1 text-xs">
<span class="material-symbols-outlined text-[14px]">check_circle</span> Valid
</span>
</div>

<!-- Sheet 2: TKPI -->
<div class="p-space-md bg-white border border-slate-100 rounded-lg flex items-center justify-between shadow-xs">
<div class="flex items-center gap-space-sm">
<div class="w-10 h-10 rounded-lg bg-secondary/10 text-blue-500 flex items-center justify-center">
<span class="material-symbols-outlined text-[24px]">nutrition</span>
</div>
<div class="flex flex-col">
<span class="text-sm font-semibold text-slate-900">Sheet 2: TKPI 2020</span>
<span class="text-xs font-medium text-slate-500">{{ tkpiList.length > 0 ? tkpiList.length + ' item komoditas gizi' : 'Komposisi gizi pangan' }}</span>
</div>
</div>
<span class="px-2 py-1 rounded bg-primary/10 text-blue-600 font-label-sm font-semibold flex items-center gap-1 text-xs">
<span class="material-symbols-outlined text-[14px]">check_circle</span> Lengkap
</span>
</div>

<!-- Sheet 3: AKG -->
<div class="p-space-md bg-white border border-slate-100 rounded-lg flex items-center justify-between shadow-xs">
<div class="flex items-center gap-space-sm">
<div class="w-10 h-10 rounded-lg bg-amber-500/10 text-amber-600 flex items-center justify-center">
<span class="material-symbols-outlined text-[24px]">verified_user</span>
</div>
<div class="flex flex-col">
<span class="text-sm font-semibold text-slate-900">Sheet 3: Standar AKG</span>
<span class="text-xs font-medium text-slate-500">{{ akgList.length > 0 ? akgList.length + ' parameter target PMT' : 'Standar PMT balita' }}</span>
</div>
</div>
<span class="px-2 py-1 rounded bg-primary/10 text-blue-600 font-label-sm font-semibold flex items-center gap-1 text-xs">
<span class="material-symbols-outlined text-[14px]">check_circle</span> Terstandarisasi
</span>
</div>
</div>

<div v-else class="p-space-xl bg-slate-50 border border-dashed border-slate-200 rounded-lg flex flex-col items-center justify-center text-center">
<span class="material-symbols-outlined text-[32px] text-slate-400 mb-2">cloud_off</span>
<p class="text-sm font-semibold text-slate-600">Belum ada dataset yang diunggah</p>
<p class="text-xs text-slate-500 mt-1">Silakan klik "Upload File Excel" (mendukung Sheet 1: Harga Pangan, Sheet 2: TKPI, Sheet 3: AKG).</p>
</div>

<div v-if="isUploaded" class="flex justify-end mt-2">
<BaseButton variant="primary" id="btnProceedARIMA" @click="proceedToARIMA">
<span>Lanjut proses ke ARIMA</span>
<span class="material-symbols-outlined text-[20px]">arrow_forward</span>
</BaseButton>
</div>
</div>

<hr v-if="isUploaded" class="border-slate-100 my-space-md" />

<!-- 5. Tabel Statistik Deskriptif Komoditas Pangan Pokok -->
<div v-if="isUploaded" class="flex flex-col gap-space-lg">
<div class="flex flex-col lg:flex-row lg:items-center justify-between gap-space-md">
<div>
<div class="flex items-center gap-space-xs">
<span class="material-symbols-outlined text-blue-500 text-[22px]">bar_chart</span>
<h2 class="text-xl font-bold text-slate-900" style="font-size: 18px; line-height: 24px;">Statistik Deskriptif Komoditas Pangan Pokok</h2>
</div>
</div>
<div class="flex flex-wrap items-center gap-space-sm">
<div class="relative">
<span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-[18px] text-slate-500">filter_alt</span>
<input v-model="searchQuery" class="bg-white border border-slate-100 pl-9 pr-3 py-1.5 rounded-lg text-body-sm font-body-sm text-slate-900 outline-none w-56 focus:bg-surface-container" id="tableFilterInput" placeholder="Saring nama komoditas..." type="text">
</div>
<BaseButton variant="secondary" id="btnExportStats" @click="exportStats">
<span class="material-symbols-outlined text-[18px]">sim_card_download</span>
<span>Ekspor Ringkasan (.CSV)</span>
</BaseButton>
</div>
</div>

<!-- Descriptive Table Container -->
<div class="overflow-x-auto rounded-xl border border-slate-100">
<table class="w-full text-left text-xs whitespace-nowrap">
<thead>
<tr class="bg-white border-b border-slate-100 text-slate-900 font-headline-sm text-body-sm">
<th class="py-3 px-4 rounded-l-lg">Komoditas Pokok</th>
<th class="py-3 px-3">Satuan</th>
<th class="py-3 px-3 text-right">Data (N)</th>
<th class="py-3 px-3 text-right">Rata-rata (Mean)</th>
<th class="py-3 px-3 text-right">Standar Deviasi</th>
<th class="py-3 px-3 text-right">Harga Min</th>
<th class="py-3 px-3 text-right">Harga Max</th>
<th class="py-3 px-3 text-center">Volatilitas (CV)</th>
<th class="py-3 px-4 text-center rounded-r-lg">Integritas Data</th>
</tr>
</thead>
<tbody class="divide-y divide-surface-container text-slate-900 font-body-sm">
<tr v-for="(item, idx) in filteredStats" :key="idx" class="hover:bg-slate-50/80 transition-colors">
<td class="py-3 px-4 flex items-center gap-2">
<span class="w-3 h-3 rounded-full shrink-0" :style="{ backgroundColor: getColor(idx) }"></span>
<span class="font-headline-sm text-slate-900 font-medium">{{ item.komoditas }}</span>
</td>
<td class="py-3 px-3 text-slate-500">{{ item.satuan || 'Kilogram (kg)' }}</td>
<td class="py-3 px-3 text-right font-data-mono-sm">{{ item.n }}</td>
<td class="py-3 px-3 text-right font-data-mono-sm font-semibold text-blue-600">Rp {{ Number(item.mean).toLocaleString('id-ID') }}</td>
<td class="py-3 px-3 text-right font-data-mono-sm text-slate-500">Rp {{ Number(item.std).toLocaleString('id-ID') }}</td>
<td class="py-3 px-3 text-right font-data-mono-sm">Rp {{ Number(item.min).toLocaleString('id-ID') }}</td>
<td class="py-3 px-3 text-right font-data-mono-sm">Rp {{ Number(item.max).toLocaleString('id-ID') }}</td>
<td class="py-3 px-3 text-center font-data-mono-sm text-slate-700">{{ item.cv }}%</td>
<td class="py-3 px-4 text-center">
<span class="px-2 py-0.5 rounded bg-primary/10 text-blue-600 font-label-sm font-semibold">{{ item.status || 'Valid (Lolos ARIMA)' }}</span>
</td>
</tr>
<tr v-if="filteredStats.length === 0">
<td colspan="9" class="py-6 text-center text-slate-400">Tidak ada data komoditas yang sesuai.</td>
</tr>
</tbody>
</table>
</div>

<!-- Inline Chart / CV Indicator -->
<div class="bg-white border border-slate-100 p-space-md rounded-xl flex flex-col md:flex-row items-center justify-between gap-space-md shadow-xs">
<div class="flex items-center gap-space-sm">
<span class="material-symbols-outlined text-blue-500 text-[24px]">insights</span>
<span class="text-sm font-semibold text-slate-800">Koefisien Variasi (CV) Komoditas</span>
</div>
<div class="flex items-center gap-4 w-full md:w-auto overflow-x-auto py-1">
<div v-for="(item, idx) in statsList.slice(0, 6)" :key="idx" class="flex items-center gap-1.5 shrink-0">
<span class="w-2.5 h-2.5 rounded-full" :style="{ backgroundColor: getColor(idx) }"></span>
<span class="text-xs font-semibold text-slate-600">{{ item.komoditas.split(' ')[0] }} (CV: {{ item.cv }}%)</span>
</div>
</div>
</div>

<!-- Sheet Tabs Selector -->
<div class="flex items-center gap-2 border-b border-slate-200 pt-2">
<button @click="activeTab = 'sheet1'" :class="activeTab === 'sheet1' ? 'border-b-2 border-blue-600 text-blue-600 font-bold' : 'text-slate-500 hover:text-slate-800'" class="pb-2 px-3 text-sm font-medium flex items-center gap-1.5 transition-colors">
<span class="material-symbols-outlined text-[18px]">table_chart</span>
<span>Sheet 1: Harga Pangan (Deret Waktu)</span>
</button>
<button @click="activeTab = 'sheet2'" :class="activeTab === 'sheet2' ? 'border-b-2 border-blue-600 text-blue-600 font-bold' : 'text-slate-500 hover:text-slate-800'" class="pb-2 px-3 text-sm font-medium flex items-center gap-1.5 transition-colors">
<span class="material-symbols-outlined text-[18px]">nutrition</span>
<span>Sheet 2: Parameter Gizi (TKPI)</span>
</button>
<button @click="activeTab = 'sheet3'" :class="activeTab === 'sheet3' ? 'border-b-2 border-blue-600 text-blue-600 font-bold' : 'text-slate-500 hover:text-slate-800'" class="pb-2 px-3 text-sm font-medium flex items-center gap-1.5 transition-colors">
<span class="material-symbols-outlined text-[18px]">verified_user</span>
<span>Sheet 3: Standar AKG & Target PMT</span>
</button>
</div>

<!-- Preview Panel 1: Sheet 01 Harga Pangan -->
<div v-if="activeTab === 'sheet1'" class="overflow-x-auto rounded-xl border border-slate-100 shadow-xs" id="previewSheet1">
<table class="w-full text-left text-xs whitespace-nowrap">
<thead>
<tr class="bg-white border-b border-slate-100 text-slate-900 font-headline-sm text-body-sm">
<th class="py-2.5 px-4 rounded-l-lg">Tanggal</th>
<th v-for="col in commodityColumns" :key="col" class="py-2.5 px-3 text-right">{{ col }}</th>
</tr>
</thead>
<tbody class="divide-y divide-surface-container font-data-mono-sm text-slate-900">
<tr v-for="(row, idx) in previewHarga" :key="idx" class="hover:bg-slate-50 transition-colors" :class="idx === previewHarga.length - 1 ? 'bg-primary/5 font-semibold text-blue-600' : ''">
<td class="py-2.5 px-4 text-slate-900 font-medium">{{ row.Tanggal }} {{ idx === previewHarga.length - 1 ? '(Terakhir)' : '' }}</td>
<td v-for="col in commodityColumns" :key="col" class="py-2.5 px-3 text-right">
{{ Number(row[col] || 0).toLocaleString('id-ID') }}
</td>
</tr>
</tbody>
</table>
</div>

<!-- Preview Panel 2: Sheet 02 Parameter Gizi TKPI -->
<div v-if="activeTab === 'sheet2'" class="overflow-x-auto rounded-xl border border-slate-100 shadow-xs" id="previewSheet2">
<table class="w-full text-left text-xs whitespace-nowrap">
<thead>
<tr class="bg-white border-b border-slate-100 text-slate-900 font-headline-sm text-body-sm">
<th class="py-2.5 px-4 rounded-l-lg">Bahan Pangan (TKPI 2020)</th>
<th class="py-2.5 px-3 text-right">Energi (kkal)</th>
<th class="py-2.5 px-3 text-right">Protein (g)</th>
<th class="py-2.5 px-3 text-right">Lemak (g)</th>
<th class="py-2.5 px-3 text-right">Karbohidrat (g)</th>
<th class="py-2.5 px-3 text-right">Fe (mg)</th>
<th class="py-2.5 px-3 text-right">Zn (mg)</th>
<th class="py-2.5 px-4 text-center rounded-r-lg">Kesesuaian Standar PMT</th>
</tr>
</thead>
<tbody class="divide-y divide-surface-container font-data-mono-sm text-slate-900">
<tr v-for="(row, idx) in tkpiList" :key="idx" class="hover:bg-slate-50 transition-colors">
<td class="py-2.5 px-4 font-headline-sm text-slate-900 font-medium">{{ row['Komoditas'] }}</td>
<td class="py-2.5 px-3 text-right font-semibold">{{ row['Energi (kkal)'] }}</td>
<td class="py-2.5 px-3 text-right text-blue-600 font-bold">{{ row['Protein (g)'] }}</td>
<td class="py-2.5 px-3 text-right">{{ row['Lemak (g)'] }}</td>
<td class="py-2.5 px-3 text-right">{{ row['Karbohidrat (g)'] }}</td>
<td class="py-2.5 px-3 text-right">{{ row['Fe (mg)'] }}</td>
<td class="py-2.5 px-3 text-right">{{ row['Zn (mg)'] }}</td>
<td class="py-2.5 px-4 text-center"><span class="px-2 py-0.5 rounded bg-primary/10 text-blue-600 font-label-sm font-semibold">Validasi TKPI</span></td>
</tr>
</tbody>
</table>
</div>

<!-- Preview Panel 3: Sheet 03 AKG & Target PMT -->
<div v-if="activeTab === 'sheet3'" class="overflow-x-auto rounded-xl border border-slate-100 shadow-xs" id="previewSheet3">
<table class="w-full text-left text-xs whitespace-nowrap">
<thead>
<tr class="bg-white border-b border-slate-100 text-slate-900 font-headline-sm text-body-sm">
<th class="py-2.5 px-4 rounded-l-lg">Parameter Gizi</th>
<th class="py-2.5 px-4 text-right">AKG Harian</th>
<th class="py-2.5 px-4 text-right rounded-r-lg">Target PMT (25%)</th>
</tr>
</thead>
<tbody class="divide-y divide-surface-container font-data-mono-sm text-slate-900">
<tr v-for="(row, idx) in akgList" :key="idx" class="hover:bg-slate-50 transition-colors">
<td class="py-2.5 px-4 font-headline-sm text-slate-900 font-medium">{{ row['Parameter'] }}</td>
<td class="py-2.5 px-4 text-right font-semibold">{{ row['AKG Harian'] }}</td>
<td class="py-2.5 px-4 text-right text-blue-600 font-bold">{{ row['Target PMT (25%)'] }}</td>
</tr>
</tbody>
</table>
</div>

</div>
</section>
</div>
</div>
</main></div>

<!-- Upload Modal -->
<div v-if="showUploadModal" class="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/50 backdrop-blur-sm">
<div class="bg-white p-space-xl rounded-2xl shadow-xl max-w-md w-full mx-4 flex flex-col gap-space-lg">
<div class="flex items-center justify-between">
<h3 class="text-xl font-bold text-slate-900" style="font-size: 18px">Upload Dataset Excel (3 Sheet)</h3>
<BaseButton variant="ghost" @click="closeUploadModal">
<span class="material-symbols-outlined">close</span>
</BaseButton>
</div>

<div class="border-2 border-dashed border-slate-200 rounded-xl p-space-xl flex flex-col items-center justify-center gap-space-sm hover:bg-slate-50 transition-colors cursor-pointer" @click="$refs.fileInput.click()">
<div class="w-12 h-12 rounded-full bg-blue-50 text-blue-600 flex items-center justify-center">
<span class="material-symbols-outlined text-[28px]">cloud_upload</span>
</div>
<div class="text-center mt-2">
<p class="font-semibold text-slate-900" style="font-size: 14px">Tarik & letakkan file ke sini</p>
<p class="text-xs text-slate-500 mt-1">Sheet 1: Harga Pangan, Sheet 2: TKPI, Sheet 3: AKG (.xlsx)</p>
</div>
<input type="file" ref="fileInput" class="hidden" accept=".xlsx, .xls" @change="handleFileSelect">
</div>
</div>
</div>
</template>

<script setup>
import BaseButton from '../components/BaseButton.vue';
import Navbar from '../components/Navbar.vue';
import Sidebar from '../components/Sidebar.vue';
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isUploaded = ref(false)
const showUploadModal = ref(false)
const isUploading = ref(false)
const activeTab = ref('sheet1')
const searchQuery = ref('')

const statsList = ref([])
const commodityColumns = ref([])
const previewHarga = ref([])
const tkpiList = ref([])
const akgList = ref([])
const totalRowsHarga = ref(0)

const colors = ['#3b82f6', '#f97316', '#eab308', '#06b6d4', '#f59e0b', '#84cc16', '#10b981', '#ef4444', '#8b5cf6']
const getColor = (idx) => colors[idx % colors.length]

const filteredStats = computed(() => {
  if (!searchQuery.value) return statsList.value
  return statsList.value.filter(s => s.komoditas.toLowerCase().includes(searchQuery.value.toLowerCase()))
})

const fetchExistingData = async () => {
  try {
    const resStats = await fetch('http://127.0.0.1:5001/api/data/stats')
    const jsonStats = await resStats.json()
    if (jsonStats.status === 'success' && jsonStats.stats && jsonStats.stats.length > 0) {
      statsList.value = jsonStats.stats
      commodityColumns.value = jsonStats.commodities || []
      isUploaded.value = true

      const resHarga = await fetch('http://127.0.0.1:5001/api/data/harga_pangan')
      const jsonHarga = await resHarga.json()
      if (jsonHarga.status === 'success' && jsonHarga.data) {
        previewHarga.value = jsonHarga.data.slice(-5)
        totalRowsHarga.value = jsonHarga.data.length
      }

      const resTkpi = await fetch('http://127.0.0.1:5001/api/data/tkpi')
      const jsonTkpi = await resTkpi.json()
      if (jsonTkpi.status === 'success' && jsonTkpi.data) {
        tkpiList.value = jsonTkpi.data
      }

      const resAkg = await fetch('http://127.0.0.1:5001/api/data/akg')
      const jsonAkg = await resAkg.json()
      if (jsonAkg.status === 'success' && jsonAkg.data) {
        akgList.value = jsonAkg.data
      }
    } else {
      isUploaded.value = false
      statsList.value = []
      commodityColumns.value = []
      previewHarga.value = []
      tkpiList.value = []
      akgList.value = []
      totalRowsHarga.value = 0
    }
  } catch (err) {
    console.error('Error fetching initial dataset:', err)
    isUploaded.value = false
  }
}

onMounted(() => {
  fetchExistingData()
})

const handleUploadClick = () => {
  showUploadModal.value = true
}

const handleFileSelect = async (event) => {
  if (event.target.files && event.target.files.length > 0) {
    const file = event.target.files[0]
    const formData = new FormData()
    formData.append('file', file)

    isUploading.value = true
    try {
      const response = await fetch('http://127.0.0.1:5001/api/upload', {
        method: 'POST',
        body: formData,
      })
      const result = await response.json()
      if (result.status === 'success') {
        isUploaded.value = true
        showUploadModal.value = false
        if (result.stats) statsList.value = result.stats
        if (result.commodities) commodityColumns.value = result.commodities
        if (result.preview_harga) previewHarga.value = result.preview_harga
        if (result.preview_tkpi) tkpiList.value = result.preview_tkpi
        if (result.preview_akg) akgList.value = result.preview_akg
        if (result.total_rows_harga) totalRowsHarga.value = result.total_rows_harga
        alert(result.message)
      } else {
        alert('Gagal mengunggah file: ' + result.message)
      }
    } catch (error) {
      console.error(error)
      alert('Terjadi kesalahan saat mengunggah file.')
    } finally {
      isUploading.value = false
    }
  }
}

const closeUploadModal = () => {
  showUploadModal.value = false
}

const proceedToARIMA = async () => {
  try {
    const response = await fetch('http://127.0.0.1:5001/api/forecast', {
      method: 'POST'
    })
    const result = await response.json()
    if (result.status === 'success') {
      alert('Pemodelan ARIMA berhasil! Melanjutkan ke Modul 2.')
      router.push('/modul2_1')
    }
  } catch (error) {
    console.error(error)
    alert('Terjadi kesalahan saat menjalankan proses ARIMA.')
  }
}

const exportStats = () => {
  if (statsList.value.length === 0) return
  const headers = ['Komoditas', 'Satuan', 'N', 'Mean', 'Std Dev', 'Min', 'Max', 'CV (%)', 'Status']
  const rows = statsList.value.map(s => [
    s.komoditas, s.satuan || 'kg', s.n, s.mean, s.std, s.min, s.max, s.cv + '%', s.status
  ])
  const csvContent = 'data:text/csv;charset=utf-8,' + [headers.join(','), ...rows.map(r => r.join(','))].join('\n')
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement('a')
  link.setAttribute('href', encodedUri)
  link.setAttribute('download', 'statistik_deskriptif_komoditas.csv')
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

const downloadTemplate = () => {
  alert('Mengunduh template dataset 3 Sheet (Harga Pangan, TKPI, AKG)...')
}
</script>
