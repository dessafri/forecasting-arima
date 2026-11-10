<template>
  <aside class="fixed left-0 top-0 h-full w-[260px] bg-white border-r border-slate-100 z-50 flex flex-col justify-between shadow-[0_1px_8px_rgba(0,0,0,0.04)]">
    <div class="flex flex-col">
      <div class="p-space-lg flex items-center gap-space-sm">
        <span class="text-xl font-bold text-blue-600 tracking-tight">NutriCast</span>
      </div>
      <div class="px-space-md py-space-xs">
        <span class="text-sm font-medium text-slate-500 uppercase tracking-wider px-space-sm">Modul &amp; Analitik</span>
      </div>
      <nav class="flex flex-col gap-1 px-space-md">
        <router-link to="/dashboard" :class="itemClass(isDashboard)" :aria-current="isDashboard ? 'page' : undefined">
          <span class="material-symbols-outlined text-[20px]">dashboard</span>
          <span class="text-sm">Ringkasan &amp; Dashboard</span>
        </router-link>
        <details class="group" open>
          <summary :class="pipelineClass">
            <div class="flex items-center gap-space-sm">
              <span class="material-symbols-outlined text-[20px]">folder_copy</span>
              <span class="text-sm">Modul Pipeline</span>
            </div>
            <span class="material-symbols-outlined text-[18px] group-open:rotate-180 transition-transform">expand_more</span>
          </summary>
          <div class="flex flex-col gap-1 pl-6 mt-1 border-l-2 border-slate-100 ml-3">
            <router-link
              v-for="item in pipelineItems"
              :key="item.to"
              :to="item.to"
              :class="itemClass(isNamed(item.names))"
              :aria-current="isNamed(item.names) ? 'page' : undefined"
            >
              <span class="material-symbols-outlined text-[20px]">{{ item.icon }}</span>
              <span class="text-sm">{{ item.label }}</span>
            </router-link>
          </div>
        </details>
      </nav>
    </div>
  </aside>
</template>

<script setup>
import { computed } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();

const pipelineItems = [
  { to: '/modul-1', label: 'Modul 1: Manajemen Dataset', icon: 'database', names: ['Modul1Dataset'] },
  { to: '/modul-2', label: 'Modul 2: Forecasting ARIMA', icon: 'trending_up', names: ['Modul2Forecasting', 'Modul2Evaluasi'] },
  { to: '/modul-3', label: 'Modul 3: Financial Pattern (FPR)', icon: 'insights', names: ['Modul3FPR'] },
  { to: '/modul-4', label: 'Modul 4: Optimasi GWO', icon: 'tune', names: ['Modul4GWO'] },
  { to: '/modul-5', label: 'Modul 5: Menu PMT & Export', icon: 'restaurant_menu', names: ['Modul5MenuPMT'] }
];

const isDashboard = computed(() => route.name === 'Dashboard');
const pipelineActive = computed(() => pipelineItems.some(item => item.names.includes(route.name)));

function isNamed(names) {
  return names.includes(route.name);
}

function itemClass(active) {
  return [
    'flex items-center gap-space-sm px-space-sm py-2 rounded-lg transition-all border',
    active
      ? 'bg-blue-50 text-blue-700 border-blue-200 font-semibold shadow-sm'
      : 'text-slate-500 border-transparent hover:bg-slate-50 hover:text-slate-900'
  ];
}

const pipelineClass = computed(() => [
  'flex items-center justify-between px-space-sm py-2 rounded-lg transition-all cursor-pointer list-none [&::-webkit-details-marker]:hidden',
  pipelineActive.value
    ? 'bg-blue-50 text-blue-700 font-semibold'
    : 'text-slate-500 hover:bg-slate-50 hover:text-slate-900'
]);
</script>
