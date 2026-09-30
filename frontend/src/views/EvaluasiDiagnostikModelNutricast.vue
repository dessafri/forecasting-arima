<template>
<Sidebar /><div class="pl-[260px]"><Navbar /><main class="relative pt-16 bg-slate-50 min-h-screen"><div class="flex flex-col w-full">
<!-- Top Ambient Glow Decorator -->
<div class="relative w-full overflow-hidden pointer-events-none -mt-4 mb-2">
<div class="absolute -top-24 right-1/4 w-96 h-96 bg-primary/10 rounded-full blur-3xl pointer-events-none"></div>
<div class="absolute -top-16 right-10 w-72 h-72 bg-secondary/10 rounded-full blur-2xl pointer-events-none"></div>
</div>
<!-- Container Content Area -->
<div class="relative px-margin py-space-xl flex flex-col gap-space-xl max-w-[1600px] mx-auto w-full">
<section class="bg-white p-space-xl rounded-xl shadow-sm flex flex-col gap-space-xl">
<!-- Header & Action Ribbon -->
<div class="flex flex-col lg:flex-row lg:items-center justify-between gap-space-md">
<div class="flex flex-col gap-space-xs max-w-3xl">
<nav aria-label="Breadcrumb" class="flex items-center gap-space-xs text-sm font-semibold text-slate-500">
<span class="hover:text-blue-600 cursor-pointer transition-colors">Beranda</span>
<span class="text-outline-variant">/</span>
<span class="hover:text-blue-600 cursor-pointer transition-colors">Sistem &amp; Validasi</span>
<span class="text-outline-variant">/</span>
<span class="text-blue-600 font-semibold">Evaluasi &amp; Diagnostik Model</span>
</nav>
<h1 class="font-display-lg text-display-lg text-slate-900 tracking-tight mt-1" style="font-size: 20px; line-height: 28px;">
Evaluasi, Diagnostik Model &amp; Validasi Saintifik
</h1>


</div>
<div class="flex items-center gap-space-sm self-start lg:self-center shrink-0">
<BaseButton variant="primary" id="btn-retest">
<span class="material-symbols-outlined text-[18px]">play_circle</span>
<span>Jalankan Uji Diagnostik Ulang</span>
</BaseButton>
<BaseButton variant="secondary">
<span class="material-symbols-outlined text-[18px]">picture_as_pdf</span>
<span>Unduh Laporan (.PDF)</span>
</BaseButton>
</div>
</div>
<!-- 4 Aggregate Metric Cards -->
<hr class="border-slate-100" />
<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-space-md">
<!-- Card 1: MAPE -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between relative overflow-hidden group hover:shadow-md transition-shadow">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-xs font-medium uppercase tracking-wider text-slate-500">Rata-rata MAPE Komoditas</span>
<div class="flex items-baseline gap-1 mt-1">
<span class="text-xl font-semibold tracking-tight text-blue-600">3.42%</span>
<span class="text-xs font-medium text-blue-600">(±0.21%)</span>
</div>
</div>
<div class="p-2.5 rounded-xl bg-surface-container text-blue-600">
<span class="material-symbols-outlined text-[20px]">troubleshoot</span>
</div>
</div>

</div>
<!-- Card 2: ADF Test -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between relative overflow-hidden group hover:shadow-md transition-shadow">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-xs font-medium uppercase tracking-wider text-slate-500">Uji Stasioneritas ADF</span>
<div class="flex items-baseline gap-1 mt-1">
<span class="text-lg font-semibold tracking-tight text-slate-900">Semua Komoditas Lolos</span>
</div>
</div>
<div class="p-2.5 rounded-xl bg-surface-container text-blue-500">
<span class="material-symbols-outlined text-[20px]">signal_cellular_alt</span>
</div>
</div>

</div>
<!-- Card 3: Ljung-Box -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between relative overflow-hidden group hover:shadow-md transition-shadow">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-xs font-medium uppercase tracking-wider text-slate-500">Residual Autokorelasi</span>
<div class="flex items-baseline gap-1 mt-1">
<span class="text-xl font-semibold tracking-tight text-blue-500">p = 0.412</span>
<span class="text-xs font-medium text-blue-500">Ljung-Box</span>
</div>
</div>
<div class="p-2.5 rounded-xl bg-surface-container text-blue-500">
<span class="material-symbols-outlined text-[20px]">waves</span>
</div>
</div>

</div>
<!-- Card 4: GWO Computation -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between relative overflow-hidden group hover:shadow-md transition-shadow">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<span class="text-xs font-medium uppercase tracking-wider text-slate-500">Waktu Konvergensi GWO</span>
<div class="flex items-baseline gap-1 mt-1">
<span class="text-xl font-semibold tracking-tight text-tertiary">4.80 detik</span>
<span class="text-xs font-medium text-slate-500">100 Iterasi</span>
</div>
</div>
<div class="p-2.5 rounded-xl bg-surface-container text-tertiary">
<span class="material-symbols-outlined text-[20px]">timer</span>
</div>
</div>

