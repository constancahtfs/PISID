<?php
	session_start();
	
	$ip = "localhost";
	$user = "";
	$pass = "";
	$db = "estufa";
	
	$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
				
	$stmt = $userconn->prepare("SELECT idcultura FROM cultura WHERE nomecultura=?");
	$stmt->bind_param("s", $_SESSION["cultura"]);
	$stmt->execute();
	$result = $stmt->get_result();

	$row = mysqli_fetch_array($result);
	$id = $row["idcultura"];
	
	$stmt = $userconn->prepare("SELECT valormin, toleranciamin, toleranciamax, valormax FROM parametrocultura WHERE tiposensor = 'H' AND idcultura=?");
	$stmt->bind_param("s", $id);
	$stmt->execute();
	$result = $stmt->get_result();
	
	$row = mysqli_fetch_array($result);
	$minh = $row["valormin"];
	$tminh = $row["toleranciamin"];
	$tmaxh = $row["toleranciamax"];
	$maxh = $row["valormax"];
	
	$stmt = $userconn->prepare("SELECT valormin, toleranciamin, toleranciamax, valormax FROM parametrocultura WHERE tiposensor = 'T' AND idcultura=?");
	$stmt->bind_param("s", $id);
	$stmt->execute();
	$result = $stmt->get_result();

	$row = mysqli_fetch_array($result);
	$mint = $row["valormin"];
	$tmint = $row["toleranciamin"];
	$tmaxt = $row["toleranciamax"];
	$maxt = $row["valormax"];
	
	$stmt = $userconn->prepare("SELECT valormin, toleranciamin, toleranciamax, valormax FROM parametrocultura WHERE tiposensor = 'L' AND idcultura=?");
	$stmt->bind_param("s", $id);
	$stmt->execute();
	$result = $stmt->get_result();
	
	$row = mysqli_fetch_array($result);
	$minl = $row["valormin"];
	$tminl = $row["toleranciamin"];
	$tmaxl = $row["toleranciamax"];
	$maxl = $row["valormax"];
				
	$userconn->close();
?>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<style>
@font-face{
	font-family: kanit;
	src: url(Kanit-Regular.ttf);
}

body{
	font-family: kanit;

	background-image: linear-gradient(to top, rgba(132,188,116,1) 0%, rgba(255,255,255,1) 50%);
	background-attachment: fixed;
	
	padding: 0;
	margin: 0;
}

header{
	display: flex;
	background-color: rgb(100,153,86);
	color: white;
	font-size: 1.5em;
	align-items: center;
	justify-content: center;
	border-bottom-style: solid;
	border-color: rgb(32,49,28);
	
	height: 50px;
	margin: 0;
	padding: 0;
}

label{
	color: white;
	font-size: 1.2em;
}

input{
	height: 20px;
	width: 135px;
}

input[type=number]{
	height: 20px;
	width: 55px;
}

input[type=submit]{
	background-color: rgb(100,153,86);
	border-style: solid;
	border-width: 3px;
	border-color: rgb(64,98,55);
	color: white;
	cursor: pointer;
	font-size: 1.2em;
	border-radius: 10px;
	font-family: kanit;
	
	width: 200px;
	height: 50px;
	padding: 0;
	margin: 0;
}

legend{
	font-size: 1.2em;
	background-color: rgba(86,131,73,1);
	border-style: solid;
	border-width: 3px;
	border-color: rgb(32,49,28);
	border-radius: 10px;
	color: white;
	padding: 5px;
}

fieldset{
	display: flex;
	justify-content: space-around;
	text-align: center;
	flex-wrap: wrap;
	row-gap: 20px;
	background-color: rgba(86,131,73,1);
	border-width: 3px;
	border-style: solid;
	border-color: rgb(32,49,28);
	margin-top: 25px;
	padding-top: 12px;
}

.form_buttons{
	display: flex;
	justify-content: center;
	padding-bottom: 10px;
	width: 800px;
	margin-left: -5px;
	gap: 283px;
}

label{
	color: white;
	font-size: 1.2em;
}

input{
	height: 20px;
	width: 135px;
}

input[type=submit]{
	background-color: rgb(100,153,86);
	border-style: solid;
	border-width: 3px;
	border-color: rgb(32,49,28);
	color: white;
	cursor: pointer;
	font-size: 1.2em;
	border-radius: 10px;
	font-family: kanit;
	
	width: 150px;
	height: 40px;
	padding: 0;
	margin: 0;
}

