import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // Modul 1
  { 
    path: '/modul-1-manajemen-dataset-upload-excel', 
    alias: ['/modul1', '/modul-1'],
    name: 'Modul1ManajemenDatasetUploadExcel', 
    component: () => import('./views/Modul1ManajemenDatasetUploadExcel.vue') 
  },
  
  // Modul 2
  { 
    path: '/modul-2-forecasting-arima-evaluasi-nutricast-1', 
    alias: ['/modul2_1', '/modul2-1', '/modul2', '/modul-2'],
    name: 'Modul2ForecastingArimaEvaluasiNutricast1', 
    component: () => import('./views/Modul2ForecastingArimaEvaluasiNutricast1.vue') 
  },
  { 
    path: '/modul-2-forecasting-arima-evaluasi-nutricast-2', 
    alias: ['/modul2_2', '/modul2-2'],
    name: 'Modul2ForecastingArimaEvaluasiNutricast2', 
    component: () => import('./views/Modul2ForecastingArimaEvaluasiNutricast2.vue') 
  },
  
  // Modul 3
  { 
    path: '/modul-3-financial-pattern-fpr-nutricast', 
    alias: ['/modul3', '/modul-3'],
    name: 'Modul3FinancialPatternFprNutricast', 
    component: () => import('./views/Modul3FinancialPatternFprNutricast.vue') 
  },
  
  // Modul 4
  { 
    path: '/modul-4-optimasi-gwo-nutricast', 
    alias: ['/modul4', '/modul-4'],
    name: 'Modul4OptimasiGwoNutricast', 
    component: () => import('./views/Modul4OptimasiGwoNutricast.vue') 
  },
  
  // Modul 5
  { 
    path: '/modul-5-menu-pmt-export-nutricast', 
    alias: ['/modul5', '/modul-5'],
    name: 'Modul5MenuPmtExportNutricast', 
    component: () => import('./views/Modul5MenuPmtExportNutricast.vue') 
  },
  
  // Dashboard & Evaluasi
  { 
    path: '/ringkasan-dashboard-nutricast', 
    alias: ['/dashboard'],
    name: 'RingkasanDashboardNutricast', 
    component: () => import('./views/RingkasanDashboardNutricast.vue') 
  },
  { 
    path: '/evaluasi-diagnostik-model-nutricast', 
    alias: ['/evaluasi'],
    name: 'EvaluasiDiagnostikModelNutricast', 
    component: () => import('./views/EvaluasiDiagnostikModelNutricast.vue') 
  },
  
  // Default Redirect
  { path: '/', redirect: '/ringkasan-dashboard-nutricast' },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
