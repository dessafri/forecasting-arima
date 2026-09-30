<template>
<Sidebar /><div class="pl-[260px]"><Navbar /><main class="relative pt-16 bg-slate-50 min-h-screen"><div class="flex flex-col w-full">
<!-- Dynamic Notification / Status Toast Container -->
<div class="fixed bottom-6 right-6 z-50 flex flex-col gap-2 pointer-events-none" id="toast-container"></div>
<!-- Interior Content Container -->
<div class="px-8 py-6 flex flex-col gap-6">
<!-- 1. Header Modul & Action Toolbar -->
<div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4 bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs">
<div class="flex flex-col gap-1.5">
<div class="flex items-center gap-1.5 text-xs text-slate-500 font-medium">
<span>Beranda</span>
<span class="text-slate-300">/</span>
<span>Modul &amp; Analitik</span>
<span class="text-slate-300">/</span>
<span class="text-emerald-800 font-semibold">Modul 2: Forecasting ARIMA &amp; Evaluasi</span>
</div>
<h1 class="text-xl font-bold text-slate-900 tracking-tight">
Modul 2: Time Series Forecasting ARIMA &amp; Evaluasi Diagnostik
</h1>

</div>
<!-- Action Buttons with Semantic Separation -->
<div class="flex items-center gap-3 shrink-0">
<BaseButton variant="secondary" id="btn-export-json">
<span class="material-symbols-outlined text-[16px]">file_download</span>
<span>Ekspor Parameter (.JSON)</span>
</BaseButton>
<BaseButton variant="primary" id="btn-run-grid">
<span class="material-symbols-outlined text-[16px] text-emerald-400">play_circle</span>
<span id="btn-run-text">Jalankan Auto-ARIMA Grid Search</span>
</BaseButton>
</div>
</div>
<!-- 2. Parameter & Kontrol Pemodelan (Toolbar + Smooth Chip Scroll) -->
<div class="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-xs flex flex-col gap-4">
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-slate-100 pb-3">
<div class="flex items-center gap-2">
<div class="p-1.5 rounded-md bg-emerald-50 text-emerald-800 border border-emerald-200">
<span class="material-symbols-outlined text-[18px]">tune</span>
</div>
<div>
<h2 class="text-sm font-bold text-slate-900">Konfigurasi Pipeline &amp; Pemilihan Komoditas Pangan</h2>

</div>
</div>
<div class="flex items-center gap-1.5 self-start sm:self-auto">

</div>
</div>
<!-- Commodity Selector Smooth Horizontal Ribbon -->
<div class="flex flex-col gap-1.5">
<label class="text-[11px] font-semibold text-slate-500 uppercase tracking-wider">Komoditas Sasaran Intervensi PMT (8 Bahan Baku Utama)</label>
<div class="flex items-center gap-2 overflow-x-auto pb-2 pt-0.5 scroll-smooth" id="commodity-pills" style="scrollbar-width: thin;">
<button class="commodity-btn active px-3.5 py-2 rounded-lg font-semibold text-xs bg-slate-900 text-white border border-slate-900 transition-all duration-150 flex items-center gap-2 whitespace-nowrap shadow-xs" data-id="beras">
<span class="material-symbols-outlined text-[16px] text-emerald-400">grain</span>
<span>Beras Premium</span>
</button>
<button class="commodity-btn px-3.5 py-2 rounded-lg font-medium text-xs bg-slate-50 text-slate-700 hover:bg-slate-100 hover:text-slate-900 border border-slate-200 transition-all duration-150 flex items-center gap-2 whitespace-nowrap" data-id="ayam">
<span class="material-symbols-outlined text-[16px] text-amber-600">egg</span>
<span>Daging Ayam Ras</span>
</button>
<button class="commodity-btn px-3.5 py-2 rounded-lg font-medium text-xs bg-slate-50 text-slate-700 hover:bg-slate-100 hover:text-slate-900 border border-slate-200 transition-all duration-150 flex items-center gap-2 whitespace-nowrap" data-id="telur">
<span class="material-symbols-outlined text-[16px] text-amber-500">egg_alt</span>
<span>Telur Ayam Ras</span>
</button>
<button class="commodity-btn px-3.5 py-2 rounded-lg font-medium text-xs bg-slate-50 text-slate-700 hover:bg-slate-100 hover:text-slate-900 border border-slate-200 transition-all duration-150 flex items-center gap-2 whitespace-nowrap" data-id="ikan">
<span class="material-symbols-outlined text-[16px] text-sky-600">phishing</span>
<span>Ikan Kembung</span>
</button>
<button class="commodity-btn px-3.5 py-2 rounded-lg font-medium text-xs bg-slate-50 text-slate-700 hover:bg-slate-100 hover:text-slate-900 border border-slate-200 transition-all duration-150 flex items-center gap-2 whitespace-nowrap" data-id="wortel">
<span class="material-symbols-outlined text-[16px] text-orange-600">nutrition</span>
<span>Wortel Segar</span>
</button>
<button class="commodity-btn px-3.5 py-2 rounded-lg font-medium text-xs bg-slate-50 text-slate-700 hover:bg-slate-100 hover:text-slate-900 border border-slate-200 transition-all duration-150 flex items-center gap-2 whitespace-nowrap" data-id="kentang">
<span class="material-symbols-outlined text-[16px] text-amber-700">spa</span>
<span>Kentang Dieng</span>
</button>
<button class="commodity-btn px-3.5 py-2 rounded-lg font-medium text-xs bg-slate-50 text-slate-700 hover:bg-slate-100 hover:text-slate-900 border border-slate-200 transition-all duration-150 flex items-center gap-2 whitespace-nowrap" data-id="buncis">
<span class="material-symbols-outlined text-[16px] text-emerald-600">psychiatry</span>
<span>Buncis Hijau</span>
</button>
<button class="commodity-btn px-3.5 py-2 rounded-lg font-medium text-xs bg-slate-50 text-slate-700 hover:bg-slate-100 hover:text-slate-900 border border-slate-200 transition-all duration-150 flex items-center gap-2 whitespace-nowrap" data-id="sapi">
<span class="material-symbols-outlined text-[16px] text-rose-700">restaurant</span>
<span>Daging Sapi Murni</span>
</button>
</div>
</div>
<!-- Operational Parameters Grid -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 pt-1">
<!-- Split Ratio -->
<div class="flex flex-col gap-1.5">
<label class="text-[11px] font-semibold text-slate-500 uppercase">Skenario Train:Test Split</label>
<div class="flex items-center bg-slate-100 p-1 rounded-lg gap-1 border border-slate-200">
<button class="split-btn flex-1 py-1.5 text-center text-xs rounded text-slate-600 hover:text-slate-900 font-mono transition-all" data-split="70-30">70:30</button>
<button class="split-btn active flex-1 py-1.5 text-center text-xs rounded bg-white font-bold text-slate-900 shadow-xs border border-slate-200/80 font-mono transition-all" data-split="80-20">80:20</button>
<button class="split-btn flex-1 py-1.5 text-center text-xs rounded text-slate-600 hover:text-slate-900 font-mono transition-all" data-split="90-10">90:10</button>
</div>
</div>
<!-- Horizon Prediksi -->
<div class="flex flex-col gap-1.5">
<label class="text-[11px] font-semibold text-slate-500 uppercase">Horizon Proyeksi (Forecast Lead)</label>
<div class="flex items-center bg-slate-50 border border-slate-200 px-3 py-2 rounded-lg justify-between">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-[18px] text-sky-600">date_range</span>
<span class="text-xs font-semibold text-slate-800">30 Hari Kedepan</span>
</div>
<span class="font-mono text-[11px] bg-sky-100 text-sky-800 border border-sky-200 px-2 py-0.5 rounded font-semibold">H+30</span>
</div>
</div>
<!-- Confidence Interval Checkbox -->
<div class="flex flex-col gap-1.5">
<label class="text-[11px] font-semibold text-slate-500 uppercase">Pita Ketidakpastian (Interval)</label>
<label class="flex items-center gap-2.5 bg-slate-50 border border-slate-200 px-3 py-2 rounded-lg cursor-pointer hover:bg-slate-100 transition-colors">
<input checked="" class="h-4 w-4 rounded text-emerald-700 focus:ring-emerald-600 cursor-pointer border-slate-300" id="toggle-ci" type="checkbox"/>
<div class="flex flex-col">
<span class="text-xs font-semibold text-slate-800">95% Confidence Band</span>
<span class="text-[10px] text-slate-500 font-mono">P10 s/d P90 Quantile</span>
</div>
</label>
</div>
<!-- Hyperparameter Range Tag -->
<div class="flex flex-col gap-1.5">
<label class="text-[11px] font-semibold text-slate-500 uppercase">Search Space Order</label>
<div class="bg-slate-50 border border-slate-200 px-3 py-2 rounded-lg flex items-center justify-between">
<span class="font-mono text-xs text-slate-800 font-medium">p:[0-3] d:[0-2] q:[0-3]</span>
<span class="text-[11px] font-semibold text-slate-500 bg-slate-200/70 px-1.5 py-0.5 rounded">Season: Off</span>
</div>
</div>
</div>
</div>
<!-- 3. HERO SECTION: Visualisasi Grafik Interaktif Utama -->
<div class="bg-white rounded-2xl p-6 border border-slate-200/80 shadow-xs flex flex-col gap-4">
<!-- Chart Top Bar -->
<div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4 pb-2 border-b border-slate-100">
<div class="flex flex-col gap-1">
<div class="flex flex-wrap items-center gap-2">
<span class="px-2 py-0.5 rounded text-[11px] font-bold tracking-wide uppercase bg-emerald-100 text-emerald-800 border border-emerald-200">Hero Forecasting View</span>
<h3 class="text-lg font-bold text-slate-900 tracking-tight" id="chart-commodity-title">Beras Premium: Kurva Aktual vs Peramalan ARIMA(1,1,2)</h3>
<span class="font-mono text-xs px-2.5 py-0.5 bg-slate-100 border border-slate-200 rounded-md text-slate-700 font-medium">90 Hari Observasi + 30 Hari Forecast</span>
</div>

