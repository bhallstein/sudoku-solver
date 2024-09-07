// sudoko solver - command line version taking input as 81 ARGV arguments.
//
// Arguments should be single numbers, using '.' to denote an unsolved location.
// The order of arguments is across then down.
//
// On success, prints the solved sudoku.
// On failure, prints error message.

#include <stdio.h>

typedef struct unit {
	int value, test_value;
	int x, y;
} unit;


int getSudoku(unit sudoku[][9], unit* unsolved[], int* n_unsolved, int argc, char *argv[]);
void printSudoku(unit [][9]);
int isConsistent(int n, int x, int y, unit[][9]);
int solve(int x, int n_unsolved, unit* unsolved[], unit sudoku[][9]);


int main(int argc, char *argv[]) {
	unit sudoku[9][9];
	unit* unsolved[81];
	int n_unsolved;

	int result = getSudoku(sudoku, unsolved, &n_unsolved, argc, argv);
	if (!result) {
		return 1;
	}

	printSudoku(sudoku);
	int e = solve(0, n_unsolved, unsolved, sudoku);
	if (!e) {
		printf("Sudoku could not be solved.\n");
		return 1;
	}

	printf("Sudoku solved!\n");
	printSudoku(sudoku);
	return 0;
}


int getSudoku(unit sudoku[][9], unit* unsolved[], int* n_unsolved, int argc, char *argv[]) {
	if (argc != 82) {
		printf("Wrong number of arguments\n");
		return 0;
	}

	*n_unsolved = 0;

	for (int y=0; y < 9; y++) {
		for (int x=0; x < 9; x++) {
			int chr = argv[y*9 + x + 1][0];
			int is_int = chr >= '1' && chr <= '9';
			if (!is_int && chr != '.') {
				printf("Invalid argument. Arguments must be 1-9 or '.' for an empty space.\n");
				return 0;
			}

			unit* item = &sudoku[x][y];
			item->value = item->test_value = 0;
			item->x = x, item->y = y;

			if (is_int) {
				item->value = chr - '0';
			}
			else {
				unsolved[(*n_unsolved)++] = item;
			}
		}
	}

	return 1;
}


void printSudoku(unit sudoku[][9]) {
	for (int y = 0; y < 9; y++) {
		for (int x = 0; x < 9; x++) {
			unit item = sudoku[x][y];
			int val = item.value + item.test_value;
			if (val > 0) printf("%d ", val);
			else printf(". ");
		}
		printf("\n");
	}
	printf("\n");
}


int isConsistent(int n, int at_x, int at_y, unit sudoku[][9]) {
	// Check row
	for (int x=0, count=0; x < 9; x++) {
		unit item = sudoku[x][at_y];
		if (item.value + item.test_value == n) {
			if (++count > 1) {
				return 0;
			}
		}
	}

	// Check column
	for (int y=0, count=0; y<9; y++) {
		unit item = sudoku[at_x][y];
		if (item.value + item.test_value == n) {
			if (++count > 1) {
				return 0;
			}
		}
	}

	// Check sector
	int sector_x = at_x / 3 * 3;
	int sector_y = at_y / 3 * 3;
	for (int y=0, count=0; y < 3; y++) {
		for (int x=0; x < 3; x++) {
			unit item = sudoku[x + sector_x][y + sector_y];
			if (item.value + item.test_value == n) {
				if (++count > 1) {
					return 0;
				}
			}
		}
	}

	return 1;
}


int solve(int i_unsolved, int n_unsolved, unit* unsolved[], unit sudoku[][9]) {
	for (int i=1; i <= 9; i++) {
		unit* item = unsolved[i_unsolved];
		item->test_value = i;

		if (isConsistent(i, item->x, item->y, sudoku)) {
			if (i_unsolved == n_unsolved - 1) {
				return 1;
			}

			int solved = solve(i_unsolved + 1, n_unsolved, unsolved, sudoku);
			if (solved) {
				return 1;
			}
		}
		item->test_value = 0;
	}
	return 0;
}
