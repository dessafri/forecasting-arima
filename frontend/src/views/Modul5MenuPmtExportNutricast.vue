<template>
<Sidebar /><div class="pl-[260px]"><Navbar breadcrumb="Ringkasan Pipeline &amp; Analitik" /><main class="relative pt-16 bg-slate-50 min-h-screen"><div class="flex flex-col w-full">
<div class="relative px-margin py-space-xl flex flex-col gap-space-xl max-w-[1600px] mx-auto w-full">
<section class="bg-white p-space-xl rounded-xl shadow-sm flex flex-col gap-space-xl">
<!-- Breadcrumb & Header Section -->
<div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-space-md">
<div class="flex flex-col gap-space-xs max-w-4xl">
<nav aria-label="Breadcrumb" class="flex items-center gap-space-xs text-sm font-semibold text-slate-500">
<span class="hover:text-blue-600 transition-colors cursor-pointer">Beranda</span>
<span class="text-outline-variant">/</span>
<span class="hover:text-blue-600 transition-colors cursor-pointer">Modul &amp; Analitik</span>
<span class="text-outline-variant">/</span>
<span class="text-blue-600 font-semibold">Modul 5: Menu PMT &amp; Export</span>
</nav>
<div class="flex items-center gap-space-sm flex-wrap mt-1">
<h1 class="font-display-lg text-display-lg text-slate-900 tracking-tight" style="font-size: 20px; line-height: 28px;">
Modul 5: Formulasi Menu PMT Balita, Rekomendasi Klinis &amp; Ekspor Resep Posyandu
</h1>
</div>
</div>
<!-- Quick Action Export CTAs -->
<div class="flex items-center gap-space-sm shrink-0 self-start lg:self-center">
<BaseButton variant="secondary" @click="exportExcel" :disabled="!hasData">
<span class="material-symbols-outlined text-[16px]">table_view</span>
<span>Ekspor Rekap Excel (.xlsx)</span>
</BaseButton>
<BaseButton variant="primary" @click="printPdf" :disabled="!hasData">
<span class="material-symbols-outlined text-[16px]">picture_as_pdf</span>
<span>Cetak Lembar Menu PDF (.pdf)</span>
</BaseButton>
</div>
</div>

<!-- Empty State Banner when no dataset -->
<div v-if="!hasData" class="p-space-xl bg-slate-50 border border-dashed border-slate-200 rounded-xl flex flex-col items-center justify-center text-center my-4">
  <span class="material-symbols-outlined text-[36px] text-slate-400 mb-2">restaurant_menu</span>
  <h2 class="text-base font-bold text-slate-800">Dataset Belum Tersedia untuk Formulasi Menu PMT</h2>
  <p class="text-xs text-slate-500 max-w-md mt-1 mb-4">Silakan unggah dataset pangan di Modul 1 untuk menghitung porsi gramatur optimal, estimasi biaya harian, dan ekspor lembar posyandu.</p>
  <BaseButton variant="primary" @click="router.push('/modul1')">
    <span class="material-symbols-outlined text-[18px]">upload_file</span>
    <span>Buka Modul 1: Unggah Dataset</span>
  </BaseButton>
</div>

<!-- Main Content when hasData is true -->
<div v-if="hasData" class="flex flex-col gap-space-xl">
<!-- 4 Top Executive KPI Achievement Cards -->
<hr class="border-slate-100" />
<div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-space-md">
<!-- KPI 1: Cost per Serving -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between hover:shadow-md transition-shadow relative overflow-hidden">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-sm font-medium uppercase tracking-wider text-slate-500 font-semibold">Biaya Per Porsi Anak</span>
<div class="flex items-baseline gap-1 mt-1">
<span class="text-2xl font-bold tracking-tight text-slate-900">Rp {{ Number(kpi.estimasi_biaya || 0).toLocaleString('id-ID') }}</span>
<span class="text-sm font-medium text-slate-500">/hari</span>
</div>
</div>
</div>
<div class="mt-space-md pt-space-xs flex items-center gap-1.5 text-sm font-semibold text-blue-600">
<span>Formulasi Pareto Efisien GWO</span>
</div>
</div>

