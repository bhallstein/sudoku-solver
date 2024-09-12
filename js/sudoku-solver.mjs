import {exit} from 'node:process'
import {getSudoku, printSudoku} from './io.mjs'

function Item() {
  return {
    value: 0,
    test_value: 0,
    x: 0,
    y: 0,
  }
}

function Sudoku() {
  return {
    items: Array(9).fill(0).map(_ => (
      Array(9).fill(0).map(Item)
    )),
    unsolved: [],
  }
}


function isConsistent(sudoku, test_value, at_x, at_y) {
  // Check row
  for (let x=0, count=0; x < 9; ++x) {
    const item = sudoku.items[x][at_y]
    if (item.value + item.test_value == test_value) {
      if (++count > 1) {
        return false
      }
    }
  }

  // Check column
  for (let y=0, count=0; y < 9; ++y) {
    const item = sudoku.items[at_x][y]
    if (item.value + item.test_value == test_value) {
      if (++count > 1) {
        return false
      }
    }
  }

  // Check sector
  const sector_x = Math.floor(at_x / 3) * 3
  const sector_y = Math.floor(at_y / 3) * 3

  for (let y=0, count=0; y < 3; ++y) {
    for (let x=0; x < 3; ++x) {
      const item = sudoku.items[x + sector_x][y + sector_y]
      if (item.value + item.test_value == test_value) {
        if (++count > 1) {
          return false
        }
      }
    }
  }

  return true
}


function solve(sudoku, i_unsolved) {
  for (let test_value=1; test_value < 10; ++test_value) {
    var item = sudoku.unsolved[i_unsolved]
    item.test_value = test_value

    if (isConsistent(sudoku, item.test_value, item.x, item.y)) {
      if (i_unsolved == sudoku.unsolved.length - 1) {
        return true
      }

      const solved = solve(sudoku, i_unsolved + 1)
      if (solved) {
        return true
      }
    }
    item.test_value = 0
  }
  return false
}


function run() {
  const sudoku = getSudoku(Sudoku())
  printSudoku(sudoku)

  const solved = solve(sudoku, 0)
  if (!solved) {
    console.error('Unable to solve.')
    exit(1)
  }

  console.log('Sudoku solved!')
  printSudoku(sudoku)
}

run()