</div>
</div>
<!-- Commodity Selection Tabs -->
<div class="flex flex-col gap-space-xs bg-white p-space-md rounded-xl shadow-sm">
<div class="flex items-center justify-between px-space-xs mb-1">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-blue-600 text-[20px]">dataset</span>
<span class="text-lg font-semibold text-slate-900">Pilih Komoditas Target Diagnostik</span>
</div>
<span class="text-sm font-medium text-slate-500 bg-surface-container px-2 py-0.5 rounded">Dataset Pangan TKPI 2024</span>
</div>
<div class="flex items-center gap-2 overflow-x-auto pb-1" id="commodity-pills">
<button class="commodity-pill active px-3 py-1.5 rounded-lg text-xs font-medium font-semibold bg-blue-600 text-white shadow-sm whitespace-nowrap transition-all text-[12px]" data-target="beras-premium">
Beras Premium (IR 64)
</button>
<button class="commodity-pill px-3 py-1.5 rounded-lg text-xs font-medium font-medium text-slate-500 hover:bg-surface-container hover:text-slate-900 whitespace-nowrap transition-all text-[12px]" data-target="ayam-ras">
Daging Ayam Ras
</button>
<button class="commodity-pill px-3 py-1.5 rounded-lg text-xs font-medium font-medium text-slate-500 hover:bg-surface-container hover:text-slate-900 whitespace-nowrap transition-all text-[12px]" data-target="telur-ayam">
Telur Ayam Ras
</button>
<button class="commodity-pill px-3 py-1.5 rounded-lg text-xs font-medium font-medium text-slate-500 hover:bg-surface-container hover:text-slate-900 whitespace-nowrap transition-all text-[12px]" data-target="ikan-kembung">
Ikan Kembung Segar
</button>
<button class="commodity-pill px-3 py-1.5 rounded-lg text-xs font-medium font-medium text-slate-500 hover:bg-surface-container hover:text-slate-900 whitespace-nowrap transition-all text-[12px]" data-target="daging-sapi">
Daging Sapi Murni
</button>
<button class="commodity-pill px-3 py-1.5 rounded-lg text-xs font-medium font-medium text-slate-500 hover:bg-surface-container hover:text-slate-900 whitespace-nowrap transition-all text-[12px]" data-target="wortel">
Wortel Segar
</button>
<button class="commodity-pill px-3 py-1.5 rounded-lg text-xs font-medium font-medium text-slate-500 hover:bg-surface-container hover:text-slate-900 whitespace-nowrap transition-all text-[12px]" data-target="kentang">
Kentang Sedang
</button>
<button class="commodity-pill px-3 py-1.5 rounded-lg text-xs font-medium font-medium text-slate-500 hover:bg-surface-container hover:text-slate-900 whitespace-nowrap transition-all text-[12px]" data-target="buncis">
Buncis Hijau
</button>
</div>
</div>
<!-- Main Scientific Grid (Left: Residual & ACF/PACF | Right: Split Comparison & 10-Fold CV) -->
<div class="grid grid-cols-1 xl:grid-cols-12 gap-space-lg">
<!-- LEFT COLUMN (6/12): Statistical Plots & Diagnostics -->
<div class="xl:col-span-12 flex flex-col gap-space-lg">
<!-- Panel 1: Residual Bell Curve & Gaussian Normality -->
<div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col gap-space-md">
<div class="flex items-start justify-between">
<div class="flex flex-col">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-blue-600 text-[20px]">show_chart</span>
<h3 class="text-lg font-semibold text-slate-900 text-[16px]">Distribusi Residual vs Kurva Normalitas Gauss</h3>
</div>

