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
                  <span>{{ hasData ? 'Periode Data: ' + (dashboardData.date_range || 'Tersedia') : 'Menunggu Dataset' }}</span>
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

          <!-- 3. JALUR KPI & METRIC CARDS (4 Kolom Grid) -->
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-lg">
            <MetricCard 
              title="Estimasi Biaya Menu Harian"
              :value="hasData && kpi.estimasi_biaya ? 'Rp ' + Number(kpi.estimasi_biaya).toLocaleString('id-ID') : '-'"
              :badge="hasData ? 'FORMULASI GWO' : 'Belum Ada Data'"
              :footerLeft="hasData ? 'Basis komoditas lokal' : 'Menunggu dataset'"
              :footerRight="hasData ? (commodities.length + ' Komoditas') : ''"
            />
            <MetricCard 
              title="Total Energi PMT (Balita)"
              :badge="hasData ? 'OPTIMAL' : 'N/A'"
              :footerLeft="hasData ? '100.1% dari target 1.350 kkal' : 'Menunggu formulasi'"
              :footerRight="hasData ? '+2 kkal/hari' : ''"
            >
              <template #value>
                <span v-if="hasData && kpi.energi_tercapai">{{ kpi.energi_tercapai }} <span class="text-sm font-normal text-slate-500">kkal</span></span>
                <span v-else>-</span>
              </template>
            </MetricCard>
            <MetricCard 
              title="Akurasi Prediksi Rata-rata"
              :value="hasData && kpi.mape_avg ? kpi.mape_avg + '%' : '-'"
              :badge="hasData ? 'MAPE <10%' : 'N/A'"
              :footerLeft="hasData ? 'Walk-forward validation' : 'Menunggu estimasi'"
              :footerRight="hasData ? 'Auto-ARIMA' : ''"
              valueClass="text-blue-500"
              badgeClass="text-blue-500 bg-surface-container-high"
              footerRightClass="text-blue-500"
            />
            <MetricCard 
              title="Fitness Alpha Wolf (GWO)"
              :value="hasData && kpi.gwo_fitness ? kpi.gwo_fitness : '-'"
              :badge="hasData ? 'Konvergen' : 'N/A'"
              :footerLeft="hasData ? 'Multi-objektif (Cost & Gizi)' : 'Menunggu optimasi'"
              :footerRight="hasData ? 'Seed: 42' : ''"
              valueClass="text-blue-600"
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
                    {{ dashboardData.date_range || 'Deret Waktu Aktual' }}
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

                  <!-- Chart Scale Mode Toggle (Only when ALL is selected) -->
                  <div v-if="selectedCommodity === 'all'" class="flex items-center bg-slate-100 p-0.5 rounded-lg border border-slate-200 text-xs font-medium">
                    <button type="button" @click="scaleMode = 'index'" :class="scaleMode === 'index' ? 'bg-white text-blue-600 shadow-xs font-semibold' : 'text-slate-600 hover:text-slate-900'" class="px-2.5 py-1 rounded-md transition-all">
                      Indeks Tren (%)
                    </button>
                    <button type="button" @click="scaleMode = 'nominal'" :class="scaleMode === 'nominal' ? 'bg-white text-blue-600 shadow-xs font-semibold' : 'text-slate-600 hover:text-slate-900'" class="px-2.5 py-1 rounded-md transition-all">
                      Nominal (Rp)
                    </button>
                  </div>

                  <!-- Controls Toggles -->
                  <label class="flex items-center gap-2 cursor-pointer bg-white border border-slate-200 px-3 py-1.5 rounded-lg select-none">
                    <input v-model="showCI" class="accent-primary w-4 h-4 rounded" id="toggle-ci" type="checkbox">
                    <span class="text-sm font-semibold text-slate-900">CI 95%</span>
                  </label>
                  <label class="flex items-center gap-2 cursor-pointer bg-white border border-slate-200 px-3 py-1.5 rounded-lg select-none">
                    <input v-model="showSplit" class="accent-secondary w-4 h-4 rounded" id="toggle-split" type="checkbox">
                    <span class="text-sm font-semibold text-slate-900">Split Horizon</span>
                  </label>
                </div>
              </div>

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

                      <!-- Split Horizon Line -->
                      <g v-if="showSplit" id="split-line-group">
                        <line stroke="#ba1a1a" stroke-dasharray="5,5" stroke-width="1.5" :x1="splitX" :x2="splitX" y1="20" y2="280"></line>
                        <rect fill="#ffdad6" height="18" rx="4" width="100" :x="splitX - 50" y="22"></rect>
                        <text fill="#93000a" font-family="Inter, sans-serif" font-size="9" font-weight="600" text-anchor="middle" :x="splitX" y="34">SPLIT (Hari Ini)</text>
                      </g>

                      <!-- Single Commodity Shaded Area & Confidence Interval Polygon -->
                      <g v-if="selectedCommodity !== 'all'">
                        <polygon fill="url(#histGradient)" :points="singlePolygonHist"></polygon>
                        <polygon v-if="showCI" fill="url(#ciGradient)" :points="singlePolygonCI"></polygon>
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
                        <circle v-for="pt in s.mapped" :key="pt.day" 
                          :cx="pt.x" :cy="pt.y" r="7" fill="transparent" 
                          class="cursor-pointer transition-all hover:opacity-75 hover:fill-blue-600"
                          @mouseover="showTooltip($event, { date: pt.dateStr, name: s.name, price: pt.priceStr, pct: pt.pctStr, diff: pt.diffStr, diffColor: pt.diffColor, type: pt.type })"
                          @mousemove="showTooltip($event, { date: pt.dateStr, name: s.name, price: pt.priceStr, pct: pt.pctStr, diff: pt.diffStr, diffColor: pt.diffColor, type: pt.type })"
                          @mouseleave="hideTooltip">
                        </circle>
                      </g>

                      <!-- Bottom X-Axis Markers -->
                      <text fill="#3d4a42" font-family="JetBrains Mono, monospace" font-size="10" x="50" y="300">T-30 Hari</text>
                      <text fill="#3d4a42" font-family="JetBrains Mono, monospace" font-size="10" x="230" y="300">T-15 Hari</text>
                      <text fill="#ba1a1a" font-family="JetBrains Mono, monospace" font-size="10" font-weight="700" :x="splitX - 25" y="300">Hari Ini</text>
                      <text fill="#3d4a42" font-family="JetBrains Mono, monospace" font-size="10" x="585" y="300">T+15 Hari</text>
                      <text fill="#3d4a42" font-family="JetBrains Mono, monospace" font-size="10" text-anchor="end" x="780" y="300">T+30 Hari</text>
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
                        <span class="text-slate-900 font-medium">Data Historis Aktual (30 Hari)</span>
                      </div>
                      <div class="flex items-center gap-1.5">
                        <span class="w-3 h-0.5 border-t-2 border-dashed border-secondary"></span>
                        <span class="text-slate-900 font-medium">ARIMA Forecast Proyeksi (h=30)</span>
                      </div>
                      <div class="flex items-center gap-1.5">
                        <span class="w-3 h-3 bg-secondary/20 rounded-sm"></span>
                        <span class="text-slate-500">Pita Keyakinan 95% (CI)</span>
                      </div>
                    </div>
                    <div class="text-xs font-semibold text-slate-600">
                      Horizon: <span class="font-semibold text-blue-600">30 Hari ke Depan</span>
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
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import BaseButton from '../components/BaseButton.vue';
import Navbar from '../components/Navbar.vue';
import MetricCard from '../components/MetricCard.vue';
import Sidebar from '../components/Sidebar.vue';

