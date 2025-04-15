import { defineConfig } from 'vitepress'
import { enLocale } from './locales/en.ts'

export default defineConfig({
  cleanUrls: true,
  lang: 'en-US',
  base: '/matject/',
  markdown: {
    image: {lazyLoading: true}
  },
  ignoreDeadLinks: true,
  themeConfig: {
    aside: false,
    outline: false,
    externalLinkIcon: true,
    siteTitle: 'Matject Documentation',
    i18nRouting: true,
    logo: {
      light: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAABgwAAAYMAVZP0FsAAAEYSURBVHhe7dtLCoNAAAXBSe5/53wwy2wykpGhq0B0J2jj5uEAAAAAAAAAAAAAAAAAALZyex2P45Iv3s9nxjbP9P45EyWAOAHECSBOAHECiBNAnADiBBAngDgBxAkgTgBxAog7MwfPTqX8x9R79AWIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBBAngLgr1sAzP06uvudOi6c1kN8JIE4AcQKIE0CcAOIEECeAOAHECSBOAHECiBNAXGUN3MnS9+ELECeAOAHECSBOAHECiBNAnADiBBAngDgBxAkgTgBxu62Bq12xPloDWUcAcQKIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBAAAAAAAAAAAAAAAAAAAsI0xnqj6DollzmTrAAAAAElFTkSuQmCC", // Light mode logo
      dark: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAABg0AAAYNAYQIMr8AAAEdSURBVHhe7dk7DsMgEEBBO/e/cz6Sq3TZKETozTSmQ5gnmj0AAAAAAAAAAAAAAAAAgK2c96drzZvz6Vp+ZKd/eru+RAkgTgBxAogTQJwA4gQQJ4A4AcQJIE4AcQKIE0CcAOLG4+DpqJTfmN6jFyBOAHECiBNAnADiBBAngDgBxAkgTgBxAogTQJwA4pZPA6f7vazec7rfP0zP6AWIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBBAngLjENHAnq+/DCxAngDgBxAkgTgBxAogTQJwA4gQQJ4A4AcQJIE4AcVtNA1ebnvEbq+/DCxAngDgBxAkgTgBxAogTQJwA4gQQJ4A4AcQJIE4AcQIAAAAAAAAAAAAAAAAAANjGcTwAKVw4gAIO+0YAAAAASUVORK5CYII=", // Dark mode logo
      alt: "Logo"
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/faizul726/matject' }
    ],
  },
  locales: {
    root: { label: 'English', lang: 'en', ...enLocale },
  }
})
