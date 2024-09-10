/* Create the XMLHttpRequest */
xmlHttp = false;
try {
	xmlHttp = new ActiveXObject("Msxm2.XMLHTTP");
} catch (e) {
	try {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	} catch (e2) {
		xmlHttp = false;
	}
}
if (!xmlHttp && typeof XMLHttpRequest != 'undefined')
	xmlHttp = new XMLHttpRequest();
	
instructionText = 'Select a unit, then enter a number or press space<br>';
instructionText += 'You&rsquo;ll move on to the next automatically';


function checkInputContent(i) {
	var x;
	if (x = document.getElementById('input' + i).value) {
		if (x.match(/^[1-9]$/) || x == ' ') {
			if (x == ' ')
				document.getElementById('input' + i).value = '';
			if (i<80) {
				i++;
				document.getElementById('input' + i).focus();
			}
		}
	}
}


function setInputContent(i, x) {
	var el;
	el = document.getElementById('input' + i);
	el.value = x;
	textFadeToDarker(el, 242, 153);
}


function notify(msg) {
	var el = document.getElementById('instruction');

	function clearMessage() {
		textFadeToLighter(el, 170, 250);
	}
	function setToMessage() {
		el.innerHTML = msg;
		textFadeToDarker(el, 250, 170);
	}
	function setToInstructions() {
		el.innerHTML = instructionText;
		textFadeToDarker(el, 250, 170);
	}
	
	clearMessage();
	setTimeout(setToMessage, 1000);
	setTimeout(clearMessage, 4000);
	setTimeout(setToInstructions, 5000);
}


function textFadeToDarker(el, currentCol, destCol) {
	currentCol -= 16;
	el.style.color = 'rgb(' + currentCol + ',' + currentCol + ',' + currentCol + ')';
	
	function d() {
		textFadeToDarker(el, currentCol, destCol);
	}
	
	if (currentCol > destCol) {
		setTimeout(d, 40);
	}
}


function textFadeToLighter(el, currentCol, destCol) {
	currentCol += 16;
	el.style.color = 'rgb(' + currentCol + ',' + currentCol + ',' + currentCol + ')';
	
	function e() {
		textFadeToLighter(el, currentCol, destCol)
	}
	
	if (currentCol < destCol) {
		setTimeout(e, 40);
	}
}


function resetSudoku() {
	for (i=0; i<81; i++)
		document.getElementById('input' + i).value = "";
}


function submitSudoku()	{
	substr = "";

	i=0;
	for (y=0; y<9; y++) {
		for (x=0; x<9; x++) {
			if (c = document.getElementById('input' + i).value)
				substr += c;
			else
				substr += '.';
			i++;
		}
	}

	var url = "cgi-bin/websudoku?" + substr;

	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange = retrieveSolution;
	
	xmlHttp.send(null);
}


function retrieveSolution()	{
	if (xmlHttp.readyState == 4)	{
		/*
			The error codes returned by the program websudoku are:
				 0		could not solve
				-1		illegal character in input (not 1-9 or .)
				-2		inconsistency in input
				-3		already solved
		*/
		if (xmlHttp.responseText == "0")	{
			msg = "Could not solve<br>this sudoku.";
			notify(msg);
		}

		else if (xmlHttp.responseText == "-1")	{
			msg = "Psst... one of the numbers you've entered is zero...<br>or maybe not a number...";
			notify(msg);
		}

		else if (xmlHttp.responseText == "-2")	{
			msg = "The sudoku is inconsistent &mdash; somewhere inside a row, column or sector<br>the same number appears more than once.";
			notify(msg);
		}

		else if (xmlHttp.responseText == "-3") {
			msg = "This sudoku is already solved!<br>Good job!";
			notify(msg);
		}

		else 	{
			solution = xmlHttp.responseText.split("|");
			for(i=0; i<81; i++)
				if (!document.getElementById('input' + i).value)
					document.getElementById('input' + i).style.color = 'rgb(242,242,242)';
			for (i=0; i<81; i++)
				if (!document.getElementById('input' + i).value)
					setInputContent(i, solution[i]);
		}
	}
}