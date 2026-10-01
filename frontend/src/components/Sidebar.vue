<template>
  <aside class="fixed left-0 top-0 h-full w-[260px] bg-white border-r border-slate-100 z-50 flex flex-col justify-between shadow-[0_1px_8px_rgba(0,0,0,0.04)]">
    <div class="flex flex-col">
      <div class="p-space-lg flex items-center gap-space-sm">
        <span class="text-xl font-bold text-blue-600 tracking-tight">NutriCast</span>
      </div>
      <div class="px-space-md py-space-xs">
        <span class="text-sm font-medium text-slate-500 uppercase tracking-wider px-space-sm">Modul &amp; Analitik</span>
      </div>
      <nav class="flex flex-col gap-1 px-space-md" data-active-classes="bg-blue-50 text-blue-700 border border-blue-200 font-medium font-semibold rounded-lg shadow-sm">
        <router-link class="flex items-center gap-space-sm px-space-sm py-2 rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all" to="/dashboard">
          <span class="material-symbols-outlined text-[20px]">dashboard</span>
          <span class="text-sm">Ringkasan &amp; Dashboard</span>
        </router-link>
        <details class="group" open>
          <summary class="flex items-center justify-between px-space-sm py-2 rounded-lg text-slate-500 hover:bg-surface-container-high hover:text-slate-900 transition-all cursor-pointer list-none [&::-webkit-details-marker]:hidden group">
            <div class="flex items-center gap-space-sm">
              <span class="material-symbols-outlined text-[20px]">folder_copy</span>
              <span class="text-sm">Modul Pipeline</span>
            </div>
            <span class="material-symbols-outlined text-[18px] group-open:rotate-180 transition-transform">expand_more</span>
          </summary>
          <div class="flex flex-col gap-1 pl-6 mt-1 border-l-2 border-surface-container-high ml-3">
            <router-link class="flex items-center gap-space-sm px-space-sm py-2 rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all" to="/modul-1">
              <span class="material-symbols-outlined text-[20px]">database</span>
              <span class="text-sm">Modul 1: Manajemen Dataset</span>
            </router-link>
            <router-link class="flex items-center gap-space-sm px-space-sm py-2 rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all" to="/modul-2">
              <span class="material-symbols-outlined text-[20px]">trending_up</span>
              <span class="text-sm">Modul 2: Forecasting ARIMA</span>
            </router-link>
            <router-link class="flex items-center gap-space-sm px-space-sm py-2 rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all" to="/modul-3">
              <span class="material-symbols-outlined text-[20px]">insights</span>
              <span class="text-sm">Modul 3: Financial Pattern (FPR)</span>
            </router-link>
            <router-link class="flex items-center gap-space-sm px-space-sm py-2 rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all" to="/modul-4">
              <span class="material-symbols-outlined text-[20px]">tune</span>
              <span class="text-sm">Modul 4: Optimasi GWO</span>
            </router-link>
            <router-link class="flex items-center gap-space-sm px-space-sm py-2 rounded-lg text-slate-500 hover:bg-slate-50 hover:text-slate-900 transition-all" to="/modul-5">
              <span class="material-symbols-outlined text-[20px]">restaurant_menu</span>
              <span class="text-sm">Modul 5: Menu PMT &amp; Export</span>
            </router-link>
          </div>
        </details>
      </nav>
    </div>
  </aside>
</template>

<script setup>
// Reusable Sidebar Component
</script>
