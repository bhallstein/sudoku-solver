<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<title>Sudoku Solver</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="viewport" content="width=600">
<meta name="description" content="The loveliest sudoku solver on the internet.">

<link rel="icon" href="images/favicon.png" type="image/x-icon">

<script src="ajax.js" type="text/Javascript"></script> 
<style type="text/css">
img			{	border: none;	}

body		{	margin: 0;
				text-align: center;
				background: url(images/page-bg.png);
				background-repeat: repeat-x;
				color: #aaaaaa;
				font-size: 12px;
				font-family: Verdana, Helvetica, sans-serif;	}

#title		{	margin: 30px auto 0 auto;	}

#main		{	margin-top: 40px;
				padding-bottom: 50px;	}

#main p		{	margin: 0.5ex;
				margin-bottom: 0;
				line-height: 1.4;
				text-align: center;	}

#main img	{	margin-top: 23px;	}

#solver		{	background: url(images/sudoku.png);
				background-repeat: no-repeat;
				position: relative;
				width: 484px;
				height: 484px;
				text-align: left;
				margin: 12px auto 0;	}

#solver input	{	display: block;
					position: absolute;
					width: 48px;
					height: 39px;
					padding-top: 10px;
					margin: 0;
					border: 0;
					background: none;
					
					color: #999;
					text-align: center;
					font-size: 22px;
					font-family: 'HelveticaNeue-UltraLight', 'Helvetica Neue', Helvetica, Verdana, Arial, sans-serif;
					font-weight: 100;	}
</style>
</head>

<body>

<div id="title">
	<img src="images/title.png" alt="Sudoku Solver">
</div>

<div id="main">
	<p id="instruction">Select a unit, then enter a number or press space<br>
	You&rsquo;ll move on to the next automatically</p>

	<div id="solver">
		<form action="javascript:submitSudoku();">
			<div>
<?
	/* Generate 91 inputs with correct absolute positions */
	$n = 0;
	$hpos = array(3, 57, 111, 165, 219, 272, 326, 380, 433);
	$vpos = array(3, 56, 109, 164, 217, 270, 325, 378, 432);

	for ($y=0; $y<9; $y++) {
		for ($x=0; $x<9; $x++) {
			echo "<input type=\"text\" maxlength=1 ";
			echo "style=\"top: $vpos[$y]px; left: $hpos[$x]px;\" ";
			echo "id=\"input$n\" ";
			echo "onkeyup=\"javascript:checkInputContent($n);\">";
			echo "\n";
			$n++;
		}
		echo "\n";
	}
?>
			</div>
		</form>
	</div>
	<a href="javascript:submitSudoku();"><img src="images/solve.png" alt="Solve"></a>
	<br>
	<a href="javascript:resetSudoku();"><img src="images/reset.png" alt="Reset"></a>
</div>

</body>