/*
	sudokusolver1.0w - web version

	This is a version of sudokusolver1.0 optimised to run as a CGI program on a webserver.

	It takes input from the "QUERY_STRING" environment variable, checking this consists of 81 characters of numbers 1-9, or '.'s.

	On success, it outputs a (1-dimensional) string consisting each number of the sudoku separated by '|' (pipe).

	On failure it outputs:
		 0		seemingly valid input, but could not solve
		-1		invalid char, or wrong number of chars, in "QUERY_STRING"
		-2		input is already inconsistent
		-3		input is an already-complete sudoku
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

struct unit {
	int value;
	int testValue;
};

void getSudoku(struct unit *p_sudoku[][9], char input[]);
void getUnsolved(struct unit *p_sudoku[][9], struct unit *unsolved[]);
void printSudoku(struct unit *p_sudoku[][9]);
int  is_inconsistent(int i, struct unit *p_sudoku[][9]);
int  solve(int x, int n_unsolved, struct unit *unsolved[], struct unit *p_sudoku[][9]);
void solved(struct unit *p_sudoku[][9]);

int main() {
	int i, n_unsolved=0, d, e, x, y;
	char *queryString = getenv("QUERY_STRING");
	struct unit sudoku[9][9];		/* Make 9x9 array of 'unit's */
	struct unit *p_sudoku[9][9];	/* Make 9x9 array of pointers to units */

	// Send content header
	printf("Content-type: text/plain\n\n");

	// Check input has 81 characters
	if (strlen(queryString) != 81)  {
		printf("-1");
		exit(0);
	}

	// Check input is composed only of numbers 1-9 & '.'s
	for (i=0; i<81; i++) {
		if (!(isdigit(queryString[i]) || queryString[i] == '.') || queryString[i] == '0') {
			printf("-1");
			exit(0);
		}
	}

	// Point each p_sudoku at appropriate sudoku unit
	for (y=0; y<9; y++)
		for (x=0; x<9; x++)
			p_sudoku[x][y] = &sudoku[x][y];

	// Set the sudoku units' initial values
	// (and set all testValues to 0)
	getSudoku(p_sudoku, queryString);

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

	// Check the entered sudoku is consistent
	for (i=1; i<=9; i++) {
		if (is_inconsistent(i, p_sudoku))	{
			printf("-2");
			exit(0);
		}
	}

	// Check there is at least 1 unsolved unit
	if (n_unsolved < 1) {
		printf("-3");
		exit(0);
	}

	// Begin solving the sudoku
	e = solve(0, n_unsolved, unsolved, p_sudoku);

	// If could not solve, return 0
	if (e==0)
		printf("0");
}



void getSudoku(struct unit *p_sudoku[][9], char input[]) {
	int x, y, n=0;

	// Get solved values and set unsolveds' values to 0
	for (y=0; y<9; y++) {
		for (x=0; x<9; x++) {
			if (input[n] >= '1' && input[n] <= '9')
				p_sudoku[x][y]->value = input[n]-'0';
			else
				p_sudoku[x][y]->value = 0;
			n++;
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
	int i=0, d, x, y;

	for (y=0; y<9; y++) {
		for (x=0; x<9; x++) {
			i++;
			d = p_sudoku[x][y]->value;
			if (d>0 && d<10)
				printf("%d", d);
			else {
				d = p_sudoku[x][y]->testValue;
				if (d>0 && d<10)
					printf("%d", d);
				else
					printf(".");
			}
			if (i<81)
				printf("|");
		}
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
	printSudoku(p_sudoku);
	exit(0);
}
