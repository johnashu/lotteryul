import './styles.css'

const Button = ({ className, onClick, children, disabled }) => (
  <button
    className={`game-button${className ? ` ${className}` : ''}`}
    onClick={onClick}
    disabled={disabled}
  >
    {children}
  </button>
)

export default Button