</div>
<!-- Legend Items -->
<div class="flex flex-wrap items-center gap-3 text-xs bg-slate-50 border border-slate-200 px-3 py-1.5 rounded-lg shrink-0">
<div class="flex items-center gap-1.5">
<span class="w-3.5 h-1 bg-slate-700 rounded-full"></span>
<span class="text-xs text-slate-700 font-medium">Data Training</span>
</div>
<div class="flex items-center gap-1.5">
<span class="w-3.5 h-0.5 border-t-2 border-dashed border-emerald-600"></span>
<span class="text-xs text-slate-700 font-medium">Testing Aktual</span>
</div>
<div class="flex items-center gap-1.5">
<span class="w-3.5 h-1 bg-sky-600 rounded-full"></span>
<span class="text-xs text-sky-900 font-bold">ARIMA Forecast</span>
</div>
<div class="flex items-center gap-1.5">
<span class="w-3.5 h-2.5 bg-sky-400/30 rounded border border-sky-300"></span>
<span class="text-xs text-slate-600 font-medium">Pita CI 95%</span>
</div>
<div class="flex items-center gap-1.5">
<span class="w-2.5 h-2.5 rounded-full bg-rose-600"></span>
<span class="text-xs text-rose-700 font-bold">Split Horizon</span>
</div>
</div>
</div>
<!-- Hero Interactive SVG Chart Container with Safe Padding (Left 65px, Bottom 35px) -->
<div class="relative w-full bg-slate-50/70 border border-slate-200 rounded-xl p-3 md:p-5 overflow-hidden" id="main-chart-wrapper" @mouseleave="hideTooltip">
<!-- Interactive Tooltip Overlay -->
<div v-if="tooltip.visible"
     :style="{ left: Math.min(Math.max(tooltip.x, 150), 840) + 'px', top: Math.max(12, tooltip.y - 130) + 'px', pointerEvents: 'none' }"
     class="absolute z-50 pointer-events-none select-none bg-slate-900/95 backdrop-blur-md text-white p-3.5 rounded-xl shadow-2xl text-xs flex flex-col gap-1.5 border border-slate-700/80 min-w-[230px] max-w-[290px] transform -translate-x-1/2">
  <div class="flex items-center justify-between gap-2 border-b border-slate-700/60 pb-1.5">
    <span class="font-bold text-white tracking-tight text-[13px]">{{ tooltip.title }}</span>
    <span :class="tooltip.badgeClass" class="text-[10px] font-semibold px-2 py-0.5 rounded border">
      {{ tooltip.badge }}
    </span>
  </div>
  <p class="text-[11px] text-slate-300 leading-snug">{{ tooltip.subtitle }}</p>
  <div class="flex items-center justify-between gap-3 pt-1 border-t border-slate-800/80">
    <span class="text-slate-400 font-medium">Nilai / Estimasi:</span>
    <span class="font-mono font-bold text-sm text-emerald-400">{{ tooltip.value }}</span>
  </div>
  <div v-if="tooltip.ciRange" class="flex items-center justify-between gap-3 text-[11px] text-slate-300">
    <span class="text-slate-400">Rentang / Info:</span>
    <span class="font-mono text-slate-200 font-medium">{{ tooltip.ciRange }}</span>
  </div>
  <div v-if="tooltip.notes" class="pt-1 text-[10px] text-slate-400 italic border-t border-slate-800">
    {{ tooltip.notes }}
  </div>
</div>

