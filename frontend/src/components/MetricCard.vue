<template>
  <div class="bg-white p-5 rounded-2xl shadow-[0_2px_12px_rgba(0,0,0,0.04)] border border-slate-100 flex flex-col justify-between transition-all hover:shadow-md">
    <div class="flex flex-col gap-1">
      <span class="text-xs font-medium text-slate-500 tracking-wider uppercase">{{ title }}</span>
      <div class="flex items-baseline gap-2 mt-1">
        <span class="text-2xl font-bold tracking-tight" :class="valueClass">
          <slot name="value">{{ value }}</slot>
        </span>
        <span v-if="badge" class="text-xs font-semibold px-2 py-0.5 rounded" :class="badgeClass">{{ badge }}</span>
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
  badgeClass: { type: String, default: 'text-blue-600 bg-surface-container-highest' },
  footerRightClass: { type: String, default: 'text-blue-600' }
})
</script>
