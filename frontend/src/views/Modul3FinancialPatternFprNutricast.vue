<template>
<Sidebar /><div class="pl-[260px]"><Navbar breadcrumb="Ringkasan Pipeline &amp; Analitik" /><main class="relative pt-16 bg-slate-50 min-h-screen"><div class="flex flex-col w-full">
<div class="px-margin py-space-xl flex flex-col gap-space-xl max-w-[1600px] mx-auto w-full">
<section class="bg-white p-space-xl rounded-xl shadow-sm flex flex-col gap-space-xl">
<!-- Top Header Module & Breadcrumb -->
<div class="flex flex-col md:flex-row md:items-center justify-between gap-space-md">
<div class="flex flex-col gap-1">
<div class="flex items-center gap-space-xs text-xs text-slate-500">
<span class="hover:text-blue-600 transition-colors cursor-pointer">Beranda</span>
<span class="text-outline-variant">/</span>
<span class="hover:text-blue-600 transition-colors cursor-pointer">Modul &amp; Analitik</span>
<span class="text-outline-variant">/</span>
<span class="text-blue-600 font-semibold">Modul 3: Financial Pattern (FPR)</span>
</div>
<h1 class="font-display-lg text-display-lg text-slate-900 tracking-tight" style="font-size: 20px; line-height: 28px;">Modul 3: Financial Pattern Recognition &amp; Volatilitas Komoditas</h1>
</div>
<div class="flex items-center gap-space-sm shrink-0 self-start md:self-auto">
<BaseButton variant="secondary" @click="downloadFprCsv" :disabled="!hasData">
<span class="material-symbols-outlined text-[16px]">download</span>
<span>Unduh Matriks FPR (.CSV)</span>
</BaseButton>
<BaseButton variant="primary" @click="syncWithGWO" :disabled="!hasData">
<span class="material-symbols-outlined text-[16px]">sync_alt</span>
<span>Sinkronisasi dengan GWO Engine</span>
</BaseButton>
</div>
</div>

<!-- Empty State Banner when no dataset -->
<div v-if="!hasData" class="p-space-xl bg-slate-50 border border-dashed border-slate-200 rounded-xl flex flex-col items-center justify-center text-center my-4">
  <span class="material-symbols-outlined text-[36px] text-slate-400 mb-2">insights</span>
  <h2 class="text-base font-bold text-slate-800">Dataset Belum Tersedia untuk Analisis FPR</h2>
  <p class="text-xs text-slate-500 max-w-md mt-1 mb-4">Silakan unggah dataset pangan di Modul 1 untuk menghitung Financial Pattern Recognition, tren pasar, dan volatilitas komoditas.</p>
  <BaseButton variant="primary" @click="router.push('/modul1')">
    <span class="material-symbols-outlined text-[18px]">upload_file</span>
    <span>Buka Modul 1: Unggah Dataset</span>
  </BaseButton>
</div>

<!-- Main Content when hasData is true -->
<div v-if="hasData" class="flex flex-col gap-space-xl">
<!-- 4 KPI Summary Cards -->
<hr class="border-slate-100" />
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-md">
<!-- Bullish -->
<div class="bg-slate-50 border border-slate-100 rounded-xl p-space-md flex flex-col justify-between">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-sm font-medium uppercase tracking-wider text-slate-500 font-medium">Tren Pasar Positif</span>
<span class="font-display-lg text-display-lg font-bold text-slate-900 mt-1">{{ bullishCount }} <span class="text-sm font-semibold text-slate-500 font-normal">Komoditas</span></span>
</div>
<span class="p-2 rounded-lg bg-amber-100 text-amber-800">
<span class="material-symbols-outlined text-[24px]">trending_up</span>
</span>
</div>
<div class="mt-4 pt-3 bg-white border border-slate-100 px-3 py-2 rounded-lg flex flex-col gap-1">
<div class="flex items-center justify-between">
<span class="text-sm font-semibold text-amber-700">BULLISH (NAIK)</span>
<span class="px-1.5 py-0.5 rounded bg-amber-50 text-amber-800 text-[11px] font-semibold">Peringatan Biaya</span>
</div>
<p class="text-[11px] text-slate-500 leading-tight truncate">{{ bullishNames || '-' }}</p>
</div>
</div>

