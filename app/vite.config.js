import { defineConfig } from "vite";
import path from "node:path";

const host = process.env.TAURI_DEV_HOST;

export default defineConfig({
  root: "src",

  resolve: {
    alias: {
      "~": path.resolve(__dirname, "src"),
    },
  },

  server: {
    strictPort: true,
    host: host || false,
    port: 4321,

    // Evita los errores EBUSY producidos por los binarios de Tauri/Rust
    watch: null,
  },

  build: {
    target: "esnext",
    outDir: "../dist",
    emptyOutDir: true,
    minify: !process.env.TAURI_ENV_DEBUG ? "esbuild" : false,
    sourcemap: !!process.env.TAURI_ENV_DEBUG,
  },
});