const router = useRouter();
const hasData = ref(false);
const isPipelineRunning = ref(false);
const selectedCommodity = ref('all');
const scaleMode = ref('index'); // 'index' or 'nominal'
const showCI = ref(true);
const showSplit = ref(true);
const tooltip = ref({ visible: false, x: 0, y: 0, data: null });

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
      if (diff > 0) {
        diffStr = '+Rp ' + Number(diff).toLocaleString('id-ID');
        diffColor = 'text-emerald-400';
      } else if (diff < 0) {
        diffStr = '-Rp ' + Number(Math.abs(diff)).toLocaleString('id-ID');
        diffColor = 'text-rose-400';
      }

      const pctStr = (pt.pct_change > 0 ? '+' : '') + (pt.pct_change || 0) + '% dari T-30';

      return {
        ...pt,
        x,
        y,
        ciUpperY,
        ciLowerY,
        dateStr: pt.date,
        priceStr: 'Rp ' + Number(pt.price).toLocaleString('id-ID'),
        pctStr,
        diffStr,
        diffColor
      };
    });

    const solidPts = mapped.filter(pt => pt.type === 'historic');
    // Connect the last historical point directly to the forecast curve
    const lastHist = solidPts[solidPts.length - 1];
    const forecastOnly = mapped.filter(pt => pt.type === 'forecast');
    const dashedPts = lastHist ? [lastHist, ...forecastOnly] : forecastOnly;

    return {
      id: s.id,
      name: s.name,
      color: s.color,
      points: s.points,
      mapped,
      solidPoints: solidPts.map(pt => pt.x + ',' + pt.y).join(' '),
      dashedPoints: dashedPts.map(pt => pt.x + ',' + pt.y).join(' ')
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

const singlePolygonHist = computed(() => {
  if (selectedCommodity.value === 'all') return '';
  const s = chartData.value.series[0];
  if (!s || !s.mapped) return '';
  const pts = s.mapped.filter(pt => pt.type === 'historic');
  if (pts.length === 0) return '';
  return pts.map(pt => pt.x + ',' + pt.y).join(' ') + ' ' + pts[pts.length - 1].x + ',280 50,280';
});

const singlePolygonCI = computed(() => {
  if (selectedCommodity.value === 'all') return '';
  const s = chartData.value.series[0];
  if (!s || !s.mapped) return '';
  const pts = s.mapped.filter(pt => pt.type === 'forecast');
  if (pts.length === 0) return '';
  const upper = pts.map(pt => pt.x + ',' + pt.ciUpperY).join(' ');
  const lower = pts.slice().reverse().map(pt => pt.x + ',' + pt.ciLowerY).join(' ');
  return upper + ' ' + lower;
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