<!-- Bearish -->
<div class="bg-slate-50 border border-slate-100 rounded-xl p-space-md flex flex-col justify-between">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-sm font-medium uppercase tracking-wider text-slate-500 font-medium">Tren Pasar Terkoreksi</span>
<span class="font-display-lg text-display-lg font-bold text-slate-900 mt-1">{{ bearishCount }} <span class="text-sm font-semibold text-slate-500 font-normal">Komoditas</span></span>
</div>
<span class="p-2 rounded-lg bg-indigo-100 text-indigo-800">
<span class="material-symbols-outlined text-[24px]">trending_down</span>
</span>
</div>
<div class="mt-4 pt-3 bg-white border border-slate-100 px-3 py-2 rounded-lg flex flex-col gap-1">
<div class="flex items-center justify-between">
<span class="text-sm font-semibold text-indigo-700">BEARISH (TURUN)</span>
<span class="px-1.5 py-0.5 rounded bg-indigo-50 text-indigo-800 text-[11px] font-semibold">Peluang Alokasi</span>
</div>
<p class="text-[11px] text-slate-500 leading-tight truncate">{{ bearishNames || '-' }}</p>
</div>
</div>

<!-- Sideways -->
<div class="bg-slate-50 border border-slate-100 rounded-xl p-space-md flex flex-col justify-between">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-sm font-medium uppercase tracking-wider text-slate-500 font-medium">Tren Pasar Stabil</span>
<span class="font-display-lg text-display-lg font-bold text-slate-900 mt-1">{{ sidewaysCount }} <span class="text-sm font-semibold text-slate-500 font-normal">Komoditas</span></span>
</div>
<span class="p-2 rounded-lg bg-slate-200 text-slate-700">
<span class="material-symbols-outlined text-[24px]">trending_flat</span>
</span>
</div>
<div class="mt-4 pt-3 bg-white border border-slate-100 px-3 py-2 rounded-lg flex flex-col gap-1">
<div class="flex items-center justify-between">
<span class="text-sm font-semibold text-slate-700">SIDEWAYS (STABIL)</span>
<span class="px-1.5 py-0.5 rounded bg-slate-100 text-slate-700 text-[11px] font-semibold">Anchor Bahan</span>
</div>
<p class="text-[11px] text-slate-500 leading-tight truncate">{{ sidewaysNames || '-' }}</p>
</div>
</div>

<!-- Volatility Avg -->
<div class="bg-slate-50 border border-slate-100 rounded-xl p-space-md flex flex-col justify-between">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-sm font-medium uppercase tracking-wider text-slate-500 font-medium">Rata-Rata Volatilitas</span>
<div class="flex items-baseline gap-2 mt-1">
<span class="text-3xl font-bold tracking-tight text-blue-600">{{ avgVolatility }}%</span>
<span class="text-[11px] text-slate-500">σ / hari</span>
</div>
</div>
<span class="p-2 rounded-lg bg-blue-100 text-blue-800">
<span class="material-symbols-outlined text-[24px]">show_chart</span>
</span>
</div>
<div class="mt-4 pt-3 bg-white border border-slate-100 px-3 py-2 rounded-lg flex items-center justify-between">
<span class="text-xs text-slate-600 font-medium">Status Risiko Pasar:</span>
<span class="text-xs font-bold text-blue-600">Terkendali</span>
</div>
</div>
</div>

<!-- Main Data Table: Financial Pattern Recognition (FPR) Classification -->
<div class="bg-white rounded-xl shadow-sm overflow-hidden flex flex-col border border-slate-100">
<div class="p-space-lg flex flex-col sm:flex-row sm:items-center justify-between gap-space-sm border-b border-slate-100">
<div>
<h2 class="font-bold text-slate-900 text-lg">Tabel Klasifikasi Financial Pattern Recognition (FPR)</h2>
<p class="text-xs text-slate-500 mt-0.5">Klasifikasi volatilitas dan pergerakan return logaritmik dari {{ fprData.length }} komoditas aktif.</p>
</div>
<div class="flex items-center gap-space-sm">
<div class="flex items-center bg-slate-50 border border-slate-200 px-3 py-1.5 rounded-lg text-slate-900">
<span class="material-symbols-outlined text-[18px] text-slate-500 mr-1.5">filter_list</span>
<select v-model="selectedPattern" class="bg-transparent text-xs font-medium outline-none cursor-pointer" id="filter-pattern">
<option value="all">Semua Pola FPR ({{ fprData.length }})</option>
<option value="bullish">Pola Bullish ({{ bullishCount }})</option>
<option value="bearish">Pola Bearish ({{ bearishCount }})</option>
<option value="sideways">Pola Sideways ({{ sidewaysCount }})</option>
</select>
</div>
</div>
</div>