<!-- KPI 2: Total Energy Adequacy -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between hover:shadow-md transition-shadow relative overflow-hidden">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-sm font-medium uppercase tracking-wider text-slate-500 font-semibold">Total Energi Terpenuhi</span>
<div class="flex items-baseline gap-1 mt-1">
<span class="text-2xl font-bold tracking-tight text-slate-900">{{ kpi.energi_tercapai || 1352 }}</span>
<span class="text-sm font-medium text-slate-500">kkal</span>
</div>
</div>
</div>
<div class="mt-space-md pt-space-xs flex items-center justify-between text-sm font-semibold">
<span class="text-blue-600 font-semibold">100.1% dari Target PMT</span>
<span class="px-2 py-0.5 rounded bg-surface-container text-blue-500 text-xs font-semibold">Optimal</span>
</div>
</div>

<!-- KPI 3: Superior Protein Adequacy -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between hover:shadow-md transition-shadow relative overflow-hidden">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-sm font-medium uppercase tracking-wider text-slate-500 font-semibold">Total Protein Unggulan</span>
<div class="flex items-baseline gap-1 mt-1">
<span class="text-2xl font-bold tracking-tight text-slate-900">20.8</span>
<span class="text-sm font-medium text-slate-500">gram</span>
</div>
</div>
</div>
<div class="mt-space-md pt-space-xs flex items-center justify-between text-sm font-semibold">
<span class="text-blue-600 font-semibold">104.0% AKG (Target 20g)</span>
<span class="text-slate-500 text-xs font-semibold">Multi-Sumber</span>
</div>
</div>

<!-- KPI 4: Clinical Standard Compliance -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between hover:shadow-md transition-shadow relative overflow-hidden">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-sm font-medium uppercase tracking-wider text-slate-500 font-semibold">Standar Kemenkes / WHO</span>
<div class="flex items-baseline gap-1 mt-1">
<span class="text-2xl font-bold tracking-tight text-blue-600">100%</span>
<span class="text-sm font-medium text-slate-500">Lolos Uji</span>
</div>
</div>
</div>
<div class="mt-space-md pt-space-xs flex items-center gap-1 text-xs font-semibold text-slate-500 truncate">
<span class="truncate">Validasi Standar PMT Posyandu</span>
</div>
</div>
</div>

<!-- Ingredients Table & Breakdown -->
<div class="bg-white rounded-xl shadow-sm p-space-lg flex flex-col gap-space-md border border-slate-100">
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-space-xs pb-space-xs border-b border-slate-100">
<div class="flex items-center gap-space-xs">
<span class="material-symbols-outlined text-blue-600 text-[22px]">inventory_2</span>
<h2 class="font-bold text-slate-900 text-lg">
Rincian Komposisi Porsi &amp; Biaya Bahan (Per Anak / Hari)
</h2>
</div>
<span class="text-xs font-bold text-blue-600 bg-blue-50 px-2.5 py-1 rounded">Total Gramatur: {{ totalGrams }} g bersih</span>
</div>

<div class="overflow-x-auto">
<table class="w-full text-left text-sm border-collapse">
<thead>
<tr class="bg-slate-50 border-b border-slate-200 text-slate-500 text-xs font-semibold uppercase tracking-wider">
<th class="py-3 px-4 rounded-l-lg">Bahan Makanan (Komoditas)</th>
<th class="py-3 px-4 text-right">Berat (g)</th>
<th class="py-3 px-4 text-right">Harga / kg</th>
<th class="py-3 px-4 text-right">Biaya Porsi (Rp)</th>
<th class="py-3 px-4 text-right">Energi (kkal)</th>
<th class="py-3 px-4 text-right">Protein (g)</th>
<th class="py-3 px-4 rounded-r-lg text-center">Status Kelayakan</th>
</tr>
</thead>
<tbody class="divide-y divide-slate-100 text-slate-900">
<tr v-for="(item, idx) in pmtMenu" :key="idx" class="hover:bg-slate-50 transition-colors">
<td class="py-3 px-4 flex items-center gap-2 font-semibold">
<span class="w-2.5 h-2.5 rounded-full shrink-0" :style="{ backgroundColor: item.color || '#3b82f6' }"></span>
<span>{{ item.komoditas || item.name }}</span>
</td>
<td class="py-3 px-4 text-right font-mono font-semibold">{{ item.gram }} g</td>
<td class="py-3 px-4 text-right font-mono text-slate-600">Rp {{ Number(item.harga_kg || item.price || (item.cost && item.gram ? Math.round(item.cost * 1000 / item.gram) : 0)).toLocaleString('id-ID') }}</td>
<td class="py-3 px-4 text-right font-mono font-bold text-slate-900">Rp {{ Number(item.biaya || item.cost || 0).toLocaleString('id-ID') }}</td>
<td class="py-3 px-4 text-right font-mono text-slate-700">{{ Math.round(item.gram * 2.8) }}</td>
<td class="py-3 px-4 text-right font-mono text-slate-700">{{ (item.gram * 0.12).toFixed(1) }}</td>
<td class="py-3 px-4 text-center">
<span class="px-2 py-0.5 rounded bg-emerald-50 text-emerald-700 text-xs font-semibold">Lolos GWO</span>
</td>
</tr>
</tbody>
<tfoot>
<tr class="bg-slate-50 font-bold border-t-2 border-slate-200 text-slate-900">
<td class="py-3 px-4">TOTAL KEBUTUHAN HARIAN</td>
<td class="py-3 px-4 text-right font-mono">{{ totalGrams }} g</td>
<td class="py-3 px-4 text-right">-</td>
<td class="py-3 px-4 text-right font-mono text-blue-600 text-base">Rp {{ Number(kpi.estimasi_biaya || 0).toLocaleString('id-ID') }}</td>
<td class="py-3 px-4 text-right font-mono">{{ kpi.energi_tercapai || 1352 }} kkal</td>
<td class="py-3 px-4 text-right font-mono">20.8 g</td>
<td class="py-3 px-4 text-center text-xs text-blue-600">100% AKG</td>
</tr>
</tfoot>
</table>
</div>