<!-- Scaled Vector Graphics Chart Viewport -->
<svg class="w-full h-auto select-none overflow-visible" id="arima-main-svg" preserveAspectRatio="xMidYMid meet" viewBox="0 0 1000 380" @mouseleave="hideTooltip">
<defs>
<!-- Gradient for Confidence Interval Band -->
<linearGradient id="ciGradient" x1="0%" x2="0%" y1="0%" y2="100%">
<stop offset="0%" stop-color="#38bdf8" stop-opacity="0.35"></stop>
<stop offset="100%" stop-color="#38bdf8" stop-opacity="0.08"></stop>
</linearGradient>
<!-- Gradient under Forecast Line -->
<linearGradient id="forecastArea" x1="0%" x2="0%" y1="0%" y2="100%">
<stop offset="0%" stop-color="#0284c7" stop-opacity="0.18"></stop>
<stop offset="100%" stop-color="#0284c7" stop-opacity="0.0"></stop>
</linearGradient>
</defs>
<!-- Horizontal Grid Lines & Y-Labels with Safe Left Padding (X=72 for text, start line at 75) -->
<g class="font-mono text-[12px] pointer-events-none">
<!-- Rp 15.000 -->
<line stroke="#cbd5e1" stroke-dasharray="4 4" stroke-opacity="0.75" x1="75" x2="965" y1="40" y2="40"></line>
<text fill="#475569" font-family="'JetBrains Mono', monospace" font-size="12" text-anchor="end" x="68" y="44">Rp {{ Number(chartPriceBase + chartPriceStep * 2).toLocaleString('id-ID') }}</text>
<!-- Rp 14.700 -->
<line stroke="#cbd5e1" stroke-dasharray="4 4" stroke-opacity="0.75" x1="75" x2="965" y1="100" y2="100"></line>
<text fill="#475569" font-family="'JetBrains Mono', monospace" font-size="12" text-anchor="end" x="68" y="104">Rp {{ Number(chartPriceBase + chartPriceStep).toLocaleString('id-ID') }}</text>
<!-- Rp 14.400 -->
<line stroke="#cbd5e1" stroke-dasharray="4 4" stroke-opacity="0.75" x1="75" x2="965" y1="160" y2="160"></line>
<text fill="#475569" font-family="'JetBrains Mono', monospace" font-size="12" text-anchor="end" x="68" y="164">Rp {{ Number(chartPriceBase).toLocaleString('id-ID') }}</text>
<!-- Rp 14.100 -->
<line stroke="#cbd5e1" stroke-dasharray="4 4" stroke-opacity="0.75" x1="75" x2="965" y1="220" y2="220"></line>
<text fill="#475569" font-family="'JetBrains Mono', monospace" font-size="12" text-anchor="end" x="68" y="224">Rp {{ Number(chartPriceBase - chartPriceStep).toLocaleString('id-ID') }}</text>
<!-- Rp 13.800 -->
<line stroke="#cbd5e1" stroke-dasharray="4 4" stroke-opacity="0.75" x1="75" x2="965" y1="280" y2="280"></line>
<text fill="#475569" font-family="'JetBrains Mono', monospace" font-size="12" text-anchor="end" x="68" y="284">Rp {{ Number(chartPriceBase - chartPriceStep * 2).toLocaleString('id-ID') }}</text>
</g>

<!-- Unified Split Horizon Group with Stable Hover Target -->
<g class="cursor-pointer" @mousemove="handleSplitHover($event)" @mouseenter="handleSplitHover($event)">
  <rect fill="#f1f5f9" fill-opacity="0.7" height="260" rx="6" stroke="#e2e8f0" width="275" x="690" y="30"
        class="hover:fill-rose-50/60 transition-colors"></rect>
  <line stroke="#dc2626" stroke-dasharray="4 3" stroke-width="2.5" x1="690" x2="690" y1="26" y2="295"></line>
  <circle cx="690" cy="26" fill="#dc2626" r="5" stroke="#ffffff" stroke-width="1.5"></circle>
  <text fill="#dc2626" font-family="'Inter', sans-serif" font-size="11" font-weight="700" x="698" y="38" class="select-none">SPLIT HORIZON (Hari Ini)</text>
</g>

<!-- 95% Confidence Interval Ribbon with Tooltip -->
<polygon class="transition-all duration-300 cursor-pointer hover:opacity-90" fill="url(#ciGradient)" id="ci-polygon"
         @mousemove.stop="handleCiHover($event)"
         @mouseenter.stop="handleCiHover($event)"
         points="
690,140 730,132 770,125 810,120 850,115 890,108 930,102 960,98
960,195 930,190 890,186 850,182 810,178 770,172 730,165 690,140
"></polygon>

<!-- Area Under Forecast Line -->
<polygon fill="url(#forecastArea)" points="
690,140 730,145 770,148 810,146 850,144 890,141 930,138 960,135
960,280 690,280
" class="pointer-events-none"></polygon>

<!-- a) Data Training Line (Historical t-60 to t-18) [x:75 to 520] -->
<path d="
M75,260 L100,255 L130,248 L160,252 L190,240 L220,235 L250,225 L280,230
L310,215 L340,210 L370,198 L400,195 L430,185 L460,178 L490,182 L520,170
" fill="none" id="train-path" stroke="#334155" stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" class="pointer-events-none"></path>
<!-- Split Connector -->
<path d="M520,170 L560,165" fill="none" stroke="#64748b" stroke-dasharray="2 3" stroke-width="2" class="pointer-events-none"></path>
<!-- b) Data Testing Aktual (t-18 to Today) [x:560 to 690] -->
<path d="
M560,165 L600,158 L630,152 L660,148 L690,140
" fill="none" id="test-path" stroke="#059669" stroke-dasharray="4 4" stroke-linecap="round" stroke-width="2.5" class="pointer-events-none"></path>
<!-- c) ARIMA Forecast Line (Today to t+30) [x:690 to 960] -->
<path d="
M690,140 L730,145 L770,148 L810,146 L850,144 L890,141 L930,138 L960,135
" fill="none" id="forecast-path" stroke="#0284c7" stroke-linecap="round" stroke-linejoin="round" stroke-width="3" class="pointer-events-none"></path>

<!-- Forecast Data Points with Tooltip Handlers -->
<g class="cursor-pointer" fill="#0284c7" stroke="#ffffff" stroke-width="2">
  <g v-for="(pt, idx) in forecastPoints" :key="'fc2-'+idx"
     @mousemove.stop="handlePointHover($event, pt)"
     @mouseenter.stop="handlePointHover($event, pt)">
    <circle :cx="pt.cx" :cy="pt.cy" r="12" fill="transparent" stroke="none" />
    <circle class="chart-point transition-transform"
            :cx="pt.cx" :cy="pt.cy" :r="pt.r" :fill="pt.fill || '#0284c7'" />
  </g>
</g>

<!-- Testing Markers with Tooltip Handlers -->
<g class="cursor-pointer" fill="#059669" stroke="#ffffff" stroke-width="1.5">
  <g v-for="(pt, idx) in testingPoints" :key="'test2-'+idx"
     @mousemove.stop="handlePointHover($event, pt)"
     @mouseenter.stop="handlePointHover($event, pt)">
    <circle :cx="pt.cx" :cy="pt.cy" r="10" fill="transparent" stroke="none" />
    <circle class="chart-point transition-transform"
            :cx="pt.cx" :cy="pt.cy" :r="pt.r" />
  </g>
</g>

<!-- Historical Training Markers with Tooltip Handlers -->
<g class="cursor-pointer" fill="#334155" stroke="#ffffff" stroke-width="1.5">
  <g v-for="(pt, idx) in trainingPoints" :key="'train2-'+idx"
     @mousemove.stop="handlePointHover($event, pt)"
     @mouseenter.stop="handlePointHover($event, pt)">
    <circle :cx="pt.cx" :cy="pt.cy" r="10" fill="transparent" stroke="none" />
    <circle class="chart-point transition-transform opacity-75"
            :cx="pt.cx" :cy="pt.cy" :r="3" />
  </g>
</g>