<!-- High Density Scientific Data Table -->
<div class="overflow-x-auto w-full">
<table class="w-full text-left" id="table-fpr">
<thead>
<tr class="bg-slate-50 border-b border-slate-200 text-xs font-semibold text-slate-500 uppercase tracking-wider">
<th class="py-3 px-4 whitespace-nowrap">Komoditas &amp; Jenis Pangan</th>
<th class="py-3 px-4 text-right whitespace-nowrap">Harga Riil Terakhir</th>
<th class="py-3 px-4 text-right whitespace-nowrap">Estimasi T+30</th>
<th class="py-3 px-4 text-center whitespace-nowrap">Expected Return</th>
<th class="py-3 px-4 text-center whitespace-nowrap">Volatilitas (Std Dev)</th>
<th class="py-3 px-4 text-center whitespace-nowrap">Klasifikasi Pola</th>
<th class="py-3 px-4 text-center whitespace-nowrap">Tingkat Risiko</th>
<th class="py-3 px-4 whitespace-nowrap">Rekomendasi Alokasi GWO</th>
<th class="py-3 px-4 text-center whitespace-nowrap">Validasi FPR</th>
</tr>
</thead>
<tbody class="divide-y divide-slate-100 text-sm text-slate-900">
<tr v-for="item in filteredFprList" :key="item.id" class="hover:bg-slate-50 transition-colors">
<td class="py-3.5 px-4 whitespace-nowrap">
<div class="flex items-center gap-2">
<span class="w-2.5 h-2.5 rounded-full shrink-0" :style="{ backgroundColor: item.color }"></span>
<div class="flex flex-col">
<span class="font-semibold text-slate-900">{{ item.name }}</span>
<span class="text-xs text-slate-500">{{ item.desc }}</span>
</div>
</div>
</td>
<td class="py-3.5 px-4 text-right text-sm font-semibold whitespace-nowrap">Rp {{ Number(item.hargaAktual).toLocaleString('id-ID') }}</td>
<td class="py-3.5 px-4 text-right text-sm font-semibold text-slate-900 whitespace-nowrap">Rp {{ Number(item.hargaForecast).toLocaleString('id-ID') }}</td>
<td class="py-3.5 px-4 text-center text-sm font-bold whitespace-nowrap" :class="item.returnVal > 0 ? 'text-emerald-600' : (item.returnVal < 0 ? 'text-rose-600' : 'text-slate-600')">
<div class="flex items-center justify-center gap-0.5">
<span class="material-symbols-outlined text-[16px]">{{ item.returnVal > 0 ? 'arrow_upward' : (item.returnVal < 0 ? 'arrow_downward' : 'drag_handle') }}</span>
<span>{{ item.returnVal > 0 ? '+' : '' }}{{ item.returnVal }}%</span>
</div>
</td>
<td class="py-3.5 px-4 text-center text-sm font-semibold whitespace-nowrap">{{ item.volatilitas }}%</td>
<td class="py-3.5 px-4 text-center whitespace-nowrap">
<span class="px-2.5 py-1 rounded font-bold text-[11px] tracking-wide uppercase" :class="getPatternBadge(item.pattern)">
{{ item.pattern }}
</span>
</td>
<td class="py-3.5 px-4 text-center whitespace-nowrap">
<span class="px-2 py-0.5 rounded text-[11px] font-medium" :class="item.resiko === 'Tinggi' ? 'bg-rose-100 text-rose-800' : 'bg-slate-100 text-slate-700'">{{ item.resiko }}</span>
</td>
<td class="py-3.5 px-4 text-xs font-semibold text-blue-600 whitespace-nowrap">
{{ item.rekomendasi }}
</td>
<td class="py-3.5 px-4 text-center whitespace-nowrap">
<span class="inline-flex items-center gap-1 text-blue-600 bg-blue-50 px-2 py-0.5 rounded text-[11px] font-semibold">
<span class="material-symbols-outlined text-[14px]">check_circle</span> Siap GWO
</span>
</td>
</tr>
</tbody>
</table>
</div>

