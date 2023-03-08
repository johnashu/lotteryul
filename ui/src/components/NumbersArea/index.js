const NumbersArea = ({ id, array, children }) => {
  const render = () => {
    return array.map((num, i) => {
      return (
        <div key={`${id}_${i}`}>
          <span>{num}</span>
        </div>
      )
    })
  }
  return (
    <div id={id} className='numbers-area'>
      {children ? children : render()}
    </div>
  )
}

export default NumbersArea