#voltar{
	background-color: rgb(100,153,86);
	border-style: solid;
	border-width: 3px;
	border-color: rgb(32,49,28);
	color: white;
	cursor: pointer;
	font-size: 1.2em;
	border-radius: 10px;
	font-family: kanit;
	text-align: center;
	
	width: 150px;
	height: 40px;
	padding: 0;
	padding-top: 10px;
	margin: 0;
}

#no_input_label{
	color: white;
	font-size: 1.2em;
	padding: 0;
	margin: 0;
}

#no_input{
	padding: 0;
	margin: 0;
	background-color: white;
}

#back{
	display: flex;
	justify-content: center;
	margin-left: -6px;
	padding-top: 10px;
}

a{
	text-decoration: none;
	color: white;
}

</style>
</head>
<body>

	<header>
		<p><?php echo $_SESSION["cultura"]; ?></p>
	</header>
	
	<form style="width: 900px; margin: auto" method="post">
		<fieldset style="margin-top: 30px;">
			<legend>Dados da Cultura</legend>
			<div>
				<label for="nome">Nome da Cultura:</label><br>
				<input type="text" id="nome" name="nome" value="<?php echo $_SESSION["cultura"]; ?>" autocomplete="off">
			</div>
			<div>
				<label for="intervalo">Intervalo entre Alertas:</label><br>
				<input type="number" id="intervalo" name="intervalo" value="<?php echo $_SESSION["intervalo"]; ?>" autocomplete="off">
			</div>
			<div>
				<p id="no_input_label">Estado da Cultura:</p>
				<p id="no_input"><?php echo $_SESSION["estado"]; ?></p>
			</div>
			<div class="form_buttons">
				<input type="submit" value="Guardar Nome" name="alterar_nome">
				<input type="submit" value="Alterar Estado" name="alterar_estado">
			</div>
		</fieldset>
		<fieldset>
			<legend>Parâmetros de Humidade</legend>
			<div>
				<label for="vmin">Valor Mínimo:</label>
				<input step=".01" type="number" id="vminh" name="vminh" value="<?php echo $minh; ?>" autocomplete="off">
			</div>
			<div>
				<label for="tmin">Tolerância Mínima:</label>
				<input step=".01" type="number" id="tminh" name="tminh" value="<?php echo $tminh; ?>" autocomplete="off">
			</div>
			<div>
				<label for="tmax">Tolerância Máxima:</label>
				<input step=".01" type="number" id="tmaxh" name="tmaxh" value="<?php echo $tmaxh; ?>" autocomplete="off">
			</div>
			<div>
				<label for="vmax">Valor Máximo:</label>
				<input step=".01" type="number" id="vmaxh" name="vmaxh" value="<?php echo $maxh; ?>" autocomplete="off">
			</div>
			<div class="form_buttons">
				<input type="submit" value="Guardar" name="alterar_hum">
			</div>
		</fieldset>
		<fieldset>
			<legend>Parâmetros de Temperatura</legend>
			<div>
				<label for="vmin">Valor Mínimo:</label>
				<input step=".01" type="number" id="vmint" name="vmint" value="<?php echo $mint; ?>" autocomplete="off">
			</div>
			<div>
				<label for="tmin">Tolerância Mínima:</label>
				<input step=".01" type="number" id="tmint" name="tmint" value="<?php echo $tmint; ?>" autocomplete="off">
			</div>
			<div>
				<label for="tmax">Tolerância Máxima:</label>
				<input step=".01" type="number" id="tmaxt" name="tmaxt" value="<?php echo $tmaxt; ?>" autocomplete="off">
			</div>
			<div>
				<label for="vmax">Valor Máximo:</label>
				<input step=".01" type="number" id="vmaxt" name="vmaxt" value="<?php echo $maxt; ?>" autocomplete="off">
			</div>
			<div class="form_buttons">
				<input type="submit" value="Guardar" name="alterar_temp">
			</div>
		</fieldset>
		<fieldset>
			<legend>Parâmetros de Luz</legend>
			<div>
				<label for="vmin">Valor Mínimo:</label>
				<input step=".01" type="number" id="vminl" name="vminl" value="<?php echo $minl; ?>" autocomplete="off">
			</div>
			<div>
				<label for="tmin">Tolerância Mínima:</label>
				<input step=".01" type="number" id="tminl" name="tminl" value="<?php echo $tminl; ?>" autocomplete="off">
			</div>
			<div>
				<label for="tmax">Tolerância Máxima:</label>
				<input step=".01" type="number" id="tmaxl" name="tmaxl" value="<?php echo $tmaxl; ?>" autocomplete="off">
			</div>
			<div>
				<label for="vmax">Valor Máximo:</label>
				<input step=".01" type="number" id="vmaxl" name="vmaxl" value="<?php echo $maxl; ?>" autocomplete="off">
			</div>
			<div class="form_buttons">
				<input type="submit" value="Guardar" name="alterar_luz">
			</div>
		</fieldset>
	</form>
	
	<div id="back">
		<a id="voltar" href="investigador.php">Voltar</a>
	</div>
	
	<?php
	
	if(isset($_POST["alterar_nome"]) && isset($_POST["nome"])){
				
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			$stmt = $userconn->prepare("CALL AlterarCultura(?,?)");
			$stmt->bind_param("ss", $_SESSION["cultura"], $_POST["nome"]);
			$stmt->execute();
					
			$userconn->close();
			
			$_SESSION["cultura"] = $_POST["nome"];
			unset($_POST["alterar_nome"]);
			unset($_POST["nome"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["alterar_estado"])){
			
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			$stmt = $userconn->prepare("CALL AlterarEstado(?)");
			$stmt->bind_param("s", $_SESSION["cultura"]);
			$stmt->execute();
					
			$userconn->close();
			
			if($_SESSION["estado"] == "Inativa"){
				$_SESSION["estado"] = "Ativa";
			}else{
				$_SESSION["estado"] = "Inativa";
			}
			unset($_POST["alterar_estado"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["alterar_intervalo"]) && isset($_POST["intervalo"]){
			
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			$stmt = $userconn->prepare("CALL AlterarIntervalo(?,?)");
			$stmt->bind_param("si", $_SESSION["cultura"], $_POST["intervalo"]);
			$stmt->execute();
					
			$userconn->close();
			
			$_SESSION["intervalo"] = $_POST["intervalo"];
			unset($_POST["intervalo"]);
			unset($_POST["alterar_intervalo"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["alterar_hum"]) && isset($_POST["vmaxh"]) && isset($_POST["tmaxh"]) && isset($_POST["tminh"]) && isset($_POST["vminh"])){
				
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			$stmt = $userconn->prepare("CALL AlterarParametrosCultura(?,'H',?,?,?,?)");
			$stmt->bind_param("sdddd", $_SESSION["cultura"], $_POST["vmaxh"], $_POST["tmaxh"], $_POST["tminh"], $_POST["vminh"]);
			$stmt->execute();
					
			$userconn->close();
			
			unset($_POST["vminh"]);
			unset($_POST["tminh"]);
			unset($_POST["tmaxh"]);
			unset($_POST["vmaxh"]);
			unset($_POST["alterar_hum"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["alterar_temp"]) && isset($_POST["vmaxt"]) && isset($_POST["tmaxt"]) && isset($_POST["tmint"]) && isset($_POST["vmint"])){
			
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			$stmt = $userconn->prepare("CALL AlterarParametrosCultura(?,'T',?,?,?,?)");
			$stmt->bind_param("sdddd", $_SESSION["cultura"], $_POST["vmaxt"], $_POST["tmaxt"], $_POST["tmint"], $_POST["vmint"]);
			$stmt->execute();
					
			$userconn->close();
			
			unset($_POST["vmint"]);
			unset($_POST["tmint"]);
			unset($_POST["tmaxt"]);
			unset($_POST["vmaxt"]);
			unset($_POST["alterar_temp"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["alterar_luz"]) && isset($_POST["vmaxl"]) && isset($_POST["tmaxl"]) && isset($_POST["tminl"]) && isset($_POST["vminl"])){
			
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			$stmt = $userconn->prepare("CALL AlterarParametrosCultura(?,'L',?,?,?,?)");
			$stmt->bind_param("sdddd", $_SESSION["cultura"], $_POST["vmaxl"], $_POST["tmaxl"], $_POST["tminl"], $_POST["vminl"]);
			$stmt->execute();
					
			$userconn->close();
			
			unset($_POST["vminl"]);
			unset($_POST["tminl"]);
			unset($_POST["tmaxl"]);
			unset($_POST["vmaxl"]);
			unset($_POST["alterar_luz"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["voltar"])){
				
		unset($_SESSION["cultura"]);
		unset($_SESSION["estado"]);
		unset($_SESSION["intervalo"]);
		unset($_POST["voltar"]);
		
		header("Location: investigador.php");
	}
	?>
</body>
</html>