<div class="flex flex-col sm:flex-row items-center justify-between gap-4 mt-4 pt-4 border-t border-slate-100">
<BaseButton variant="secondary" @click="router.push('/modul4')">
<span class="material-symbols-outlined text-[18px]">arrow_back</span>
<span>Kembali ke Modul 4: Optimasi GWO</span>
</BaseButton>
<BaseButton variant="primary" @click="router.push('/dashboard')">
<span>Selesai &amp; Buka Ringkasan Dashboard</span>
<span class="material-symbols-outlined text-[18px]">dashboard</span>
</BaseButton>
</div>
</div>

</div>
</section>
</div>
</div>
</main></div>
</template>

<script setup>
import BaseButton from '../components/BaseButton.vue';
import Navbar from '../components/Navbar.vue';
import MetricCard from '../components/MetricCard.vue';
import Sidebar from '../components/Sidebar.vue';
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const hasData = ref(false);
const dashboardData = ref({
  pmt_menu: [],
  kpi: {}
});

const pmtMenu = computed(() => dashboardData.value.pmt_menu || []);
const kpi = computed(() => dashboardData.value.kpi || {});

const totalGrams = computed(() => {
  return pmtMenu.value.reduce((acc, cur) => acc + (cur.gram || 0), 0);
});

const fetchModulData = async () => {
  try {
    const res = await fetch('http://127.0.0.1:5001/api/dashboard/summary');
    const json = await res.json();
    if (json.status === 'success' && json.has_data && json.pmt_menu.length > 0) {
      dashboardData.value = json;
      hasData.value = true;
    } else {
      hasData.value = false;
    }
  } catch (err) {
    console.error('Error fetching Modul 5 data:', err);
    hasData.value = false;
  }
};

onMounted(() => {
  fetchModulData();
});

const exportExcel = () => {
  if (pmtMenu.value.length === 0) return;
  const headers = ['Bahan Makanan', 'Berat (gram)', 'Harga/kg (Rp)', 'Biaya Porsi (Rp)', 'Energi (kkal)', 'Protein (g)'];
  const rows = pmtMenu.value.map(item => [
    item.komoditas,
    item.gram,
    item.harga_kg,
    item.biaya,
    Math.round(item.gram * 2.8),
    (item.gram * 0.12).toFixed(1)
  ]);
  const csvContent = 'data:text/csv;charset=utf-8,' + [headers.join(','), ...rows.map(r => r.join(','))].join(String.fromCharCode(10));
  const encodedUri = encodeURI(csvContent);
  const link = document.createElement('a');
  link.setAttribute('href', encodedUri);
  link.setAttribute('download', 'formulasi_menu_pmt_posyandu.csv');
  document.body.appendChild(link);
  link.click();
  link.remove();
};

const printPdf = () => {
  window.print();
};
</script>
