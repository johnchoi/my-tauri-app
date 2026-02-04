import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { Counter } from '@/components/Counter'

describe('Counter', () => {
  it('renders with initial value', () => {
    render(<Counter initialValue={5} />)
    expect(screen.getByText('5')).toBeInTheDocument()
  })

  it('increments counter when + button is clicked', async () => {
    const user = userEvent.setup()
    render(<Counter initialValue={0} />)
    
    const incrementButton = screen.getByRole('button', { name: '+' })
    await user.click(incrementButton)
    
    expect(screen.getByText('1')).toBeInTheDocument()
  })

  it('decrements counter when - button is clicked', async () => {
    const user = userEvent.setup()
    render(<Counter initialValue={5} />)
    
    const decrementButton = screen.getByRole('button', { name: '-' })
    await user.click(decrementButton)
    
    expect(screen.getByText('4')).toBeInTheDocument()
  })

  it('resets counter when Reset button is clicked', async () => {
    const user = userEvent.setup()
    render(<Counter initialValue={10} />)
    
    const incrementButton = screen.getByRole('button', { name: '+' })
    await user.click(incrementButton)
    expect(screen.getByText('11')).toBeInTheDocument()
    
    const resetButton = screen.getByRole('button', { name: 'Reset' })
    await user.click(resetButton)
    
    expect(screen.getByText('10')).toBeInTheDocument()
  })
})
