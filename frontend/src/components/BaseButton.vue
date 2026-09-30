<template>
  <button 
    :class="[
      'inline-flex items-center justify-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all active:scale-95',
      variant === 'primary' ? 'bg-blue-600 hover:bg-blue-700 text-white shadow-sm' : 
      variant === 'secondary' ? 'bg-slate-100 hover:bg-slate-200 text-slate-700 shadow-sm' :
      variant === 'outline' ? 'border border-slate-200 hover:bg-slate-50 text-slate-700' :
      'bg-transparent hover:bg-slate-100 text-slate-600'
    ]"
    v-bind="$attrs"
  >
    <slot></slot>
  </button>
</template>

<script setup>
defineProps({
  variant: {
    type: String,
    default: 'primary'
  }
})
</script>
