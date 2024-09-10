/*
	sudokusolver - command line version taking arguments

	Takes input from 81 arguments to main, passed from the environment.
	These arguments should be single numbers, using '.' to denote an unsolved location.
	The order of arguments is across then down.

	On success, it prints the solved sudoku.
	On failure it outputs:
		 0		seemingly valid input, but could not solve
*/

#include <stdio.h>
#include <stdlib.h>

struct unit {
	int value;
	int testValue;
};

void getSudoku(struct unit *p_sudoku[][9], int argc, char *argv[]);
void getUnsolved(struct unit *p_sudoku[][9], struct unit *unsolved[]);
void printSudoku(struct unit *p_sudoku[][9]);
int  is_inconsistent(int i, struct unit *p_sudoku[][9]);
int  solve(int x, int n_unsolved, struct unit *unsolved[], struct unit *p_sudoku[][9]);
void solved(struct unit *p_sudoku[][9]);

int main(int argc, char *argv[]) {
	int n_unsolved=0, d, e, x, y;
	struct unit sudoku[9][9];		/* Make 9x9 array of 'unit's */
	struct unit *p_sudoku[9][9];	/* Make 9x9 array of pointers to units */

	// Point each p_sudoku at appropriate sudoku unit
	for (y=0; y<9; y++)
		for (x=0; x<9; x++)
			p_sudoku[x][y] = &sudoku[x][y];

	// Set the sudoku units' initial values
	// (and set all testValues to 0)
	printf("Enter sudoku, leaving spaces where unsolved:\n");
	getSudoku(p_sudoku, argc, argv);

	// Count the number of unsolved units
	for (y=0; y<9; y++) {
		for (x=0; x<9; x++) {
			d = p_sudoku[x][y]->value;
			if (!(d >= 1 && d <= 9))
				n_unsolved++;
		}
	}
	// Create array of pointers to the unsolved units
	struct unit *unsolved[n_unsolved];
	getUnsolved(p_sudoku, unsolved);
	// Print out the sudoku as entered
	printSudoku(p_sudoku);
	// Begin solving the sudoku
	e = solve(0, n_unsolved, unsolved, p_sudoku);

	if (e==0)
		printf("Sudoku could not be solved.\n");
}



void getSudoku(struct unit *p_sudoku[][9], int argc, char *argv[]) {
	int x, y, n=0;

	// Get solved values and set unsolveds' values to 0
	for (y=0; y<9; y++) {
		for (x=0; x<9; x++) {
			n++;
			if (argv[n][0] >= '1' && argv[n][0] <= '9')
				p_sudoku[x][y]->value = argv[n][0]-'0';
			else
				p_sudoku[x][y]->value = 0;
		}
	}

	// Set all testValues to 0
	for (y=0; y<9; y++)
		for (x=0; x<9; x++)
			p_sudoku[x][y]->testValue = 0;
}

void getUnsolved(struct unit *p_sudoku[][9], struct unit *unsolved[]) {
	int i=0, x, y, d;

	for (y=0; y<9; y++) {
		for (x=0; x<9; x++) {
			d = p_sudoku[x][y]->value;
			if (!(d >= 1 && d <= 9)) {
				unsolved[i] = p_sudoku[x][y];
				i++;
			}
		}
	}
}

void printSudoku(struct unit *p_sudoku[][9]) {
	int x, y, d;

	for (y=0; y<9; y++) {
			for (x=0; x<9; x++) {
				d = p_sudoku[x][y]->value;
				if (d>0 && d<10)
					printf("%d ", d);
				else {
					d = p_sudoku[x][y]->testValue;
					if (d>0 && d<10)
						printf("%d ", d);
					else
						printf(". ");
				}
			}
			printf("\n");
	}
}

int is_inconsistent(int i, struct unit *p_sudoku[][9]) {
	int x, y, a, b, count;

	// Check rows
	for (y=0; y<9; y++) {
		count=0;
		for (x=0; x<9; x++) {
			if (p_sudoku[x][y]->value == i || p_sudoku[x][y]->testValue == i)
				count++;
		}
		if (count > 1)
			return 1;
	}

	// Check columns
	for (x=0; x<9; x++) {
		count = 0;
		for (y=0; y<9; y++) {
			if (p_sudoku[x][y]->value == i || p_sudoku[x][y]->testValue == i)
				count++;
		}
		if (count > 1)
			return 1;
	}

	// Check sectors
	for (y=0; y<7; y+=3) {
		for (x=0; x<7; x+=3) {
			count=0;
			for (b=0; b<3; b++) {
				for (a=0; a<3; a++) {
					if (p_sudoku[x+a][y+b]->value == i || p_sudoku[x+a][y+b]->testValue == i)
						count++;
				}
			}
			if (count > 1)
				return 1;
		}
	}

	return 0;
}

int solve(int x, int n_unsolved, struct unit *unsolved[], struct unit *p_sudoku[][9]) {
	int i;

	for (i=1; i<=9; i++) {
		unsolved[x]->testValue = i;
		if (is_inconsistent(unsolved[x]->testValue, p_sudoku) == 0) {
			// If not inconsistent, & there is another unsolved unit, solve next.
			if (x<n_unsolved-1)
				solve(x+1, n_unsolved, unsolved, p_sudoku);
			// If consistent, & there are no more unsolved units, we're done!
			else
				solved(p_sudoku);
		}
		unsolved[x]->testValue = 0;
	}
	return 0;
}

/* The solved() function is run when the sudoku has been solved */
void solved(struct unit *p_sudoku[][9]) {
	printf("\nSudoku solved!\n");
	printSudoku(p_sudoku);
	exit(0);
}
