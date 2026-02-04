import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'

import en from '@/locales/en.json'
import zh from '@/locales/zh.json'

const language = navigator.language.toLowerCase().startsWith('zh') ? 'zh' : 'en'

i18n.use(initReactI18next).init({
  resources: {
    en: { translation: en },
    zh: { translation: zh },
  },
  lng: language,
  fallbackLng: 'en',
  interpolation: {
    escapeValue: false,
  },
})

/**
 * 根据配置设置语言
 * @param configLanguage 配置中的语言设置
 */
export function setLanguageFromConfig(configLanguage?: 'en' | 'zh' | 'auto') {
  const targetLang = !configLanguage || configLanguage === 'auto'
    ? (navigator.language.toLowerCase().startsWith('zh') ? 'zh' : 'en')
    : configLanguage
  i18n.changeLanguage(targetLang)
}

export default i18n
