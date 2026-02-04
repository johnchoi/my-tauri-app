import '@testing-library/jest-dom/vitest'
import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'

// Initialize i18next for tests
i18n.use(initReactI18next).init({
  lng: 'en',
  fallbackLng: 'en',
  ns: ['translation'],
  defaultNS: 'translation',
  interpolation: {
    escapeValue: false,
  },
  resources: {
    en: {
      translation: {
        app: {
          title: 'Tauri App',
          subtitle: 'Built with React + TypeScript',
        },
        example: {
          enterName: 'Enter your name',
          greet: 'Greet',
        },
        common: {
          loading: 'Loading…',
        },
      },
    },
  },
})

Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: (query: string) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: () => undefined,
    removeListener: () => undefined,
    addEventListener: () => undefined,
    removeEventListener: () => undefined,
    dispatchEvent: () => false,
  }),
})