<!-- X-Axis Labels (Timeline Dates) with Clear Bottom Padding (Y=330, SVG height 380) -->
<g fill="#475569" font-family="'JetBrains Mono', monospace" font-size="11">
<text text-anchor="middle" x="75" y="328">T-60 (20 Jan)</text>
<text text-anchor="middle" x="220" y="328">T-45 (04 Feb)</text>
<text text-anchor="middle" x="370" y="328">T-30 (19 Feb)</text>
<text text-anchor="middle" x="520" y="328">T-15 (05 Mar)</text>
<text fill="#dc2626" font-weight="700" text-anchor="middle" x="690" y="328">Hari Ini (20 Mar)</text>
<text fill="#0284c7" font-weight="600" text-anchor="middle" x="810" y="328">T+15 (04 Apr)</text>
<text fill="#047857" font-weight="700" text-anchor="middle" x="960" y="328">T+30 (20 Apr)</text>
</g>
</svg>
</div>
</div>
<!-- 4. Kartu Metrik Evaluasi & Uji Statistik (4 KPI Cards with Semantics) -->
<div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
<!-- KPI 1: ADF Test -->
<div class="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-xs flex flex-col justify-between gap-3 relative overflow-hidden">
<div class="absolute top-0 left-0 h-1.5 w-full bg-emerald-600"></div>
<div class="flex items-center justify-between">
<span class="text-xs uppercase text-slate-500 font-bold tracking-wider">Augmented Dickey-Fuller</span>
<span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-800 border border-emerald-300 font-mono">Stasioner d=1</span>
</div>
<div>
<div class="flex items-baseline gap-2">
<span class="font-mono text-2xl font-bold text-slate-900" id="metric-adf-stat">-3.842</span>
<span class="text-xs text-slate-400 font-mono">t-stat</span>
</div>
<p class="font-mono text-xs text-emerald-700 font-semibold mt-1">
p-value = 0.0024 <span class="text-slate-500 font-normal">(&lt; 0.05)</span>
</p>
</div>
<div class="text-xs text-slate-600 bg-slate-50 border border-slate-200 p-2.5 rounded-lg flex items-center gap-2">
<span class="material-symbols-outlined text-[16px] text-emerald-700">check_circle</span>
<span>Deret waktu terbukti stasioner pada orde integrasi I(1).</span>
</div>
</div>
<!-- KPI 2: Best Fitted Model -->
<div class="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-xs flex flex-col justify-between gap-3 relative overflow-hidden">
<div class="absolute top-0 left-0 h-1.5 w-full bg-sky-600"></div>
<div class="flex items-center justify-between">
<span class="text-xs uppercase text-slate-500 font-bold tracking-wider">Best Fitted Model</span>
<span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-sky-100 text-sky-800 border border-sky-300 font-mono">Parasimoni</span>
</div>
<div>
<div class="flex items-baseline gap-2">
<span class="font-mono text-2xl font-bold text-sky-800" id="metric-order">ARIMA(1, 1, 2)</span>
</div>
<div class="flex items-center gap-3 mt-1 font-mono text-xs text-slate-600">
<span>AIC: <strong class="text-slate-900" id="metric-aic">412.30</strong></span>
<span>BIC: <strong class="text-slate-900" id="metric-bic">421.15</strong></span>
</div>
</div>
<div class="text-xs text-slate-600 bg-slate-50 border border-slate-200 p-2.5 rounded-lg flex items-center gap-2">
<span class="material-symbols-outlined text-[16px] text-sky-700">model_training</span>
<span>Model meminimalkan Information Criterion secara global.</span>
</div>
</div>
<!-- KPI 3: Accuracy Walk-Forward -->
<div class="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-xs flex flex-col justify-between gap-3 relative overflow-hidden">
<div class="absolute top-0 left-0 h-1.5 w-full bg-emerald-700"></div>
<div class="flex items-center justify-between">
<span class="text-xs uppercase text-slate-500 font-bold tracking-wider">Walk-Forward 10-Fold</span>
<!-- Semantics: Status Green Pill -->
<span class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300">Sangat Baik (&lt;10%)</span>
</div>
<div>
<div class="flex items-baseline gap-2">
<span class="font-mono text-2xl font-bold text-emerald-800" id="metric-mape">3.42%</span>
<span class="text-xs text-slate-400 font-mono">MAPE</span>
</div>
<div class="flex items-center gap-3 mt-1 font-mono text-xs text-slate-600">
<span>RMSE: <strong class="text-slate-900" id="metric-rmse">Rp 184.2</strong></span>
<span>MAE: <strong class="text-slate-900" id="metric-mae">Rp 142.0</strong></span>
</div>
</div>
<div class="text-xs text-slate-600 bg-slate-50 border border-slate-200 p-2.5 rounded-lg flex items-center gap-2">
<span class="material-symbols-outlined text-[16px] text-emerald-700">verified</span>
<span>Akurasi tinggi dan presisi untuk proyeksi harga PMT.</span>
</div>
</div>
<!-- KPI 4: Ljung-Box Test -->
<div class="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-xs flex flex-col justify-between gap-3 relative overflow-hidden">
<div class="absolute top-0 left-0 h-1.5 w-full bg-indigo-600"></div>
<div class="flex items-center justify-between">
<span class="text-xs uppercase text-slate-500 font-bold tracking-wider">Diagnostik Residual</span>
<span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-indigo-100 text-indigo-800 border border-indigo-300 font-mono">White Noise</span>
</div>
<div>
<div class="flex items-baseline gap-2">
<span class="font-mono text-2xl font-bold text-slate-900" id="metric-lb-stat">Q: 0.412</span>
<span class="text-xs text-slate-400 font-mono">Lag=10</span>
</div>

</div>
<div class="text-xs text-slate-600 bg-slate-50 border border-slate-200 p-2.5 rounded-lg flex items-center gap-2">
<span class="material-symbols-outlined text-[16px] text-indigo-700">check_box</span>
<span>Residual terdistribusi acak tanpa pola sisa.</span>
</div>
</div>
</div>
<!-- 5. Visualisasi Diagnostik Residual (2 Kolom Sub-cards) -->
<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
<!-- Kolom Kiri: Residual Plot & KDE Normal Distribution -->
<div class="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-xs flex flex-col gap-3">
<div class="flex items-center justify-between border-b border-slate-100 pb-2">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-emerald-800 text-[20px]">show_chart</span>
<h4 class="text-sm font-bold text-slate-900">Residual vs Waktu &amp; Distribusi Normal</h4>
</div>
<span class="font-mono text-[11px] px-2.5 py-0.5 rounded bg-slate-100 border border-slate-200 text-slate-700 font-medium">Mean ≈ 0.003 | σ = 0.88</span>
</div>

