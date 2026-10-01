<template>
  <div class="bg-white p-3.5 rounded-xl shadow-[0_1px_4px_rgba(0,0,0,0.03)] border border-slate-100 flex flex-col justify-between transition-all hover:shadow-md">
    <div class="flex flex-col gap-1">
      <div class="flex items-center justify-between gap-1">
        <span class="text-[11px] font-semibold text-slate-500 tracking-wider uppercase truncate" :title="title">{{ title }}</span>
        <span v-if="badge" class="text-[10px] font-semibold px-2 py-0.5 rounded shrink-0" :class="badgeClass">{{ badge }}</span>
      </div>
      <div class="flex items-baseline gap-1.5 mt-0.5">
        <span class="text-xl font-bold tracking-tight" :class="valueClass">
          <slot name="value">{{ value }}</slot>
        </span>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  title: String,
  value: String,
  badge: String,
  footerLeft: String,
  footerRight: String,
  valueClass: { type: String, default: 'text-slate-900' },
  badgeClass: { type: String, default: 'text-blue-600 bg-blue-50 border border-blue-200' },
  footerRightClass: { type: String, default: 'text-blue-600' }
})
</script>

