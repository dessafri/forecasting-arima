import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // Dashboard & Ringkasan
  { 
    path: '/dashboard', 
    alias: ['/', '/ringkasan', '/ringkasan-dashboard-nutricast'],
    name: 'Dashboard', 
    component: () => import('./views/RingkasanDashboardNutricast.vue') 
  },
  
  // Modul 1: Manajemen Dataset
  { 
    path: '/modul-1', 
    alias: ['/dataset', '/modul1', '/modul-1-manajemen-dataset-upload-excel'],
    name: 'Modul1Dataset', 
    component: () => import('./views/Modul1ManajemenDatasetUploadExcel.vue') 
  },
  
  // Modul 2: Forecasting ARIMA & Evaluasi
  { 
    path: '/modul-2', 
    alias: ['/forecast', '/arima', '/modul2', '/modul-2-forecasting-arima-evaluasi-nutricast-1'],
    name: 'Modul2Forecasting', 
    component: () => import('./views/Modul2ForecastingArimaEvaluasiNutricast1.vue') 
  },
  { 
    path: '/modul-2/evaluasi', 
    alias: ['/modul2-evaluasi', '/modul2_2', '/modul2-2', '/modul-2-forecasting-arima-evaluasi-nutricast-2'],
    name: 'Modul2Evaluasi', 
    component: () => import('./views/Modul2ForecastingArimaEvaluasiNutricast2.vue') 
  },
  
  // Modul 3: Financial Pattern Recognition (FPR)
  { 
    path: '/modul-3', 
    alias: ['/fpr', '/modul3', '/modul-3-financial-pattern-fpr-nutricast'],
    name: 'Modul3FPR', 
    component: () => import('./views/Modul3FinancialPatternFprNutricast.vue') 
  },
  
  // Modul 4: Optimasi GWO
  { 
    path: '/modul-4', 
    alias: ['/gwo', '/modul4', '/modul-4-optimasi-gwo-nutricast'],
    name: 'Modul4GWO', 
    component: () => import('./views/Modul4OptimasiGwoNutricast.vue') 
  },
  
  // Modul 5: Menu PMT & Export
  { 
    path: '/modul-5', 
    alias: ['/menu-pmt', '/export', '/modul5', '/modul-5-menu-pmt-export-nutricast'],
    name: 'Modul5MenuPMT', 
    component: () => import('./views/Modul5MenuPmtExportNutricast.vue') 
  },
  
  // Evaluasi Diagnostik
  { 
    path: '/evaluasi', 
    alias: ['/diagnostik', '/evaluasi-diagnostik-model-nutricast'],
    name: 'EvaluasiDiagnostik', 
    component: () => import('./views/EvaluasiDiagnostikModelNutricast.vue') 
  },
  
  // Default Redirect & Fallback
  { path: '/:pathMatch(.*)*', redirect: '/dashboard' },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router