<!-- Residual Line Plot SVG -->
<div class="bg-slate-50 border border-slate-200 rounded-xl p-3">
<svg class="w-full h-auto" viewbox="0 0 500 160">
<!-- Zero reference line -->
<line stroke="#cbd5e1" stroke-dasharray="3 3" stroke-width="1.5" x1="40" x2="480" y1="80" y2="80"></line>
<text fill="#64748b" font-family="'JetBrains Mono', monospace" font-size="11" text-anchor="end" x="32" y="84">0</text>
<text fill="#64748b" font-family="'JetBrains Mono', monospace" font-size="11" text-anchor="end" x="32" y="34">+2σ</text>
<text fill="#64748b" font-family="'JetBrains Mono', monospace" font-size="11" text-anchor="end" x="32" y="134">-2σ</text>
<!-- Normal bounds -->
<line stroke="#dc2626" stroke-dasharray="2 2" stroke-opacity="0.5" stroke-width="1" x1="40" x2="480" y1="30" y2="30"></line>
<line stroke="#dc2626" stroke-dasharray="2 2" stroke-opacity="0.5" stroke-width="1" x1="40" x2="480" y1="130" y2="130"></line>
<!-- Scatter of Residuals with Lines -->
<path d="
M40,82 L60,75 L80,92 L100,68 L120,85 L140,78 L160,88 L180,72 L200,83 L220,65 L240,95
L260,78 L280,82 L300,74 L320,89 L340,62 L360,86 L380,79 L400,92 L420,75 L440,84 L460,70 L480,81
" fill="none" stroke="#059669" stroke-linecap="round" stroke-width="2"></path>
<!-- Scatter dots -->
<g fill="#047857">
<circle cx="60" cy="75" r="3"></circle><circle cx="100" cy="68" r="3"></circle>
<circle cx="140" cy="78" r="3"></circle><circle cx="180" cy="72" r="3"></circle>
<circle cx="220" cy="65" r="3"></circle><circle cx="260" cy="78" r="3"></circle>
<circle cx="300" cy="74" r="3"></circle><circle cx="340" cy="62" r="3"></circle>
<circle cx="380" cy="79" r="3"></circle><circle cx="420" cy="75" r="3"></circle>
<circle cx="460" cy="70" r="3"></circle><circle cx="480" cy="81" r="3"></circle>
<circle cx="80" cy="92" r="3"></circle><circle cx="120" cy="85" r="3"></circle>
<circle cx="160" cy="88" r="3"></circle><circle cx="200" cy="83" r="3"></circle>
<circle cx="240" cy="95" r="3"></circle><circle cx="280" cy="82" r="3"></circle>
<circle cx="320" cy="89" r="3"></circle><circle cx="360" cy="86" r="3"></circle>
<circle cx="400" cy="92" r="3"></circle><circle cx="440" cy="84" r="3"></circle>
</g>
</svg>
</div>
<div class="flex items-center justify-between text-xs text-slate-500 pt-1">
<span class="flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-emerald-600"></span> Uji Shapiro-Wilk: W=0.984 (p=0.48, Normal)</span>
<span class="font-mono text-slate-700">Lag Horizon: N=60</span>
</div>
</div>
<!-- Kolom Kanan: ACF & PACF Plots -->
<div class="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-xs flex flex-col gap-3">
<div class="flex items-center justify-between border-b border-slate-100 pb-2">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-sky-700 text-[20px]">analytics</span>
<h4 class="text-sm font-bold text-slate-900">Korelogram Residual (ACF &amp; PACF)</h4>
</div>
<span class="font-mono text-[11px] px-2.5 py-0.5 rounded bg-sky-50 border border-sky-200 text-sky-800 font-medium">Batas ±1.96/√N (95% CI)</span>
</div>

<!-- ACF / PACF Bar Chart SVG -->
<div class="bg-slate-50 border border-slate-200 rounded-xl p-3">
<svg class="w-full h-auto" viewbox="0 0 500 160">
<!-- 95% Confidence Corridor Ribbon -->
<rect fill="#bae6fd" fill-opacity="0.35" height="50" rx="3" width="450" x="30" y="55"></rect>
<line stroke="#0284c7" stroke-dasharray="2 2" stroke-opacity="0.6" stroke-width="1" x1="30" x2="480" y1="55" y2="55"></line>
<line stroke="#0284c7" stroke-dasharray="2 2" stroke-opacity="0.6" stroke-width="1" x1="30" x2="480" y1="105" y2="105"></line>
<line stroke="#64748b" stroke-width="1.2" x1="30" x2="480" y1="80" y2="80"></line>
<!-- ACF Spikes (Lags 1 to 12) -->
<g fill="#0284c7" stroke="#0284c7" stroke-width="2.5">
<line x1="60" x2="60" y1="80" y2="72"></line><circle cx="60" cy="72" r="3"></circle>
<line x1="95" x2="95" y1="80" y2="86"></line><circle cx="95" cy="86" r="3"></circle>
<line x1="130" x2="130" y1="80" y2="76"></line><circle cx="130" cy="76" r="3"></circle>
<line x1="165" x2="165" y1="80" y2="84"></line><circle cx="165" cy="84" r="3"></circle>
<line x1="200" x2="200" y1="80" y2="78"></line><circle cx="200" cy="78" r="3"></circle>
<line x1="235" x2="235" y1="80" y2="88"></line><circle cx="235" cy="88" r="3"></circle>
<line x1="270" x2="270" y1="80" y2="74"></line><circle cx="270" cy="74" r="3"></circle>
<line x1="305" x2="305" y1="80" y2="82"></line><circle cx="305" cy="82" r="3"></circle>
<line x1="340" x2="340" y1="80" y2="85"></line><circle cx="340" cy="85" r="3"></circle>
<line x1="375" x2="375" y1="80" y2="77"></line><circle cx="375" cy="77" r="3"></circle>
<line x1="410" x2="410" y1="80" y2="81"></line><circle cx="410" cy="81" r="3"></circle>
<line x1="445" x2="445" y1="80" y2="76"></line><circle cx="445" cy="76" r="3"></circle>
</g>
<!-- Lag labels min 11px -->
<g fill="#64748b" font-family="'JetBrains Mono', monospace" font-size="11" text-anchor="middle">
<text x="60" y="128">1</text><text x="95" y="128">2</text><text x="130" y="128">3</text>
<text x="165" y="128">4</text><text x="200" y="128">5</text><text x="235" y="128">6</text>
<text x="270" y="128">7</text><text x="305" y="128">8</text><text x="340" y="128">9</text>
<text x="375" y="128">10</text><text x="410" y="128">11</text><text x="445" y="128">12</text>
</g>
</svg>
</div>
<div class="flex items-center justify-between text-xs text-slate-500 pt-1">
<span class="flex items-center gap-1.5"><span class="w-2 h-2 rounded-full bg-sky-600"></span> Tidak ada lag yang melanggar batas signifikansi Bartlett</span>
<span class="font-mono text-slate-700">Max Lag: K=12</span>
</div>
</div>
</div>
<!-- 6. TABEL DIAGNOSTIK KOMODITAS: Header Bertingkat & Shadow Edge Wrapper -->
<div class="bg-white rounded-2xl p-6 border border-slate-200/80 shadow-xs flex flex-col gap-4">
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-100 pb-3">
<div class="flex flex-col gap-0.5">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-emerald-800 text-[22px]">table_chart</span>
<h3 class="text-base font-bold text-slate-900 tracking-tight">Matriks Evaluasi &amp; Diagnostik Komoditas Pangan Pokok</h3>
</div>

