import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'

const backendPort = Number(process.env.NUTRICAST_BACKEND_PORT || 5051)

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: `http://127.0.0.1:${backendPort}`,
        changeOrigin: true,
      },
    },
  },
})
