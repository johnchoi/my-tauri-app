import { render, screen } from '@testing-library/react'
import { App } from '@/App'

vi.mock('@tauri-apps/api/core', () => {
  return {
    invoke: vi.fn(async (cmd: string, args: any) => {
      if (cmd === 'greet') {
        return `Hello, ${args.name}! Welcome to Tauri!`
      }
      return null
    }),
  }
})

describe('App smoke test', () => {
  it('renders without crashing', () => {
    render(<App />)
    expect(screen.getByText(/Tauri App/i)).toBeInTheDocument()
  })

  it('renders main sections', () => {
    render(<App />)
    expect(screen.getByText(/Tauri Command Example/i)).toBeInTheDocument()
    expect(screen.getByText(/Counter Example/i)).toBeInTheDocument()
    expect(screen.getByText(/Getting Started/i)).toBeInTheDocument()
  })
})
