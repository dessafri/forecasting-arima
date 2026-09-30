/** @type {import('tailwindcss').Config} */
export default {
  darkMode: "class",
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {"on-background":"#0b1c30","on-tertiary-fixed":"#2a1700","surface":"#f8f9ff","surface-tint":"#006c4a","on-surface-variant":"#3d4a42","on-secondary-fixed-variant":"#004b73","surface-container-highest":"#d3e4fe","on-error":"#ffffff","surface-container-lowest":"#ffffff","on-primary-container":"#f5fff7","surface-dim":"#cbdbf5","on-tertiary-fixed-variant":"#653e00","inverse-on-surface":"#eaf1ff","secondary-fixed":"#cce5ff","error":"#ba1a1a","outline-variant":"#bccac0","on-secondary-container":"#00476e","primary-fixed-dim":"#68dba9","error-container":"#ffdad6","inverse-surface":"#213145","tertiary-fixed":"#ffddb8","primary":"#006948","on-surface":"#0b1c30","inverse-primary":"#68dba9","secondary":"#006398","tertiary":"#825100","surface-variant":"#d3e4fe","primary-fixed":"#85f8c4","on-secondary":"#ffffff","on-primary-fixed-variant":"#005137","on-error-container":"#93000a","secondary-container":"#5bb8fe","background":"#f8f9ff","on-secondary-fixed":"#001d31","secondary-fixed-dim":"#93ccff","on-tertiary-container":"#fffbff","on-primary":"#ffffff","primary-container":"#00855d","surface-container":"#e5eeff","tertiary-container":"#a36700","tertiary-fixed-dim":"#ffb95f","surface-container-low":"#eff4ff","surface-container-high":"#dce9ff","on-primary-fixed":"#002114","on-tertiary":"#ffffff","outline":"#6d7a72","surface-bright":"#f8f9ff"},
      borderRadius: {DEFAULT:"0.25rem",lg:"0.5rem",xl:"0.75rem",full:"9999px"},
      spacing: {"space-xl":"2rem","space-xs":"0.25rem",gutter:"1.5rem","gutter-sm":"1rem","space-md":"1rem","space-sm":"0.5rem",margin:"2rem","margin-sm":"1rem","space-lg":"1.5rem"},
      fontFamily: {"headline-lg-mobile":["Inter"],"body-md":["Inter"],"headline-lg":["Inter"],"display-lg":["Inter"],"body-sm":["Inter"],"headline-sm":["Inter"],"label-md":["Inter"],"body-lg":["Inter"],"label-sm":["Inter"],"data-mono-lg":["JetBrains Mono"],"display-lg-mobile":["Inter"],"data-mono-md":["JetBrains Mono"],"headline-md":["Inter"],"data-mono-sm":["JetBrains Mono"]},
      fontSize: {"headline-lg-mobile":["22px",{lineHeight:"28px",letterSpacing:"-0.015em",fontWeight:"600"}],"body-md":["14px",{lineHeight:"20px",letterSpacing:"0em",fontWeight:"400"}],"headline-lg":["28px",{lineHeight:"36px",letterSpacing:"-0.02em",fontWeight:"600"}],"display-lg":["36px",{lineHeight:"44px",letterSpacing:"-0.025em",fontWeight:"700"}],"body-sm":["12px",{lineHeight:"18px",letterSpacing:"0.01em",fontWeight:"400"}],"headline-sm":["16px",{lineHeight:"24px",letterSpacing:"-0.01em",fontWeight:"600"}],"label-md":["12px",{lineHeight:"16px",letterSpacing:"0.02em",fontWeight:"600"}],"body-lg":["16px",{lineHeight:"24px",letterSpacing:"-0.005em",fontWeight:"400"}],"label-sm":["10px",{lineHeight:"14px",letterSpacing:"0.04em",fontWeight:"600"}],"data-mono-lg":["24px",{lineHeight:"32px",letterSpacing:"-0.02em",fontWeight:"600"}],"display-lg-mobile":["28px",{lineHeight:"36px",letterSpacing:"-0.02em",fontWeight:"700"}],"data-mono-md":["14px",{lineHeight:"20px",letterSpacing:"0em",fontWeight:"500"}],"headline-md":["20px",{lineHeight:"28px",letterSpacing:"-0.015em",fontWeight:"600"}],"data-mono-sm":["12px",{lineHeight:"16px",letterSpacing:"0em",fontWeight:"400"}]}
    }
  },
  plugins: [],
}