</div>
<div class="flex flex-wrap items-center gap-2 text-xs">
<span class="text-slate-500 font-medium">Standar Penerimaan:</span>
<span class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300">MAPE &lt; 10%</span>
<span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 border border-amber-300 font-mono">Ljung-Box p &gt; 0.05</span>
</div>
</div>
<!-- Responsive Table with Shadow Edge Indicator Wrapper -->
<div class="relative rounded-xl border border-slate-200 overflow-hidden shadow-xs">
<div class="overflow-x-auto w-full">
<table class="w-full text-left border-collapse text-xs">
<thead>
<!-- Top Multi-Level Category Grouping -->
<tr class="bg-slate-100/90 text-slate-600 font-bold uppercase tracking-wider text-[11px] border-b border-slate-200">
<th class="py-2.5 px-4 border-r border-slate-200" scope="col">Identitas Komoditas</th>
<th class="py-2.5 px-4 text-center border-r border-slate-200" colspan="3" scope="col">Spesifikasi Model</th>
<th class="py-2.5 px-4 text-center border-r border-slate-200" colspan="2" scope="col">Metrik Akurasi</th>
<th class="py-2.5 px-4 text-center border-r border-slate-200" colspan="2" scope="col">Uji Diagnostik Residual</th>
<th class="py-2.5 px-4 text-center" scope="col">Aksi</th>
</tr>
<!-- Sub-level column headers -->
<tr class="bg-slate-50 text-slate-500 font-semibold uppercase tracking-wider text-[10px] border-b border-slate-200">
<th class="py-2.5 px-4 border-r border-slate-200">Nama Bahan Pangan</th>
<th class="py-2.5 px-3">Best Order (p,d,q)</th>
<th class="py-2.5 px-3 font-mono">AIC</th>
<th class="py-2.5 px-3 border-r border-slate-200">Split</th>
<th class="py-2.5 px-3">MAPE (%)</th>
<th class="py-2.5 px-3 border-r border-slate-200">RMSE (Rp)</th>
<th class="py-2.5 px-3">Status ADF</th>
<th class="py-2.5 px-3 border-r border-slate-200">Ljung-Box (p-val)</th>
<th class="py-2.5 px-4 text-center">Intervensi</th>
</tr>
</thead>
<tbody class="divide-y divide-slate-100" id="commodity-table-body">
<!-- Row 1: Beras Premium (Active Selected) -->
<tr class="hover:bg-slate-50/80 transition-colors bg-emerald-50/40">
<td class="py-3 px-4 font-semibold text-slate-900 flex items-center gap-2 border-r border-slate-100">
<span class="w-2.5 h-2.5 rounded-full bg-emerald-700"></span>
<span>Beras Premium</span>
</td>
<td class="py-3 px-3 font-mono text-sky-800 font-semibold">ARIMA(1, 1, 2)</td>
<td class="py-3 px-3 font-mono text-slate-700">412.30</td>
<td class="py-3 px-3 font-mono text-slate-600 border-r border-slate-100">80:20</td>
<td class="py-3 px-3">
<span class="px-2 py-0.5 rounded text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300 font-mono">3.42%</span>
</td>
<td class="py-3 px-3 font-mono font-medium text-slate-800 border-r border-slate-100">Rp 184.2</td>
<td class="py-3 px-3">
<span class="inline-flex items-center gap-1 text-emerald-800 text-[11px] font-semibold bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
<span class="material-symbols-outlined text-[14px]">check</span> Lolos (d=1)
</span>
</td>
<td class="py-3 px-3 font-mono border-r border-slate-100">
<span class="text-emerald-800 font-bold">0.725</span> <span class="text-slate-500 text-[10px]">(No Autocorr)</span>
</td>
<td class="py-3 px-4 text-center">
<button class="select-row-btn px-3 py-1.5 rounded-lg bg-emerald-800 text-white font-semibold text-xs hover:bg-emerald-900 transition-colors shadow-xs" data-id="beras">
Terpilih
</button>
</td>
</tr>
<!-- Row 2: Daging Ayam Ras -->
<tr class="hover:bg-slate-50/80 transition-colors">
<td class="py-3 px-4 font-semibold text-slate-900 flex items-center gap-2 border-r border-slate-100">
<span class="w-2.5 h-2.5 rounded-full bg-amber-600"></span>
<span>Daging Ayam Ras</span>
</td>
<td class="py-3 px-3 font-mono text-sky-800 font-semibold">ARIMA(2, 1, 1)</td>
<td class="py-3 px-3 font-mono text-slate-700">498.15</td>
<td class="py-3 px-3 font-mono text-slate-600 border-r border-slate-100">80:20</td>
<td class="py-3 px-3">
<span class="px-2 py-0.5 rounded text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300 font-mono">4.18%</span>
</td>
<td class="py-3 px-3 font-mono font-medium text-slate-800 border-r border-slate-100">Rp 392.5</td>
<td class="py-3 px-3">
<span class="inline-flex items-center gap-1 text-emerald-800 text-[11px] font-semibold bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
<span class="material-symbols-outlined text-[14px]">check</span> Lolos (d=1)
</span>
</td>
<td class="py-3 px-3 font-mono border-r border-slate-100">
<span class="text-emerald-800 font-bold">0.680</span> <span class="text-slate-500 text-[10px]">(No Autocorr)</span>
</td>
<td class="py-3 px-4 text-center">
<button class="select-row-btn px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold text-xs border border-slate-200 transition-colors" data-id="ayam">
Pilih
</button>
</td>
</tr>
<!-- Row 3: Telur Ayam Ras -->
<tr class="hover:bg-slate-50/80 transition-colors">
<td class="py-3 px-4 font-semibold text-slate-900 flex items-center gap-2 border-r border-slate-100">
<span class="w-2.5 h-2.5 rounded-full bg-amber-500"></span>
<span>Telur Ayam Ras</span>
</td>
<td class="py-3 px-3 font-mono text-sky-800 font-semibold">ARIMA(1, 1, 1)</td>
<td class="py-3 px-3 font-mono text-slate-700">386.40</td>
<td class="py-3 px-3 font-mono text-slate-600 border-r border-slate-100">80:20</td>
<td class="py-3 px-3">
<span class="px-2 py-0.5 rounded text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300 font-mono">3.88%</span>
</td>
<td class="py-3 px-3 font-mono font-medium text-slate-800 border-r border-slate-100">Rp 210.0</td>
<td class="py-3 px-3">
<span class="inline-flex items-center gap-1 text-emerald-800 text-[11px] font-semibold bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
<span class="material-symbols-outlined text-[14px]">check</span> Lolos (d=1)
</span>
</td>
<td class="py-3 px-3 font-mono border-r border-slate-100">
<span class="text-emerald-800 font-bold">0.814</span> <span class="text-slate-500 text-[10px]">(No Autocorr)</span>
</td>
<td class="py-3 px-4 text-center">
<button class="select-row-btn px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold text-xs border border-slate-200 transition-colors" data-id="telur">
Pilih
</button>
</td>
</tr>
<!-- Row 4: Ikan Kembung -->
<tr class="hover:bg-slate-50/80 transition-colors">
<td class="py-3 px-4 font-semibold text-slate-900 flex items-center gap-2 border-r border-slate-100">
<span class="w-2.5 h-2.5 rounded-full bg-sky-600"></span>
<span>Ikan Kembung Segar</span>
</td>
<td class="py-3 px-3 font-mono text-sky-800 font-semibold">ARIMA(0, 1, 2)</td>
<td class="py-3 px-3 font-mono text-slate-700">514.80</td>
<td class="py-3 px-3 font-mono text-slate-600 border-r border-slate-100">70:30</td>
<td class="py-3 px-3">
<span class="px-2 py-0.5 rounded text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300 font-mono">5.20%</span>
</td>
<td class="py-3 px-3 font-mono font-medium text-slate-800 border-r border-slate-100">Rp 440.0</td>
<td class="py-3 px-3">
<span class="inline-flex items-center gap-1 text-emerald-800 text-[11px] font-semibold bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
<span class="material-symbols-outlined text-[14px]">check</span> Lolos (d=1)
</span>
</td>
<td class="py-3 px-3 font-mono border-r border-slate-100">
<span class="text-emerald-800 font-bold">0.590</span> <span class="text-slate-500 text-[10px]">(No Autocorr)</span>
</td>
<td class="py-3 px-4 text-center">
<button class="select-row-btn px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold text-xs border border-slate-200 transition-colors" data-id="ikan">
Pilih
</button>
</td>
</tr>
<!-- Row 5: Wortel Segar -->
<tr class="hover:bg-slate-50/80 transition-colors">
<td class="py-3 px-4 font-semibold text-slate-900 flex items-center gap-2 border-r border-slate-100">
<span class="w-2.5 h-2.5 rounded-full bg-orange-600"></span>
<span>Wortel Segar Lokal</span>
</td>
<td class="py-3 px-3 font-mono text-sky-800 font-semibold">ARIMA(1, 1, 0)</td>
<td class="py-3 px-3 font-mono text-slate-700">345.10</td>
<td class="py-3 px-3 font-mono text-slate-600 border-r border-slate-100">90:10</td>
<td class="py-3 px-3">
<span class="px-2 py-0.5 rounded text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300 font-mono">4.65%</span>
</td>
<td class="py-3 px-3 font-mono font-medium text-slate-800 border-r border-slate-100">Rp 165.4</td>
<td class="py-3 px-3">
<span class="inline-flex items-center gap-1 text-emerald-800 text-[11px] font-semibold bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
<span class="material-symbols-outlined text-[14px]">check</span> Lolos (d=1)
</span>
</td>
<td class="py-3 px-3 font-mono border-r border-slate-100">
<span class="text-emerald-800 font-bold">0.740</span> <span class="text-slate-500 text-[10px]">(No Autocorr)</span>
</td>
<td class="py-3 px-4 text-center">
<button class="select-row-btn px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold text-xs border border-slate-200 transition-colors" data-id="wortel">
Pilih
</button>
</td>
</tr>
<!-- Row 6: Kentang Dieng -->
<tr class="hover:bg-slate-50/80 transition-colors">
<td class="py-3 px-4 font-semibold text-slate-900 flex items-center gap-2 border-r border-slate-100">
<span class="w-2.5 h-2.5 rounded-full bg-amber-700"></span>
<span>Kentang Dieng Sedang</span>
</td>
<td class="py-3 px-3 font-mono text-sky-800 font-semibold">ARIMA(2, 1, 2)</td>
<td class="py-3 px-3 font-mono text-slate-700">420.25</td>
<td class="py-3 px-3 font-mono text-slate-600 border-r border-slate-100">80:20</td>
<td class="py-3 px-3">
<span class="px-2 py-0.5 rounded text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300 font-mono">3.95%</span>
</td>
<td class="py-3 px-3 font-mono font-medium text-slate-800 border-r border-slate-100">Rp 230.8</td>
<td class="py-3 px-3">
<span class="inline-flex items-center gap-1 text-emerald-800 text-[11px] font-semibold bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
<span class="material-symbols-outlined text-[14px]">check</span> Lolos (d=1)
</span>
</td>
<td class="py-3 px-3 font-mono border-r border-slate-100">
<span class="text-emerald-800 font-bold">0.695</span> <span class="text-slate-500 text-[10px]">(No Autocorr)</span>
</td>
<td class="py-3 px-4 text-center">
<button class="select-row-btn px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold text-xs border border-slate-200 transition-colors" data-id="kentang">
Pilih
</button>
</td>
</tr>
<!-- Row 7: Buncis Hijau -->
<tr class="hover:bg-slate-50/80 transition-colors">
<td class="py-3 px-4 font-semibold text-slate-900 flex items-center gap-2 border-r border-slate-100">
<span class="w-2.5 h-2.5 rounded-full bg-emerald-600"></span>
<span>Buncis Hijau Manis</span>
</td>
<td class="py-3 px-3 font-mono text-sky-800 font-semibold">ARIMA(1, 0, 1)</td>
<td class="py-3 px-3 font-mono text-slate-700">310.50</td>
<td class="py-3 px-3 font-mono text-slate-600 border-r border-slate-100">80:20</td>
<td class="py-3 px-3">
<span class="px-2 py-0.5 rounded text-xs font-bold bg-amber-100 text-amber-800 border border-amber-300 font-mono">6.12%</span>
</td>
<td class="py-3 px-3 font-mono font-medium text-slate-800 border-r border-slate-100">Rp 195.0</td>
<td class="py-3 px-3">
<span class="inline-flex items-center gap-1 text-emerald-800 text-[11px] font-semibold bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
<span class="material-symbols-outlined text-[14px]">check</span> Lolos (d=0)
</span>
</td>
<td class="py-3 px-3 font-mono border-r border-slate-100">
<span class="text-emerald-800 font-bold">0.612</span> <span class="text-slate-500 text-[10px]">(No Autocorr)</span>
</td>
<td class="py-3 px-4 text-center">
<button class="select-row-btn px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold text-xs border border-slate-200 transition-colors" data-id="buncis">
Pilih
</button>
</td>
</tr>
<!-- Row 8: Daging Sapi Murni -->
<tr class="hover:bg-slate-50/80 transition-colors">
<td class="py-3 px-4 font-semibold text-slate-900 flex items-center gap-2 border-r border-slate-100">
<span class="w-2.5 h-2.5 rounded-full bg-rose-700"></span>
<span>Daging Sapi Murni</span>
</td>
<td class="py-3 px-3 font-mono text-sky-800 font-semibold">ARIMA(1, 1, 1)</td>
<td class="py-3 px-3 font-mono text-slate-700">580.40</td>
<td class="py-3 px-3 font-mono text-slate-600 border-r border-slate-100">80:20</td>
<td class="py-3 px-3">
<span class="px-2 py-0.5 rounded text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300 font-mono">2.91%</span>
</td>
<td class="py-3 px-3 font-mono font-medium text-slate-800 border-r border-slate-100">Rp 820.0</td>
<td class="py-3 px-3">
<span class="inline-flex items-center gap-1 text-emerald-800 text-[11px] font-semibold bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
<span class="material-symbols-outlined text-[14px]">check</span> Lolos (d=1)
</span>
</td>
<td class="py-3 px-3 font-mono border-r border-slate-100">
<span class="text-emerald-800 font-bold">0.852</span> <span class="text-slate-500 text-[10px]">(No Autocorr)</span>
</td>
<td class="py-3 px-4 text-center">
<button class="select-row-btn px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold text-xs border border-slate-200 transition-colors" data-id="sapi">
Pilih
</button>
</td>
</tr>
</tbody>
</table>
</div>
</div>
<!-- Table Summary Footnote -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pt-2 text-xs text-slate-500">
<span class="flex items-center gap-1.5">
<span class="material-symbols-outlined text-[16px] text-emerald-700">info</span>
Semua komoditas lolos verifikasi Walk-Forward 10-Fold dan siap dialirkan ke Modul 3: Financial Pattern Recognition (FPR).
</span>