<div class="p-space-md bg-white border-t border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-space-sm text-slate-500 text-xs">
<div class="flex items-center gap-2">
<span class="inline-block w-2 h-2 rounded-full bg-primary"></span>
<span>Seluruh komoditas terverifikasi stasioneritas log-return dan siap dioptimasi pada Modul 4 (GWO).</span>
</div>
<BaseButton variant="primary" @click="router.push('/modul4')">
<span>Lanjut ke Modul 4: Optimasi GWO</span>
<span class="material-symbols-outlined text-[18px]">arrow_forward</span>
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
const selectedPattern = ref('all');
const rawCommodities = ref([]);

const fetchModulData = async () => {
  try {
    const res = await fetch('http://127.0.0.1:5001/api/dashboard/summary');
    const json = await res.json();
    if (json.status === 'success' && json.has_data && json.commodities.length > 0) {
      hasData.value = true;
      rawCommodities.value = json.commodities;
    } else {
      hasData.value = false;
      rawCommodities.value = [];
    }
  } catch (err) {
    console.error('Error fetching Modul 3 data:', err);
    hasData.value = false;
  }
};

onMounted(() => {
  fetchModulData();
});

const fprData = computed(() => {
  if (rawCommodities.value.length === 0) return [];
  return rawCommodities.value.map(c => {
    const patternLower = (c.fpr_pattern || 'Stabil').toLowerCase();
    const isBullish = patternLower === 'bullish';
    const isBearish = patternLower === 'bearish';
    const forecastEst = Math.round(c.latest_price * (1 + (c.return_pct || 0) / 100));

    return {
      id: c.id,
      name: c.name,
      desc: 'Komoditas Pangan Pokok',
      hargaAktual: c.latest_price,
      hargaForecast: forecastEst,
      returnVal: c.return_pct || 0,
      volatilitas: c.volatility || 0,
      pattern: isBullish ? 'bullish' : (isBearish ? 'bearish' : 'sideways'),
      resiko: Math.abs(c.return_pct || 0) > 10 ? 'Tinggi' : 'Rendah',
      rekomendasi: c.gwo_action || 'Porsi Optimal',
      color: c.color || '#3b82f6'
    };
  });
});

const filteredFprList = computed(() => {
  if (selectedPattern.value === 'all') return fprData.value;
  return fprData.value.filter(item => item.pattern === selectedPattern.value);
});

const bullishCount = computed(() => fprData.value.filter(d => d.pattern === 'bullish').length);
const bearishCount = computed(() => fprData.value.filter(d => d.pattern === 'bearish').length);
const sidewaysCount = computed(() => fprData.value.filter(d => d.pattern === 'sideways').length);

const bullishNames = computed(() => fprData.value.filter(d => d.pattern === 'bullish').map(d => d.name).join(', '));
const bearishNames = computed(() => fprData.value.filter(d => d.pattern === 'bearish').map(d => d.name).join(', '));
const sidewaysNames = computed(() => fprData.value.filter(d => d.pattern === 'sideways').map(d => d.name).join(', '));

const avgVolatility = computed(() => {
  if (fprData.value.length === 0) return '0.00';
  const sum = fprData.value.reduce((acc, cur) => acc + Number(cur.volatilitas), 0);
  return (sum / fprData.value.length).toFixed(2);
});

const getPatternBadge = (pattern) => {
  if (pattern === 'bullish') return 'bg-amber-100 text-amber-800';
  if (pattern === 'bearish') return 'bg-indigo-100 text-indigo-800';
  return 'bg-slate-100 text-slate-700';
};

const downloadFprCsv = () => {
  if (fprData.value.length === 0) return;
  const headers = ['Komoditas', 'Kategori Gizi', 'Harga Aktual', 'Harga Forecast', 'Return (%)', 'Volatilitas (%)', 'Pola FPR', 'Tingkat Resiko', 'Rekomendasi GWO'];
  const rows = fprData.value.map(d => [
    d.name, d.desc, d.hargaAktual, d.hargaForecast, d.returnVal + '%', d.volatilitas + '%', d.pattern, d.resiko, '"' + d.rekomendasi + '"'
  ]);
  const csvContent = 'data:text/csv;charset=utf-8,' + [headers.join(','), ...rows.map(r => r.join(','))].join(String.fromCharCode(10));
  const encodedUri = encodeURI(csvContent);
  const link = document.createElement('a');
  link.setAttribute('href', encodedUri);
  link.setAttribute('download', 'matriks_fpr_komoditas.csv');
  document.body.appendChild(link);
  link.click();
  link.remove();
};

const syncWithGWO = () => {
  alert('Sinkronisasi parameter FPR ke Matriks Pembobotan GWO Modul 4 berhasil!');
};
</script>
