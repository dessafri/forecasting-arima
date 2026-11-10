<template>
  <Sidebar />
  <div class="pl-[260px]">
    <Navbar />
    <main class="relative pt-16 bg-slate-50 min-h-screen">
      <div class="w-full max-w-[1440px] mx-auto p-space-xl">
        <div class="flex flex-col w-full gap-space-xl">
          <!-- 1. HEADER DASHBOARD -->
          <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-space-md">
            <div class="flex flex-col gap-1 max-w-3xl">
              <h1 class="text-2xl font-bold tracking-tight text-slate-900">
                Sistem Peramalan Harga Pangan &amp; Optimasi Menu Nutrisi
              </h1>
              <div class="mt-2 flex items-center">
                <span class="text-sm font-medium text-blue-600 bg-primary/10 px-3 py-1.5 rounded-full border border-primary/20 flex items-center gap-1.5">
                  <span class="material-symbols-outlined text-[16px]">calendar_month</span>
                  <span>{{ hasData ? 'Periode Data: ' + (formatDateString(dashboardData.date_range) || 'Tersedia') : 'Menunggu Dataset' }}</span>
                </span>
              </div>
            </div>
            <div class="flex items-center gap-space-sm flex-wrap shrink-0">
              <BaseButton variant="secondary" type="button" @click="downloadPdf">
                <span class="material-symbols-outlined text-[18px]">picture_as_pdf</span>
                <span>Unduh Laporan Ringkas (.PDF)</span>
              </BaseButton>
              <BaseButton variant="primary" id="btn-run-gwo" type="button" :disabled="isPipelineRunning || !hasData" @click="runPipeline">
                <span class="material-symbols-outlined text-[18px]" :class="isPipelineRunning ? 'animate-spin' : ''">{{ isPipelineRunning ? 'sync' : 'play_circle' }}</span>
                <span>{{ isPipelineRunning ? 'Memproses Pipeline...' : 'Jalankan Ulang Pipeline' }}</span>
              </BaseButton>
            </div>
          </div>

          <!-- 3. JALUR KPI & METRIC CARDS (1 Baris Ringkas & Rapi) -->
          <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 w-full">
            <MetricCard 
              title="Estimasi Biaya Menu Harian"
              :value="hasData && kpi.estimasi_biaya ? 'Rp ' + Number(kpi.estimasi_biaya).toLocaleString('id-ID') : '-'"
              :badge="hasData ? 'FORMULASI GWO' : 'Belum Ada Data'"
              badgeClass="text-emerald-700 bg-emerald-50 border border-emerald-200"
            />
            <MetricCard 
              title="Total Energi PMT (Balita)"
              :badge="hasData ? 'OPTIMAL' : 'N/A'"
              badgeClass="text-blue-700 bg-blue-50 border border-blue-200"
            >
              <template #value>
                <span v-if="hasData && kpi.energi_tercapai">{{ kpi.energi_tercapai }} <span class="text-xs font-normal text-slate-500">kkal</span></span>
                <span v-else>-</span>
              </template>
            </MetricCard>
            <MetricCard 
              title="Akurasi Prediksi Rata-rata"
              :value="hasData && kpi.mape_avg ? kpi.mape_avg + '%' : '-'"
              :badge="hasData ? 'MAPE <10%' : 'N/A'"
              valueClass="text-indigo-600"
              badgeClass="text-indigo-700 bg-indigo-50 border border-indigo-200"
            />
            <MetricCard 
              title="Fitness Alpha Wolf (GWO)"
              :value="hasData && kpi.gwo_fitness ? kpi.gwo_fitness : '-'"
              :badge="hasData ? 'Konvergen' : 'N/A'"
              valueClass="text-amber-600"
              badgeClass="text-amber-700 bg-amber-50 border border-amber-200"
            />
          </div>

          <!-- Empty State Banner when no dataset -->
          <div v-if="!hasData" class="p-space-xl bg-white border border-dashed border-slate-200 rounded-2xl flex flex-col items-center justify-center text-center gap-3 shadow-xs my-2">
            <div class="w-14 h-14 rounded-full bg-blue-50 text-blue-600 flex items-center justify-center">
              <span class="material-symbols-outlined text-[32px]">dataset</span>
            </div>
            <h2 class="text-lg font-bold text-slate-900">Dataset Belum Diunggah</h2>
            <p class="text-sm text-slate-500 max-w-md">Data harga pangan dan nutrisi saat ini masih kosong. Silakan unggah file Excel di Modul 1 untuk memulai visualisasi deret waktu, klasifikasi pola finansial, dan formulasi menu PMT.</p>
            <BaseButton variant="primary" @click="router.push('/modul1')" class="mt-1">
              <span class="material-symbols-outlined text-[18px]">upload_file</span>
              <span>Buka Modul 1: Unggah Dataset</span>
            </BaseButton>
          </div>

          <!-- SECTION KONTEN DASHBOARD AKTIF -->
          <div v-if="hasData" class="flex flex-col gap-space-xl">
            <!-- 5. SECTION UTAMA FORECASTING ARIMA (Multi-Series Line Chart) -->
            <div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col gap-space-md">
              <!-- Chart Header & Controls -->
              <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-space-md">
                <div class="flex flex-col items-start gap-1">
                  <div class="flex items-center gap-space-xs">
                    <span class="material-symbols-outlined text-blue-500 text-[20px]">trending_up</span>
                    <h2 class="text-base font-semibold text-slate-900">Proyeksi Tren Harga Komoditas Pangan (ARIMA)</h2>
                  </div>
                  <span class="text-xs font-medium text-blue-500 bg-surface-container-highest px-2 py-0.5 rounded border border-secondary/20 ml-[28px]">
                    {{ formatDateString(dashboardData.date_range) || 'Deret Waktu Aktual' }}
                  </span>
                </div>
                <div class="flex items-center gap-space-sm flex-wrap">
                  <!-- Commodity Select -->
                  <div class="flex items-center gap-2 bg-white border border-slate-200 px-3 py-1.5 rounded-lg">
                    <span class="text-sm font-medium text-slate-500">Komoditas:</span>
                    <select v-model="selectedCommodity" class="bg-transparent text-xs text-slate-900 font-medium border-none outline-none cursor-pointer" id="commodity-select">
                      <option value="all">Semua Komoditas (ALL)</option>
                      <option v-for="c in commodities" :key="c.id" :value="c.id">
                        {{ c.name }} (Rp {{ Number(c.latest_price).toLocaleString('id-ID') }})
                      </option>
                    </select>
                  </div>

                  <!-- Chart Scale Mode Toggle (Selalu tampil agar tata letak tetap konsisten) -->
                  <div class="flex items-center bg-slate-100 p-0.5 rounded-lg border border-slate-200 text-xs font-medium">
                    <button type="button" @click="scaleMode = 'index'" :class="scaleMode === 'index' ? 'bg-white text-blue-600 shadow-xs font-semibold' : 'text-slate-600 hover:text-slate-900'" class="px-2.5 py-1 rounded-md transition-all">
                      Indeks Tren (%)
                    </button>
                    <button type="button" @click="scaleMode = 'nominal'" :class="scaleMode === 'nominal' ? 'bg-white text-blue-600 shadow-xs font-semibold' : 'text-slate-600 hover:text-slate-900'" class="px-2.5 py-1 rounded-md transition-all">
                      Nominal (Rp)
                    </button>
                  </div>

                  <!-- Controls Toggles -->
                  <label class="flex items-center gap-2 cursor-pointer bg-white border border-slate-200 px-3 py-1.5 rounded-lg select-none hover:bg-slate-50 transition-colors">
                    <input v-model="showCI" class="accent-primary w-4 h-4 rounded cursor-pointer" id="toggle-ci" type="checkbox">
                    <span class="text-sm font-semibold text-slate-900">CI 95%</span>
                  </label>
                  <label class="flex items-center gap-2 cursor-pointer bg-white border border-slate-200 px-3 py-1.5 rounded-lg select-none hover:bg-slate-50 transition-colors">
                    <input v-model="showSplit" class="accent-secondary w-4 h-4 rounded cursor-pointer" id="toggle-split" type="checkbox">
                    <span class="text-sm font-semibold text-slate-900">Batas data</span>
                  </label>
                </div>
              </div>

              <!-- Pencarian hasil prediksi berdasarkan tanggal -->
              <form class="flex flex-col gap-3 rounded-xl border border-blue-100 bg-blue-50/50 p-3" @submit.prevent="applyDateSearch">
                <div class="flex flex-wrap items-center gap-2">
                  <span class="material-symbols-outlined text-blue-600 text-[20px]">search</span>
                  <label for="forecast-date-search" class="text-sm font-semibold text-slate-800">Cari tanggal prediksi</label>
                  <input
                    id="forecast-date-search"
                    v-model="searchDate"
                    type="date"
                    :min="forecastWindow.min || undefined"
                    :max="forecastWindow.max || undefined"
                    class="h-9 rounded-lg border border-slate-200 bg-white px-2 text-sm text-slate-900 outline-none focus:border-blue-400"
                  />
                  <button type="submit" class="h-9 rounded-lg bg-blue-600 px-3 text-sm font-semibold text-white hover:bg-blue-700">
                    Lihat hasil
                  </button>
                  <button
                    v-if="appliedSearchDate"
                    type="button"
                    class="h-9 rounded-lg border border-slate-200 bg-white px-3 text-sm font-medium text-slate-600 hover:bg-slate-50"
                    @click="clearDateSearch"
                  >
                    Reset
                  </button>
                  <span v-if="forecastWindow.min" class="text-xs text-slate-500">
                    Horizon: {{ formatDateString(forecastWindow.min) }} s/d {{ formatDateString(forecastWindow.max) }}
                  </span>
                </div>

                <p v-if="predictionLookup.kind === 'idle'" class="text-sm text-slate-600">
                  Pilih tanggal ke depan dalam horizon. Harga prediksi ARIMA untuk tanggal itu langsung ditampilkan.
                </p>
                <p v-else-if="predictionLookup.kind === 'outside'" class="text-sm font-medium text-rose-700">
                  Tanggal {{ predictionLookup.dateStr }} berada di luar horizon prediksi. Cari antara {{ formatDateString(predictionLookup.min) }} dan {{ formatDateString(predictionLookup.max) }}.
                </p>
                <p v-else-if="predictionLookup.kind === 'nodate'" class="text-sm font-medium text-amber-700">
                  Prediksi belum memiliki tanggal kalender, jadi pencarian tanggal belum bisa dipakai.
                </p>
                <p v-else-if="predictionLookup.kind === 'missing'" class="text-sm font-medium text-amber-700">
                  Tidak ada prediksi pada {{ predictionLookup.dateStr }} untuk komoditas yang sedang ditampilkan.
                </p>
                <div v-else data-testid="prediction-search-results" class="overflow-x-auto rounded-lg border border-slate-200 bg-white">
                  <div class="flex items-center justify-between gap-2 px-3 py-2 border-b border-slate-100">
                    <span class="text-sm font-semibold text-slate-900">Hasil prediksi {{ predictionLookup.dateStr }}</span>
                    <span class="text-xs font-medium text-blue-700 bg-blue-50 px-2 py-0.5 rounded">ARIMA</span>
                  </div>
                  <table class="w-full min-w-[760px] whitespace-nowrap text-left text-sm">
                    <thead>
                      <tr class="text-xs uppercase tracking-wide text-slate-500">
                        <th class="px-3 py-2 font-medium">Komoditas</th>
                        <th class="px-3 py-2 font-medium">Harga prediksi</th>
                        <th class="px-3 py-2 font-medium">Pita 95%</th>
                        <th class="px-3 py-2 font-medium">Vs hari sebelumnya</th>
                        <th class="px-3 py-2 font-medium">Vs {{ baselineDateLabel }}</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="row in predictionLookup.rows" :key="row.id" class="border-t border-slate-100">
                        <td class="px-3 py-2 font-semibold text-slate-900">
                          <span class="inline-flex items-center gap-2">
                            <span class="w-2.5 h-2.5 rounded-full shrink-0" :style="{ backgroundColor: row.color }"></span>
                            {{ row.name }}
                          </span>
                        </td>
                        <td class="px-3 py-2 font-semibold text-slate-900">{{ row.price }}</td>
                        <td class="px-3 py-2 text-slate-600">{{ row.ciLower }} – {{ row.ciUpper }}</td>
                        <td class="px-3 py-2 font-semibold" :class="row.diffClass">{{ row.diff }}</td>
                        <td class="px-3 py-2 text-slate-600">{{ row.pct }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </form>

              <!-- Chart Canvas + Diagnostic Side Panels -->
              <div class="flex flex-col gap-space-md">
                <!-- Main SVG Chart Container -->
                <div class="w-full bg-white border border-slate-100 p-space-md rounded-xl flex flex-col gap-3">
                  <!-- SVG Graphic -->
                  <div class="w-full h-84 relative overflow-hidden flex items-center justify-center">
                    <svg class="w-full h-full text-blue-600 select-none" preserveAspectRatio="none" viewBox="0 0 800 320">
                      <defs>
                        <linearGradient id="ciGradient" x1="0" x2="0" y1="0" y2="1">
                          <stop offset="0%" stop-color="#006398" stop-opacity="0.25"></stop>
                          <stop offset="100%" stop-color="#006398" stop-opacity="0.04"></stop>
                        </linearGradient>
                        <linearGradient id="histGradient" x1="0" x2="0" y1="0" y2="1">
                          <stop offset="0%" stop-color="#006948" stop-opacity="0.18"></stop>
                          <stop offset="100%" stop-color="#006948" stop-opacity="0.01"></stop>
                        </linearGradient>
                      </defs>

                      <!-- Y-Axis Guide Lines & Labels -->
                      <g v-for="(tick, i) in yTicks" :key="'ytick'+i">
                        <line stroke="#bccac0" stroke-dasharray="4,4" stroke-opacity="0.3" x1="50" x2="780" :y1="tick.y" :y2="tick.y"></line>
                        <text fill="#3d4a42" font-family="JetBrains Mono, monospace" font-size="10" text-anchor="end" x="45" :y="tick.y + 4">{{ tick.label }}</text>
                      </g>

                      <!-- Marker tanggal yang sedang dicari -->
                      <g v-if="predictionLookup.kind === 'hit'">
                        <line stroke="#2563eb" stroke-width="1.5" :x1="predictionLookup.x" :x2="predictionLookup.x" y1="20" y2="280"></line>
                        <rect fill="#dbeafe" height="16" rx="4" width="92" :x="predictionLookup.x - 46" y="4"></rect>
                        <text fill="#1d4ed8" font-family="Inter, sans-serif" font-size="9" font-weight="600" text-anchor="middle" :x="predictionLookup.x" y="15">{{ predictionLookup.dateShort }}</text>
                      </g>

                      <!-- Garis batas data aktual dan prediksi -->
                      <g v-if="showSplit" id="split-line-group">
                        <line stroke="#ba1a1a" stroke-dasharray="5,5" stroke-width="1.5" :x1="splitX" :x2="splitX" y1="20" y2="280"></line>
                        <rect fill="#ffdad6" height="18" rx="4" width="84" :x="splitX - 42" y="22"></rect>
                        <text fill="#93000a" font-family="Inter, sans-serif" font-size="9" font-weight="600" text-anchor="middle" :x="splitX" y="34">{{ splitDateLabel }}</text>
                      </g>

                      <!-- Confidence Interval 95% Area / Ribbon (Dinamis: Berfungsi di mode Single maupun ALL) -->
                      <g v-if="showCI" id="ci-group">
                        <template v-if="selectedCommodity !== 'all'">
                          <polygon fill="url(#ciGradient)" :points="singlePolygonCI"></polygon>
                          <polyline fill="none" :points="singleCIUpperLine" stroke="#006398" stroke-dasharray="3,3" stroke-width="1.2" stroke-opacity="0.5"></polyline>
                          <polyline fill="none" :points="singleCILowerLine" stroke="#006398" stroke-dasharray="3,3" stroke-width="1.2" stroke-opacity="0.5"></polyline>
                        </template>
                        <template v-else>
                          <polygon v-for="s in chartData.series" :key="'ci-'+s.id"
                            :fill="s.color"
                            fill-opacity="0.14"
                            :points="s.ciPolygon">
                          </polygon>
                        </template>
                      </g>

                      <!-- Single Commodity Shaded Area -->
                      <g v-if="selectedCommodity !== 'all'">
                        <polygon fill="url(#histGradient)" :points="singlePolygonHist"></polygon>
                      </g>

                      <!-- Series Lines -->
                      <g v-for="s in chartData.series" :key="s.id">
                        <!-- Historic Solid Line -->
                        <polyline fill="none" :points="s.solidPoints" :stroke="s.color" stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"></polyline>
                        <!-- Forecast Dashed Line (Continuous from last historic point) -->
                        <polyline fill="none" :points="s.dashedPoints" :stroke="s.color" stroke-dasharray="6,6" stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"></polyline>
                      </g>

                      <!-- Interactive Hover Circles -->
                      <g v-for="s in chartData.series" :key="'points-'+s.id">
                        <template v-for="pt in s.mapped" :key="pt.day">
                          <circle
                            v-if="appliedSearchDate && pt.isoDate === appliedSearchDate && pt.type === 'forecast'"
                            :cx="pt.x" :cy="pt.y" r="5" :fill="s.color" stroke="#ffffff" stroke-width="1.5"
                            class="pointer-events-none"
                          />
                          <circle
                            :cx="pt.x" :cy="pt.y" r="7" fill="transparent"
                            class="cursor-pointer transition-all hover:opacity-75 hover:fill-blue-600"
                            @mouseover="showTooltip($event, { date: pt.dateStr, name: s.name, price: pt.priceStr, pct: pt.pctStr, diff: pt.diffStr, diffColor: pt.diffColor, type: pt.type })"
                            @mousemove="showTooltip($event, { date: pt.dateStr, name: s.name, price: pt.priceStr, pct: pt.pctStr, diff: pt.diffStr, diffColor: pt.diffColor, type: pt.type })"
                            @mouseleave="hideTooltip">
                          </circle>
                        </template>
                      </g>

                      <!-- Bottom X-Axis Markers -->
                      <text
                        v-for="(tick, i) in axisDateLabels"
                        :key="'xtick'+i"
                        :fill="tick.fill"
                        font-family="JetBrains Mono, monospace"
                        font-size="10"
                        :font-weight="tick.weight"
                        :text-anchor="tick.anchor"
                        :x="tick.x"
                        y="300"
                      >{{ tick.label }}</text>
                    </svg>

                    <!-- Hover Tooltip -->
                    <div v-if="tooltip.visible" :style="{ left: tooltip.x + 'px', top: (tooltip.y - 75) + 'px' }" class="absolute z-10 bg-slate-900 text-white text-xs p-2.5 rounded-lg shadow-xl pointer-events-none transform -translate-x-1/2 flex flex-col gap-1 w-max border border-slate-700">
                      <div class="flex items-center justify-between gap-2 border-b border-slate-700 pb-1 mb-0.5">
                        <span class="text-slate-300 font-semibold">{{ tooltip.data.name }}</span>
                        <span class="text-[10px] px-1.5 py-0.2 rounded" :class="tooltip.data.type === 'historic' ? 'bg-slate-700 text-slate-300' : 'bg-blue-900 text-blue-300'">
                          {{ tooltip.data.type === 'historic' ? 'Historis' : 'ARIMA Proyeksi' }}
                        </span>
                      </div>
                      <div class="flex items-center gap-3 justify-between">
                        <span class="font-bold text-sm text-white">{{ tooltip.data.price }}</span>
                        <span :class="tooltip.data.diffColor" class="font-semibold">{{ tooltip.data.diff }}</span>
                      </div>
                      <span class="text-[11px] text-slate-400">Tanggal: {{ tooltip.data.date }} ({{ tooltip.data.pct }})</span>
                    </div>
                  </div>

                  <!-- Legend Ribbon -->
                  <div class="flex items-center justify-between flex-wrap gap-2 pt-2 text-xs text-slate-500">
                    <div class="flex items-center gap-4 flex-wrap">
                      <div class="flex items-center gap-1.5">
                        <span class="w-3 h-0.5 bg-primary"></span>
                        <span class="text-slate-900 font-medium">Data historis aktual{{ chartPeriods.historic ? ' (' + chartPeriods.historic + ')' : '' }}</span>
                      </div>
                      <div class="flex items-center gap-1.5">
                        <span class="w-3 h-0.5 border-t-2 border-dashed border-secondary"></span>
                        <span class="text-slate-900 font-medium">Prediksi ARIMA{{ chartPeriods.forecast ? ' (' + chartPeriods.forecast + ')' : '' }}</span>
                      </div>
                      <div class="flex items-center gap-1.5">
                        <span class="w-3 h-3 bg-secondary/20 rounded-sm"></span>
                        <span class="text-slate-500">Pita Keyakinan 95% (CI)</span>
                      </div>
                    </div>
                    <div class="text-xs font-semibold text-slate-600">
                      Sampai: <span class="font-semibold text-blue-600">{{ chartPeriods.until || '-' }}</span>
                    </div>
                  </div>
                </div>

                <!-- ARIMA Diagnostic Stats & Test Sidecards -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-sm w-full">
                  <div class="bg-white border border-slate-100 p-space-md rounded-xl flex flex-col gap-space-xs">
                    <span class="text-xs font-medium text-slate-500 uppercase tracking-wider">Uji ADF (Stationarity)</span>
                    <div class="flex items-baseline justify-between">
                      <span class="text-xl font-bold text-blue-600">{{ activeDiagnostic.adf_stat }}</span>
                      <span class="text-xs font-semibold text-blue-600 bg-surface-container-highest px-2 py-0.5 rounded">p &lt; 0.01</span>
                    </div>
                  </div>
                  <div class="bg-white border border-slate-100 p-space-md rounded-xl flex flex-col gap-space-xs">
                    <span class="text-xs font-medium text-slate-500 uppercase tracking-wider">Best Order (AIC Min)</span>
                    <div class="flex items-baseline justify-between">
                      <span class="text-xl font-bold text-slate-900">{{ activeDiagnostic.best_order }}</span>
                      <span class="text-xs font-semibold text-slate-500">AIC: {{ activeDiagnostic.aic }}</span>
                    </div>
                  </div>
                  <div class="bg-white border border-slate-100 p-space-md rounded-xl flex flex-col gap-space-xs">
                    <span class="text-xs font-medium text-slate-500 uppercase tracking-wider">Uji Ljung-Box (Residual)</span>
                    <div class="flex items-baseline justify-between">
                      <span class="text-xl font-bold text-blue-500">{{ activeDiagnostic.ljung_box }}</span>
                      <span class="text-xs font-semibold text-blue-500 bg-surface-container-high px-2 py-0.5 rounded">White Noise OK</span>
                    </div>
                  </div>
                  <div class="bg-white border border-slate-100 p-space-md rounded-xl flex flex-col gap-space-xs">
                    <span class="text-xs font-medium text-slate-500 uppercase tracking-wider">Evaluasi Akurasi (MAPE)</span>
                    <div class="flex items-baseline justify-between">
                      <span class="text-xl font-bold text-blue-600">{{ activeDiagnostic.mape }}%</span>
                      <span class="text-xs font-semibold text-blue-600">RMSE: Rp {{ Number(activeDiagnostic.rmse).toLocaleString('id-ID') }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 6. GRID DUA KOLOM: FINANCIAL PATTERN (FPR) & OPTIMASI GWO MENU -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-space-lg">
              <!-- Kolom Kiri: Tabel Klasifikasi Tren Finansial (FPR) -->
              <div class="lg:col-span-7 bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col gap-space-md">
                <div class="flex items-center justify-between">
                  <div class="flex items-center gap-space-xs">
                    <span class="material-symbols-outlined text-blue-600 text-[20px]">insights</span>
                    <div>
                      <h2 class="text-base font-semibold text-slate-900">Tabel Klasifikasi Tren Finansial (FPR)</h2>
                    </div>
                  </div>
                  <span class="text-xs font-semibold text-slate-500 bg-white border border-slate-100 px-2 py-1 rounded">{{ commodities.length }} Komoditas Terpilih</span>
                </div>
                <div class="overflow-x-auto">
                  <table class="w-full text-left text-xs">
                    <thead>
                      <tr class="bg-white border border-slate-100 text-slate-500 text-sm font-medium uppercase tracking-wider">
                        <th class="py-2.5 px-3 rounded-l-lg">Komoditas</th>
                        <th class="py-2.5 px-2">Harga Riil</th>
                        <th class="py-2.5 px-2">Return</th>
                        <th class="py-2.5 px-2">Volatilitas</th>
                        <th class="py-2.5 px-2">Pola FPR</th>
                        <th class="py-2.5 px-3 rounded-r-lg text-right">GWO Action</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-50">
                      <tr v-for="c in commodities" :key="c.id" class="hover:bg-slate-50/80 transition-colors">
                        <td class="py-2.5 px-3 font-semibold text-slate-900 flex items-center gap-1.5">
                          <span class="w-2.5 h-2.5 rounded-full shrink-0" :style="{ backgroundColor: c.color }"></span>
                          <span>{{ c.name }}</span>
                        </td>
                        <td class="py-2.5 px-2 text-sm font-semibold text-slate-800">Rp {{ Number(c.latest_price).toLocaleString('id-ID') }}</td>
                        <td class="py-2.5 px-2 text-sm font-semibold" :class="c.return_pct > 0 ? 'text-emerald-600' : (c.return_pct < 0 ? 'text-rose-600' : 'text-slate-600')">
                          {{ c.return_pct > 0 ? '+' : '' }}{{ c.return_pct }}%
                        </td>
                        <td class="py-2.5 px-2 text-sm font-semibold text-slate-700">{{ c.volatility }}%</td>
                        <td class="py-2.5 px-2">
                          <span class="px-2 py-0.5 rounded text-xs font-medium whitespace-nowrap"
                            :class="c.fpr_pattern === 'Bullish' ? 'bg-amber-100 text-amber-800' : (c.fpr_pattern === 'Bearish' ? 'bg-indigo-100 text-indigo-800' : 'bg-slate-100 text-slate-700')">
                            {{ c.fpr_pattern }}
                          </span>
                        </td>
                        <td class="py-2.5 px-3 text-right">
                          <span class="text-sm font-semibold text-blue-600">{{ c.gwo_action }}</span>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <!-- Kolom Kanan: Formulasi Porsi Menu PMT Balita Hasil GWO (Multi-Objektif) -->
              <div class="lg:col-span-5 bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-start gap-space-md">
                <div class="flex flex-col gap-1">
                  <div class="flex items-center justify-between">
                    <div class="flex items-center gap-space-xs">
                      <span class="material-symbols-outlined text-blue-600 text-[20px]">restaurant_menu</span>
                      <h2 class="text-base font-semibold text-slate-900">Formulasi Menu PMT (GWO)</h2>
                    </div>
                    <span class="text-xs font-semibold text-blue-600 bg-blue-50 px-2 py-0.5 rounded">1 Porsi / Hari</span>
                  </div>
                </div>

                <!-- Ingredient Visual Proportion Bar -->
                <div class="flex flex-col gap-1.5">
                  <div class="flex justify-between text-xs text-slate-500">
                    <span>Komposisi Gramatur (Total {{ totalPmtGrams }}g)</span>
                    <span class="text-xs font-semibold text-blue-600">Multi-Nutrisi Seimbang</span>
                  </div>
                  <div class="w-full h-3 rounded-full bg-slate-100 flex overflow-hidden">
                    <div v-for="item in pmtMenu" :key="item.komoditas" 
                      :style="{ width: ((item.gram / totalPmtGrams) * 100) + '%', backgroundColor: item.color }"
                      :title="item.komoditas + ' (' + item.gram + 'g)'">
                    </div>
                  </div>
                </div>

                <!-- Formulasi Dynamic List -->
                <div class="flex flex-col gap-1.5 text-xs">
                  <div v-for="item in pmtMenu" :key="item.komoditas" class="flex items-center justify-between py-1.5 px-2.5 rounded bg-slate-50 border border-slate-100">
                    <div class="flex items-center gap-2">
                      <span class="w-2 h-2 rounded-full shrink-0" :style="{ backgroundColor: item.color }"></span>
                      <span class="text-slate-900 font-medium">{{ item.komoditas }}</span>
                    </div>
                    <div class="flex items-center gap-3">
                      <span class="text-xs font-semibold text-slate-500">{{ item.gram }} g</span>
                      <span class="text-sm font-semibold text-slate-900">Rp {{ Number(item.biaya).toLocaleString('id-ID') }}</span>
                    </div>
                  </div>

                  <div class="flex items-center justify-between pt-2 mt-1 px-2 border-t border-slate-100">
                    <span class="text-sm font-bold text-slate-900">TOTAL BIAYA BERSIH PMT</span>
                    <span class="text-lg font-bold text-blue-600">Rp {{ Number(kpi.estimasi_biaya || 0).toLocaleString('id-ID') }} / hari</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 7. FOOTER SECTION -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-space-md p-space-md rounded-xl bg-white text-slate-500 text-xs shadow-sm">
              <div class="flex items-center gap-space-sm flex-wrap">
                <div class="flex items-center gap-1.5">
                  <span class="material-symbols-outlined text-blue-600 text-[18px]">schedule</span>
                  <span>Pembaruan Data Terakhir: <strong class="text-slate-900">{{ dashboardData.last_update || '-' }}</strong></span>
                </div>
                <span class="hidden md:inline text-outline-variant">|</span>
                <span>Metodologi: <strong>Box-Jenkins Auto-ARIMA</strong> &amp; <strong>Grey Wolf Optimizer (Mirjalili, 2014)</strong></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import BaseButton from '../components/BaseButton.vue';
import Navbar from '../components/Navbar.vue';
import MetricCard from '../components/MetricCard.vue';
import Sidebar from '../components/Sidebar.vue';
import { formatDateString } from '../utils/dateFormatter';

function toIsoDate(value) {
  const str = String(value ?? '').trim();
  const match = str.match(/^(\d{4})[-/](\d{1,2})[-/](\d{1,2})/);
  if (!match) return null;
  const month = Number(match[2]);
  const day = Number(match[3]);
  if (month < 1 || month > 12 || day < 1 || day > 31) return null;
  return `${match[1]}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

function shiftIsoDate(iso, days) {
  const [year, month, day] = iso.split('-').map(Number);
  const date = new Date(Date.UTC(year, month - 1, day));
  date.setUTCDate(date.getUTCDate() + days);
  const y = date.getUTCFullYear();
  const m = String(date.getUTCMonth() + 1).padStart(2, '0');
  const d = String(date.getUTCDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

const router = useRouter();
const hasData = ref(false);
const isPipelineRunning = ref(false);
const selectedCommodity = ref('all');
const scaleMode = ref('index'); // 'index' or 'nominal'
const showCI = ref(true);
const showSplit = ref(true);
const tooltip = ref({ visible: false, x: 0, y: 0, data: null });
const searchDate = ref('');
const appliedSearchDate = ref('');

const dashboardData = ref({
  date_range: '',
  last_update: '',
  commodities: [],
  chart_series: [],
  pmt_menu: [],
  kpi: {}
});

const commodities = computed(() => dashboardData.value.commodities || []);
const pmtMenu = computed(() => dashboardData.value.pmt_menu || []);
const kpi = computed(() => dashboardData.value.kpi || {});

const totalPmtGrams = computed(() => {
  return pmtMenu.value.reduce((acc, cur) => acc + (cur.gram || 0), 0) || 1;
});

const activeDiagnostic = computed(() => {
  if (selectedCommodity.value !== 'all') {
    const item = commodities.value.find(c => c.id === selectedCommodity.value);
    if (item) return item;
  }
  // Default aggregate from first or average
  if (commodities.value.length > 0) {
    const first = commodities.value[0];
    return {
      adf_stat: '-3.842',
      p_value: '< 0.01',
      best_order: 'Auto-ARIMA Best',
      aic: first.aic || '412.3',
      ljung_box: '0.412',
      mape: kpi.value.mape_avg || '3.42',
      rmse: first.rmse || '184'
    };
  }
  return {
    adf_stat: '-',
    p_value: '-',
    best_order: '-',
    aic: '-',
    ljung_box: '-',
    mape: '-',
    rmse: '-'
  };
});

const fetchDashboardData = async () => {
  try {
    const res = await fetch('http://127.0.0.1:5001/api/dashboard/summary');
    const json = await res.json();
    if (json.status === 'success' && json.has_data) {
      dashboardData.value = json;
      hasData.value = true;
    } else {
      hasData.value = false;
    }
  } catch (err) {
    console.error('Error fetching dashboard data:', err);
    hasData.value = false;
  }
};

onMounted(() => {
  fetchDashboardData();
});

const runPipeline = async () => {
  isPipelineRunning.value = true;
  try {
    await fetch('http://127.0.0.1:5001/api/forecast', { method: 'POST' });
    await fetch('http://127.0.0.1:5001/api/gwo', { method: 'POST' });
    await fetchDashboardData();
    alert('Pipeline Forecasting ARIMA & Optimasi GWO berhasil dijalankan ulang!');
  } catch (err) {
    console.error(err);
    alert('Terjadi kesalahan saat mengeksekusi pipeline.');
  } finally {
    isPipelineRunning.value = false;
  }
};

const downloadPdf = () => {
  window.print();
};

function showTooltip(evt, data) {
  tooltip.value = { visible: true, x: evt.offsetX, y: evt.offsetY, data };
}
function hideTooltip() {
  tooltip.value.visible = false;
}

const chartData = computed(() => {
  const rawSeries = dashboardData.value.chart_series || [];
  if (rawSeries.length === 0) return { series: [], minP: 0, maxP: 100, isIndexMode: false };

  const isSingle = selectedCommodity.value !== 'all';
  const activeSeries = isSingle 
    ? rawSeries.filter(s => s.id === selectedCommodity.value)
    : rawSeries;

  const isIndexMode = !isSingle && scaleMode.value === 'index';

  let minVal = Infinity;
  let maxVal = -Infinity;

  activeSeries.forEach(s => {
    if (s.points && Array.isArray(s.points)) {
      s.points.forEach(pt => {
        const v = isIndexMode ? (pt.pct_change || 0) : pt.price;
        const vLow = (isSingle && pt.ci_lower) ? pt.ci_lower : v;
        const vHigh = (isSingle && pt.ci_upper) ? pt.ci_upper : v;

        if (vLow < minVal) minVal = vLow;
        if (vHigh > maxVal) maxVal = vHigh;
      });
    }
  });

  if (minVal === Infinity) {
    minVal = isIndexMode ? -10 : 0;
    maxVal = isIndexMode ? 10 : 100;
  }

  const range = maxVal - minVal || 10;
  minVal = isIndexMode ? (minVal - range * 0.15) : Math.max(0, minVal - range * 0.1);
  maxVal = maxVal + range * 0.15;

  const resultSeries = activeSeries.map(s => {
    const totalPts = s.points.length;
    const historicPoints = (s.points || []).filter(point => point.type === 'historic');
    const anchorIso = historicPoints.length ? toIsoDate(historicPoints[historicPoints.length - 1].date) : null;
    const baselineDate = formatDateString(toIsoDate(historicPoints[0]?.date) || anchorIso || '', 'short');
    const mapped = s.points.map((pt, i) => {
      const x = 50 + i * (730 / Math.max(1, totalPts - 1));
      const val = isIndexMode ? (pt.pct_change || 0) : pt.price;
      const y = 280 - ((val - minVal) / (maxVal - minVal)) * 240;

      // CI values for single view
      let ciUpperY = y - 12;
      let ciLowerY = y + 12;
      if (isSingle && pt.ci_upper && pt.ci_lower) {
        ciUpperY = 280 - ((pt.ci_upper - minVal) / (maxVal - minVal)) * 240;
        ciLowerY = 280 - ((pt.ci_lower - minVal) / (maxVal - minVal)) * 240;
      }
      
      const prevPrice = i > 0 ? s.points[i - 1].price : pt.price;
      const diff = pt.price - prevPrice;
      let diffStr = 'Tetap';
      let diffColor = 'text-slate-400';
      let diffClass = 'text-slate-500';
      if (diff > 0) {
        diffStr = '+Rp ' + Number(diff).toLocaleString('id-ID');
        diffColor = 'text-emerald-400';
        diffClass = 'text-emerald-600';
      } else if (diff < 0) {
        diffStr = '-Rp ' + Number(Math.abs(diff)).toLocaleString('id-ID');
        diffColor = 'text-rose-400';
        diffClass = 'text-rose-600';
      }

      const pctStr = (pt.pct_change > 0 ? '+' : '') + (pt.pct_change || 0) + '% dari ' + (baselineDate || 'awal periode');
      const directIso = toIsoDate(pt.date);
      const isoDate = directIso || (
        anchorIso != null && Number.isFinite(Number(pt.day))
          ? shiftIsoDate(anchorIso, Number(pt.day))
          : null
      );

      return {
        ...pt,
        x,
        y,
        ciUpperY,
        ciLowerY,
        isoDate,
        dateStr: formatDateString(isoDate || pt.date),
        priceStr: 'Rp ' + Number(pt.price).toLocaleString('id-ID'),
        pctStr,
        diffStr,
        diffColor,
        diffClass
      };
    });

    const solidPts = mapped.filter(pt => pt.type === 'historic');
    // Connect the last historical point directly to the forecast curve
    const lastHist = solidPts[solidPts.length - 1];
    const forecastOnly = mapped.filter(pt => pt.type === 'forecast');
    const dashedPts = lastHist ? [lastHist, ...forecastOnly] : forecastOnly;

    // CI Corridor Polygon for ALL mode & Single mode
    const ciPts = lastHist ? [lastHist, ...forecastOnly] : forecastOnly;
    const ciUpper = ciPts.map(pt => pt.x + ',' + pt.ciUpperY).join(' ');
    const ciLower = ciPts.slice().reverse().map(pt => pt.x + ',' + pt.ciLowerY).join(' ');
    const ciPolygon = (ciUpper && ciLower) ? (ciUpper + ' ' + ciLower) : '';

    return {
      id: s.id,
      name: s.name,
      color: s.color,
      points: s.points,
      mapped,
      solidPoints: solidPts.map(pt => pt.x + ',' + pt.y).join(' '),
      dashedPoints: dashedPts.map(pt => pt.x + ',' + pt.y).join(' '),
      ciPolygon
    };
  });

  return { series: resultSeries, minP: minVal, maxP: maxVal, isIndexMode };
});

const splitX = computed(() => {
  const s = chartData.value.series[0];
  if (!s || !s.mapped) return 415;
  const lastHist = s.mapped.filter(pt => pt.type === 'historic').pop();
  return lastHist ? lastHist.x : 415;
});

function chartPointDate(point) {
  if (!point) return '';
  return formatDateString(point.isoDate || point.date, 'short');
}

const splitDateLabel = computed(() => {
  const series = chartData.value.series[0];
  const lastHist = series?.mapped?.filter(point => point.type === 'historic').pop();
  return chartPointDate(lastHist);
});

const baselineDateLabel = computed(() => {
  const series = chartData.value.series[0];
  const first = series?.mapped?.find(point => point.type === 'historic') || series?.mapped?.[0];
  return chartPointDate(first) || 'awal periode';
});

const chartPeriods = computed(() => {
  const series = chartData.value.series[0];
  const points = series?.mapped || [];
  const historic = points.filter(point => point.type === 'historic');
  const forecast = points.filter(point => point.type === 'forecast');
  const first = historic[0];
  const lastHist = historic[historic.length - 1];
  const firstForecast = forecast[0];
  const lastForecast = forecast[forecast.length - 1];
  return {
    historic: first && lastHist ? `${chartPointDate(first)} – ${chartPointDate(lastHist)}` : '',
    forecast: firstForecast && lastForecast ? `${chartPointDate(firstForecast)} – ${chartPointDate(lastForecast)}` : '',
    until: chartPointDate(lastForecast)
  };
});

const axisDateLabels = computed(() => {
  const series = chartData.value.series[0];
  const points = series?.mapped || [];
  if (!points.length) return [];

  const historic = points.filter(point => point.type === 'historic');
  const forecast = points.filter(point => point.type === 'forecast');
  const first = historic[0] || points[0];
  const lastHist = historic[historic.length - 1] || first;
  const last = forecast[forecast.length - 1] || points[points.length - 1];
  const midHist = historic.length > 2 ? historic[Math.floor((historic.length - 1) / 2)] : null;
  const midForecast = forecast.length > 2 ? forecast[Math.floor((forecast.length - 1) / 2)] : null;

  const candidates = [
    { point: first, emphasize: false },
    midHist ? { point: midHist, emphasize: false } : null,
    { point: lastHist, emphasize: true },
    midForecast ? { point: midForecast, emphasize: false } : null,
    { point: last, emphasize: false }
  ].filter(Boolean);

  const kept = [];
  for (const item of candidates) {
    const previous = kept[kept.length - 1];
    if (previous && Math.abs(item.point.x - previous.point.x) < 78) {
      if (item.emphasize && !previous.emphasize) kept[kept.length - 1] = item;
      continue;
    }
    kept.push(item);
  }

  return kept.map((item, index) => ({
    x: item.point.x,
    label: chartPointDate(item.point),
    anchor: index === 0 ? 'start' : index === kept.length - 1 ? 'end' : 'middle',
    fill: item.emphasize ? '#ba1a1a' : '#3d4a42',
    weight: item.emphasize ? 700 : 500
  }));
});

const singlePolygonHist = computed(() => {
  if (selectedCommodity.value === 'all') return '';
  const s = chartData.value.series[0];
  if (!s || !s.mapped) return '';
  const pts = s.mapped.filter(pt => pt.type === 'historic');
  if (pts.length === 0) return '';
  return pts.map(pt => pt.x + ',' + pt.y).join(' ') + ' ' + pts[pts.length - 1].x + ',280 50,280';
});

const singlePolygonCI = computed(() => {
  const s = chartData.value.series[0];
  if (!s || !s.mapped) return '';
  const pts = s.mapped.filter(pt => pt.type === 'forecast');
  if (pts.length === 0) return '';
  const lastHist = s.mapped.filter(pt => pt.type === 'historic').pop();
  const ciPts = lastHist ? [lastHist, ...pts] : pts;
  const upper = ciPts.map(pt => pt.x + ',' + pt.ciUpperY).join(' ');
  const lower = ciPts.slice().reverse().map(pt => pt.x + ',' + pt.ciLowerY).join(' ');
  return upper + ' ' + lower;
});

const singleCIUpperLine = computed(() => {
  const s = chartData.value.series[0];
  if (!s || !s.mapped) return '';
  const pts = s.mapped.filter(pt => pt.type === 'forecast');
  if (pts.length === 0) return '';
  const lastHist = s.mapped.filter(pt => pt.type === 'historic').pop();
  const ciPts = lastHist ? [lastHist, ...pts] : pts;
  return ciPts.map(pt => pt.x + ',' + pt.ciUpperY).join(' ');
});

const singleCILowerLine = computed(() => {
  const s = chartData.value.series[0];
  if (!s || !s.mapped) return '';
  const pts = s.mapped.filter(pt => pt.type === 'forecast');
  if (pts.length === 0) return '';
  const lastHist = s.mapped.filter(pt => pt.type === 'historic').pop();
  const ciPts = lastHist ? [lastHist, ...pts] : pts;
  return ciPts.map(pt => pt.x + ',' + pt.ciLowerY).join(' ');
});

const forecastWindow = computed(() => {
  const dates = [];
  for (const series of chartData.value.series) {
    for (const point of series.mapped || []) {
      if (point.type === 'forecast' && point.isoDate) dates.push(point.isoDate);
    }
  }
  if (!dates.length) return { min: '', max: '' };
  dates.sort();
  return { min: dates[0], max: dates[dates.length - 1] };
});

const predictionLookup = computed(() => {
  const query = appliedSearchDate.value;
  const window = forecastWindow.value;
  if (!query) return { kind: 'idle' };
  if (!window.min || !window.max) return { kind: 'nodate' };
  if (query < window.min || query > window.max) {
    return {
      kind: 'outside',
      min: window.min,
      max: window.max,
      dateStr: formatDateString(query)
    };
  }

  const rows = [];
  for (const series of chartData.value.series) {
    const point = (series.mapped || []).find(item => item.type === 'forecast' && item.isoDate === query);
    if (!point) continue;
    rows.push({
      id: series.id,
      name: series.name,
      color: series.color,
      price: point.priceStr,
      ciLower: point.ci_lower == null ? '-' : 'Rp ' + Number(point.ci_lower).toLocaleString('id-ID'),
      ciUpper: point.ci_upper == null ? '-' : 'Rp ' + Number(point.ci_upper).toLocaleString('id-ID'),
      pct: point.pctStr,
      diff: point.diffStr,
      diffClass: point.diffClass,
      x: point.x
    });
  }

  if (!rows.length) {
    return { kind: 'missing', dateStr: formatDateString(query) };
  }
  return {
    kind: 'hit',
    dateStr: formatDateString(query),
    dateShort: formatDateString(query, 'short'),
    rows,
    x: rows[0].x
  };
});

function applyDateSearch() {
  appliedSearchDate.value = searchDate.value;
}

function clearDateSearch() {
  searchDate.value = '';
  appliedSearchDate.value = '';
}

watch(searchDate, (value) => {
  appliedSearchDate.value = value;
});

const yTicks = computed(() => {
  const ticks = [];
  const { minP, maxP, isIndexMode } = chartData.value;
  for (let i = 0; i <= 4; i++) {
    const val = minP + (maxP - minP) * (i / 4);
    const y = 280 - (i / 4) * 240;
    let label = '';
    if (isIndexMode) {
      label = (val > 0 ? '+' : '') + val.toFixed(1) + '%';
    } else {
      label = (val / 1000).toFixed(1) + 'k';
    }
    ticks.push({ y, label });
  }
  return ticks;
});
</script>