</div>
<span class="inline-flex items-center px-2 py-0.5 rounded bg-surface-container text-blue-600 text-sm font-semibold font-semibold">
JB Stat: 1.08 (p=0.58)
</span>
</div>
<!-- SVG Bell Curve Visualizer -->
<div class="relative w-full h-56 bg-white border border-slate-100 rounded-xl p-3 flex flex-col justify-end">
<div class="absolute top-3 left-4 flex items-center gap-4 text-slate-500 text-sm font-medium">
<span class="flex items-center gap-1.5"><span class="w-3 h-3 rounded bg-primary/40"></span> Frekuensi Histogram Residual</span>
<span class="flex items-center gap-1.5"><span class="w-3 h-0.5 bg-primary"></span> Kurva Normalitas Ideal (N~0,1)</span>
<span class="flex items-center gap-1.5"><span class="w-3 h-0.5 bg-error/70 stroke-dasharray"></span> Mean Residual (0.02)</span>
</div>
<svg class="w-full h-44 overflow-visible" preserveAspectRatio="none" viewBox="0 0 540 180">
<!-- Grid lines -->
<line class="text-outline-variant/30" stroke="currentColor" stroke-width="1" x1="20" x2="520" y1="150" y2="150"></line>
<line class="text-outline-variant/20" stroke="currentColor" stroke-dasharray="3,3" stroke-width="1" x1="20" x2="520" y1="100" y2="100"></line>
<line class="text-outline-variant/20" stroke="currentColor" stroke-dasharray="3,3" stroke-width="1" x1="20" x2="520" y1="50" y2="50"></line>
<!-- Histogram Bars -->
<rect class="fill-primary/30" height="8" rx="2" width="22" x="70" y="142"></rect>
<rect class="fill-primary/35" height="18" rx="2" width="22" x="96" y="132"></rect>
<rect class="fill-primary/40" height="32" rx="2" width="22" x="122" y="118"></rect>
<rect class="fill-primary/45" height="54" rx="2" width="22" x="148" y="96"></rect>
<rect class="fill-primary/50" height="82" rx="2" width="22" x="174" y="68"></rect>
<rect class="fill-primary/60" height="106" rx="2" width="22" x="200" y="44"></rect>
<rect class="fill-primary/75" height="126" rx="2" width="22" x="226" y="24"></rect>
<!-- Center bars -->
<rect class="fill-primary" height="136" rx="2" width="22" x="252" y="14"></rect>
<rect class="fill-primary/75" height="128" rx="2" width="22" x="278" y="22"></rect>
<rect class="fill-primary/60" height="108" rx="2" width="22" x="304" y="42"></rect>
<rect class="fill-primary/50" height="84" rx="2" width="22" x="330" y="66"></rect>
<rect class="fill-primary/45" height="52" rx="2" width="22" x="356" y="98"></rect>
<rect class="fill-primary/40" height="28" rx="2" width="22" x="382" y="122"></rect>
<rect class="fill-primary/35" height="16" rx="2" width="22" x="408" y="134"></rect>
<rect class="fill-primary/30" height="6" rx="2" width="22" x="434" y="144"></rect>
<!-- Gaussian Fitted Line -->
<path class="text-blue-600" d="M 60,148 C 140,146 190,80 240,24 C 265,-2 280,-2 300,24 C 350,80 400,146 480,148" fill="none" stroke="currentColor" stroke-width="2.5"></path>
<!-- Zero Mean Indicator -->
<line class="text-error" stroke="currentColor" stroke-dasharray="4,4" stroke-width="1.5" x1="270" x2="270" y1="10" y2="155"></line>
<!-- Axis labels -->
<text class="text-[10px] font-data-mono-sm fill-on-surface-variant" x="70" y="168">-3σ</text>
<text class="text-[10px] font-data-mono-sm fill-on-surface-variant" x="174" y="168">-1σ</text>
<text class="text-[10px] font-data-mono-sm fill-primary font-semibold" x="265" y="168">μ=0</text>
<text class="text-[10px] font-data-mono-sm fill-on-surface-variant" x="356" y="168">+1σ</text>
<text class="text-[10px] font-data-mono-sm fill-on-surface-variant" x="434" y="168">+3σ</text>
</svg>
</div>
<!-- Statistical Metrics Grid -->
<div class="grid grid-cols-4 gap-2 pt-2 text-center">
<div class="p-2 rounded-lg bg-white border border-slate-100">
<span class="text-sm font-medium text-slate-500 block">Skewness</span>
<span class="text-xl font-bold font-semibold text-slate-900">0.041</span>
<span class="text-sm font-medium text-blue-600 block mt-0.5">≈ Simetris (0)</span>
</div>
<div class="p-2 rounded-lg bg-white border border-slate-100">
<span class="text-sm font-medium text-slate-500 block">Kurtosis</span>
<span class="text-xl font-bold font-semibold text-slate-900">2.964</span>
<span class="text-sm font-medium text-blue-600 block mt-0.5">≈ Mesokurtik (3)</span>
</div>
<div class="p-2 rounded-lg bg-white border border-slate-100">
<span class="text-sm font-medium text-slate-500 block">Mean Error</span>
<span class="text-xl font-bold font-semibold text-slate-900">Rp +24.1</span>
<span class="text-sm font-medium text-blue-600 block mt-0.5">Zero Unbiased</span>
</div>
<div class="p-2 rounded-lg bg-white border border-slate-100">
<span class="text-sm font-medium text-slate-500 block">Jarque-Bera</span>
<span class="text-xl font-bold font-semibold text-blue-600">Normal</span>
<span class="text-sm font-medium text-slate-500 block mt-0.5">p &gt; 0.05</span>
</div>
</div>
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

</script>