</div>
</div>
</div>
</div>
</main></div>
</template>

<script setup>
import BaseButton from '../components/BaseButton.vue';
import Navbar from '../components/Navbar.vue';
import MetricCard from '../components/MetricCard.vue';
import Sidebar from '../components/Sidebar.vue';
import { ref, computed } from 'vue';

// Selected state
const activeSplitRatio = ref('80:20');
const activeCommodityName = ref('Beras Premium');
const chartPriceBase = ref(14500);

const chartPriceStep = computed(() => {
  return Math.max(100, Math.round((chartPriceBase.value * 0.02) / 50) * 50);
});

// Tooltip State & Handlers
const tooltip = ref({
  visible: false,
  x: 0,
  y: 0,
  title: '',
  subtitle: '',
  value: '',
  ciRange: '',
  badge: '',
  badgeClass: '',
  notes: ''
});

const showTooltip = (event, data) => {
  const wrapper = document.getElementById('main-chart-wrapper');
  if (wrapper) {
    const rect = wrapper.getBoundingClientRect();
    tooltip.value = {
      visible: true,
      x: event.clientX - rect.left,
      y: event.clientY - rect.top,
      ...data
    };
  }
};

const hideTooltip = () => {
  tooltip.value.visible = false;
};

const handleSplitHover = (event) => {
  const currentPrice = chartPriceBase.value;
  showTooltip(event, {
    title: 'Split Horizon (Hari Ini)',
    subtitle: 'Batas Pemisah Data Pelatihan/Uji vs Proyeksi 30 Hari',
    value: 'Rp ' + Number(currentPrice).toLocaleString('id-ID'),
    ciRange: 'Titik Cutoff Horizon 0 (Data Aktual Terakhir)',
    badge: 'SPLIT HORIZON',
    badgeClass: 'bg-rose-950 text-rose-300 border-rose-800',
    notes: `Skenario Split: ${activeSplitRatio.value} | Model Fit: ARIMA(1,1,1)`
  });
};

