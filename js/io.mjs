import {argv, exit} from 'node:process'

export function getSudoku(sudoku) {
  if (argv.length !== 83) {
    console.error('Wrong number of arguments. Should be 81 arguments, each 1-9 or "." for unsolved space.')
    exit(1)
  }

  argv.slice(2).forEach((arg, i) => {
    const x = i % 9
    const y = Math.floor(i / 9)
    const chr = arg[0]

    const is_int = chr >= '1' && chr <= '9'
    if (!is_int && chr !== '.') {
      console.error(`Invalid arg: ${arg}`)
      exit(1)
    }

    const item = sudoku.items[x][y]
    item.value = is_int ? chr - '0' : 0
    item.x = x
    item.y = y

    !is_int && sudoku.unsolved.push(item)
  })

  return sudoku
}

export function printSudoku(sudoku) {
  sudoku.items.forEach(row => {
    console.log(row
      .map(item => {
        const val = item.value + item.test_value
        return (val > 0) ? val : '.'
      })
      .join(' ')
    )
  })
  console.log()
}