const handleCiHover = (event) => {
  const currentPrice = chartPriceBase.value;
  const spread = Math.round(currentPrice * 0.035);
  showTooltip(event, {
    title: 'Pita Keyakinan 95% (Confidence Interval)',
    subtitle: 'Rentang batas atas (upper) & batas bawah (lower) ketidakpastian proyeksi',
    value: 'Rp ' + Number(currentPrice).toLocaleString('id-ID') + ` (± Rp ${spread.toLocaleString('id-ID')})`,
    ciRange: `Rp ${(currentPrice - spread).toLocaleString('id-ID')} - Rp ${(currentPrice + spread).toLocaleString('id-ID')}`,
    badge: '95% CI Ribbon',
    badgeClass: 'bg-sky-950 text-sky-300 border-sky-800',
    notes: 'Estimasi ketidakpastian melebar seiring bertambahnya horizon peramalan'
  });
};

const handlePointHover = (event, pt) => {
  showTooltip(event, {
    title: pt.title,
    subtitle: pt.subtitle,
    value: pt.value,
    ciRange: pt.ciRange,
    badge: pt.badge,
    badgeClass: pt.badgeClass,
    notes: pt.notes
  });
};

// Points Collections for Chart
const forecastPoints = computed(() => {
  const base = chartPriceBase.value;
  const rawList = [
    { cx: 690, cy: 140, r: 5, date: '20 Mar (Hari Ini)', offsetPct: 0.0, ciOffset: 0.0, title: 'Hari Ini (T-0)' },
    { cx: 730, cy: 145, r: 5, date: '25 Mar (H+5)', offsetPct: -0.002, ciOffset: 0.015, title: '25 Mar (H+5)' },
    { cx: 770, cy: 148, r: 5, date: '30 Mar (H+10)', offsetPct: -0.004, ciOffset: 0.018, title: '30 Mar (H+10)' },
    { cx: 810, cy: 146, r: 5, date: '04 Apr (H+15)', offsetPct: -0.003, ciOffset: 0.022, title: '04 Apr (H+15)' },
    { cx: 850, cy: 144, r: 5, date: '09 Apr (H+20)', offsetPct: -0.001, ciOffset: 0.026, title: '09 Apr (H+20)' },
    { cx: 890, cy: 141, r: 5, date: '14 Apr (H+25)', offsetPct: 0.002, ciOffset: 0.030, title: '14 Apr (H+25)' },
    { cx: 930, cy: 138, r: 5, date: '19 Apr (H+29)', offsetPct: 0.004, ciOffset: 0.034, title: '19 Apr (H+29)' },
    { cx: 960, cy: 135, r: 5.5, fill: '#047857', date: '20 Apr (H+30)', offsetPct: 0.006, ciOffset: 0.038, title: '20 Apr (H+30)' }
  ];

  return rawList.map(item => {
    const val = Math.round(base * (1 + item.offsetPct));
    const ciDelta = Math.round(base * item.ciOffset);
    return {
      ...item,
      title: item.title,
      subtitle: item.cx === 690 ? 'Titik Awal Split Horizon' : 'Proyeksi Titik Deret Waktu Masa Depan',
      value: 'Rp ' + Number(val).toLocaleString('id-ID'),
      ciRange: ciDelta === 0 ? 'Data Aktual Titik Awal' : `Rp ${(val - ciDelta).toLocaleString('id-ID')} - Rp ${(val + ciDelta).toLocaleString('id-ID')}`,
      badge: item.cx === 690 ? 'SPLIT HORIZON' : 'ARIMA FORECAST',
      badgeClass: item.cx === 690 ? 'bg-rose-950 text-rose-300 border-rose-800' : 'bg-sky-950 text-sky-300 border-sky-800',
      notes: 'Model: ARIMA(1, 1, 1) (AIC: 412.30)'
    };
  });
});

const testingPoints = computed(() => {
  const base = chartPriceBase.value;
  const rawList = [
    { cx: 560, cy: 165, r: 4, date: '01 Mar (T-18)', offset: -0.009 },
    { cx: 600, cy: 158, r: 4, date: '06 Mar (T-13)', offset: -0.006 },
    { cx: 630, cy: 152, r: 4, date: '11 Mar (T-8)', offset: -0.003 },
    { cx: 660, cy: 148, r: 4, date: '16 Mar (T-3)', offset: -0.001 }
  ];

  return rawList.map(item => {
    const val = Math.round(base * (1 + item.offset));
    return {
      ...item,
      title: item.date,
      subtitle: 'Data Aktual Testing (Out-of-Sample Validation)',
      value: 'Rp ' + Number(val).toLocaleString('id-ID'),
      ciRange: 'Data Riil Terverifikasi',
      badge: 'TESTING SET',
      badgeClass: 'bg-emerald-950 text-emerald-300 border-emerald-800',
      notes: `Split Skenario: ${activeSplitRatio.value}`
    };
  });
});

const trainingPoints = computed(() => {
  const base = chartPriceBase.value;
  const rawList = [
    { cx: 75, cy: 260, date: '20 Jan (T-60)', offset: -0.04 },
    { cx: 190, cy: 240, date: '01 Feb (T-48)', offset: -0.03 },
    { cx: 310, cy: 215, date: '13 Feb (T-36)', offset: -0.02 },
    { cx: 430, cy: 185, date: '25 Feb (T-24)', offset: -0.012 },
    { cx: 520, cy: 170, date: '05 Mar (T-15)', offset: -0.005 }
  ];

  return rawList.map(item => {
    const val = Math.round(base * (1 + item.offset));
    return {
      ...item,
      title: item.date,
      subtitle: 'Data Historis Pelatihan Model (Training In-Sample)',
      value: 'Rp ' + Number(val).toLocaleString('id-ID'),
      ciRange: 'Observasi Historis Harian',
      badge: 'TRAINING SET',
      badgeClass: 'bg-slate-800 text-slate-200 border-slate-700',
      notes: 'Digunakan untuk fitting parameter order p, d, q'
    };
  });
});
</script>
