<?php
	session_start();
	
	if(!isset($_SESSION["authenticated"])){
		header("Location: login.php");
	}else{
		$ip = "localhost";
		$user = "";
		$pass = "";
		$db = "estufa";
	}
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

#users{
	display: block;
	height: 671px;
}

#culturas{
	display: none;
	height: 671px;
}

.form_template{
	margin: 0;
	border-style: solid;
	border-width: 5px;
	border-color: rgb(32,49,28);
	width: 800px;
	height: 150px;
	background-color: rgba(86,131,73,1);
	padding-top: 25px;
}

.form_pad{
	display: none;
	height: 223px;
	width: 815px;
	padding: 250px 340px;
}

.scroll{
	overflow-y: auto;
	height: 584px;
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
	justify-content: space-between;
	border-bottom-style: solid;
	border-color: rgb(32,49,28);
	
	height: 50px;
	margin: 0;
	padding: 0;
}

#tabs{
	display: flex;
	align-items: center;
}

label{
	color: white;
	font-size: 1.2em;
}

input{
	height: 20px;
	width: 135px;
}

input[type=submit], input[type=reset]{
	background-color: rgb(100,153,86);
	border-style: solid;
	border-width: 3px;
	border-color: rgb(32,49,28);
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

.form_open{
	background-color: rgb(100,153,86);
	border-style: solid;
	border-color: rgb(32,49,28);
	color: white;
	cursor: pointer;
	font-size: 1.2em;
	border-radius: 10px;
	font-family: kanit;
	display: flex;
	align-items: center;
	justify-content: center;
	
	width: 195.2px;
	height: 45.2px;
	padding: 0;
	margin: 0;
}

#culturas:target{
	display: block;
}

#culturas:target + #users{
	display: none;
}

a{
	display: flex;
	align-items: center;
	padding: 5px;
	margin: 0;
	height: 40px;
	text-decoration: none;
	color: white;
}

#u{
	background-color: rgb(86,131,73);
}

#c{
	background-color: rgba(86,131,73,0.5);
}

#u:hover, #c:hover{
	background-color: rgb(122,172,108);
}

#u:active, #c:active{
	background-color: rgb(64,98,55);
}

#logout{
	margin: 0;
	height: 50px;
	text-decoration: none;
	color: rgb(32,49,28);
	background-color: none;
	border: none;
	width: 100px;
	padding: 0;
	padding-bottom: 5px;
	padding-right: 5px;
}

#table {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#table td, #table th {
  padding: 8px;
}

#table tr:nth-child(even){background-color: #f2f2f2;}

#table tr:hover {background-color: #ddd;}

#table th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: rgb(64,98,55);
  color: white;
  position: sticky;
  top: -1px;
}

fieldset{
	display: flex;
	justify-content: space-evenly;
	text-align: center;
	border-width: 3px;
	border: none;
	border-top-style: dashed;
	border-color: rgb(32,49,28);
	margin-top: 10px;
	padding-top: 12px;
	bottom: 0;
}

.form{
	display: flex;
	justify-content: space-evenly;
	flex-wrap: wrap;
	row-gap: 40px;
}

.form_buttons{
	display: flex;
	gap: 35px;
}

</style>
<script>
$(document).ready(function(){

    $("#user_close").click(function(){
        $("#user_create").css("display", "none");
    });
    
    $("#user_open").click(function(){
        $("#user_create").css("display", "block");
    });
	
    $("#cultura_close").click(function(){
        $("#cultura_create").css("display", "none");
    });
    
    $("#cultura_open").click(function(){
        $("#cultura_create").css("display", "block");
    });
	
	$("#atribuir_close").click(function(){
        $("#cultura_atribuir").css("display", "none");
    });
    
    $("#atribuir_open").click(function(){
        $("#cultura_atribuir").css("display", "block");
    });
});
</script>
</head>
<body>

	<div style="position: absolute; width: 100%; z-index: -1">
		<header>
			<div id="tabs">
				<a id="u" href="#users">Utilizadores</a>
				<a id="c" href="#culturas">Culturas</a>
			</div>
			
			<p>Bem-vindo <?php echo explode('@', $_SESSION["user"])[0] ?>!</p>
			
			<form method="post">
				<input id="logout" type="submit" value="Logout" name="logout">
			</form>
		</header>
		
		<div id="culturas">
			<form method="post">
				<div class="scroll">
					<table id="table">
					  <tr>
						<th>Nome</th>
						<th>Investigador Responsável</th>
						<th>Zona</th>
						<th>Estado</th>
						<th>Apagar Cultura?</th>
					  </tr>
					  
					  <?php
					  
					  $userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					  
					  $stmt = $userconn->prepare("SELECT nomecultura, idutilizador, idzona, estado FROM cultura");
					  $stmt->execute();
					  $result = $stmt->get_result();
					  
					  $stmt = $userconn->prepare("SELECT nomeutilizador FROM utilizador WHERE idutilizador=?");
					  
					  while($row = mysqli_fetch_array($result)){
						  $nome = $row["nomecultura"];
						  
						  $id = $row["idutilizador"];
						  if($id == "NÃO_ATRIBUÍDA"){
							  $inv = $id;
						  }else{
							  $stmt->bind_param("s", $id);
							  $stmt->execute();
							  $result_nome = $stmt->get_result();
							  if($result_nome->num_rows > 0){
								  $row_nome = $result_nome->fetch_assoc();
								  $inv = $row_nome["nomeutilizador"];
							  }
						  }
						  
						  $zona = $row["idzona"];
						  
						  $estado = $row["estado"];
						  if($estado == 0){
							  $estado = "Inativa";
						  }elseif($estado == 1){
							  $estado = "Ativa";
						  }
					  ?>
					  
					  <tr>
						<td><?php echo htmlspecialchars($nome); ?></td>
						<td><?php echo htmlspecialchars($inv); ?></td>
						<td><?php echo htmlspecialchars($zona); ?></td>
						<td><?php echo htmlspecialchars($estado); ?></td>
						<td><input style="width: 15px; height: 15px; margin-left: 50px" type="checkbox" name="check_cultura[]" value="<?php echo htmlspecialchars($nome); ?>"></td>
					  </tr>
					  
					  <?php
					  }
					  $userconn->close();
					  ?>
					</table>
				</div>
				
				<fieldset>
					<p class="form_open" id="cultura_open">Criar Cultura</p>
					<p class="form_open" id="atribuir_open">Atribuir Cultura</p>
					<input type="submit" value="Apagar Cultura/s" name="delete_cultura">
				</fieldset>
			</form>
		</div>
		
		<div id="users">
			<form method="post">
				<div class="scroll">
					<table id="table">
					  <tr>
						<th>Nome</th>
						<th>Tipo de Utilizador</th>
						<th>Apagar Utilizador?</th>
					  </tr>
					  
					  <?php
					  
					  $userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					  
					  $stmt = $userconn->prepare("SELECT nomeutilizador, tipoutilizador, emailutilizador FROM utilizador WHERE tipoutilizador = 'I' OR tipoutilizador = 'T'");
					  $stmt->execute();
					  $result = $stmt->get_result();

					  $userconn->close();
					  
					  while($row = mysqli_fetch_array($result)){
						  $nome = $row["nomeutilizador"];
						  
						  $tipo = $row["tipoutilizador"];
						  if($tipo == 'I'){
							  $tipo = "Investigador";
						  }elseif($tipo == 'T'){
							  $tipo = "Técnico";
						  }
						  
						  $email = $row["emailutilizador"];
					  ?>
					  
					  <tr>
						<td><?php echo htmlspecialchars($nome); ?></td>
						<td><?php echo htmlspecialchars($tipo); ?></td>
						<td><input style="width: 15px; height: 15px; margin-left: 55px" type="checkbox" name="check[]" value="<?php echo htmlspecialchars($email); ?>"></td>
					  </tr>
					  
					  <?php
					  }
					  ?>
					</table>
				</div>
			
				<fieldset>
					<p class="form_open" id="user_open">Criar Utilizador</p>
					<input type="submit" value="Apagar Utilizador/es" name="delete">
				</fieldset>
			</form>
		</div>
	</div>
	
	<div id="user_create" class="form_pad">
		<div class="form_template">
			<form class="form" method="post">
				<div>
					<label for="nome">Nome:</label>
					<input type="text" id="nome" name="nome" autocomplete="off">
				</div>
				<div>
					<label for="email">Email:</label>
					<input type="email" id="email" name="email" autocomplete="off">
				</div>
				<div>
					<label for="pass">Password:</label>
					<input type="password" id="pass" name="pass" autocomplete="off">
				</div>
				<div>
					<label for="tipo">Tipo:</label>
					<select name="tipo" id="tipo">
					  <option value="Investigador">Investigador</option>
					  <option value="Técnico">Técnico</option>
					</select>
				</div>
				<div class="form_buttons">
					<input type="submit" value="Confirmar" name="create">
					<input id="user_close" type="reset" value="Cancelar">
				</div>
			</form>
		</div>
	</div>
	
	<div id="cultura_create" class="form_pad">
		<div class="form_template">
			<form class="form" method="post">
				<div style="display: flex; justify-content: center; gap: 40px; width: 100%">
					<div>
						<label for="nome">Nome:</label>
						<input type="text" id="nome" name="nome" autocomplete="off">
					</div>
					<div>
						<label for="zona">Zona:</label>
						<select name="zona" id="zona">
						  <option value="1">Zona 1</option>
						  <option value="2">Zona 2</option>
						</select>
					</div>
				</div>
				<div class="form_buttons">
					<input type="submit" value="Confirmar" name="create_cultura">
					<input id="cultura_close" type="reset" value="Cancelar">
				</div>
			</form>
		</div>
	</div>
	
	<div id="cultura_atribuir" class="form_pad">
		<div class="form_template">
			<form class="form" method="post">
				<div style="display: flex; justify-content: center; gap: 40px; width: 100%">
					<div>
						<label for="cultura">Cultura:</label>
						<input list="culturas_list" name="cultura" id="cultura" autocomplete="off">
					</div>
					<div>
						<label for="investigador">Investigador:</label>
						<input list="investigadores_list" name="investigador" id="investigador" autocomplete="off">
					</div>
				</div>
				<div class="form_buttons">
					<input type="submit" value="Confirmar" name="atribuir_cultura">
					<input id="atribuir_close" type="reset" value="Cancelar">
				</div>
			</form>
		</div>
	</div>
	
	<datalist id="culturas_list">
	<?php
							  
	$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
							  
	$stmt = $userconn->prepare("SELECT nomecultura FROM cultura WHERE idutilizador = 'NÃO_ATRIBUÍDA'");
	$stmt->execute();
	$result = $stmt->get_result();

	$userconn->close();
							  
	while($row = mysqli_fetch_array($result)){
		$nome = $row["nomecultura"];	
	?>
							  
		<option value="<?php echo htmlspecialchars($nome); ?>">
							  
	<?php
	}
	?>
	</datalist>
	
	<datalist id="investigadores_list">
	<?php
							  
	$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
							  
	$stmt = $userconn->prepare("SELECT nomeutilizador FROM utilizador WHERE tipoutilizador = 'I'");
	$stmt->execute();
	$result = $stmt->get_result();

	$userconn->close();
							  
	while($row = mysqli_fetch_array($result)){
		$nome = $row["nomeutilizador"];	
	?>
							  
		<option value="<?php echo htmlspecialchars($nome); ?>">
							  
	<?php
	}
	?>
	</datalist>
	
	<?php
	
	if(isset($_POST["create"]) && isset($_POST["nome"]) && isset($_POST["email"]) && isset($_POST["pass"]) && isset($_POST["tipo"])){
		
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			$stmt = $userconn->prepare("CALL CriarUtilizador(?,?,?,?)");
			$stmt->bind_param("ssss", $_POST["nome"], $_POST["email"], $_POST["pass"], $_POST["tipo"]);
			$stmt->execute();
					
			$userconn->close();
			
			unset($_POST["create"]);
			unset($_POST["nome"]);
			unset($_POST["email"]);
			unset($_POST["pass"]);
			unset($_POST["tipo"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
			
	if(isset($_POST["delete"]) && isset($_POST["check"])){
		
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			foreach($_POST["check"] as $check){	
				$stmt = $userconn->prepare("CALL ApagarUtilizador(?)");
				$stmt->bind_param("s", $check);
				$stmt->execute();
			}
					
			$userconn->close();
			
			unset($_POST["delete"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["create_cultura"]) && isset($_POST["nome"]) && isset($_POST["zona"])){
			
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			$stmt = $userconn->prepare("CALL CriarCultura(?,?)");
			$stmt->bind_param("si", $_POST["nome"], $_POST["zona"]);
			$stmt->execute();
					
			$userconn->close();
			
			unset($_POST["create"]);
			unset($_POST["nome"]);
			unset($_POST["zona"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["atribuir_cultura"]) && isset($_POST["cultura"]) && isset($_POST["investigador"])){
			
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
			
			$stmt = $userconn->prepare("SELECT emailutilizador FROM utilizador WHERE nomeutilizador = ?");
			$stmt->bind_param("s", $_POST["investigador"]);
			$stmt->execute();
			$result = $stmt->get_result();
			$row = mysqli_fetch_array($result);
			$email = $row["emailutilizador"];
					
			$stmt = $userconn->prepare("CALL AtribuirCultura(?,?)");
			$stmt->bind_param("ss", $_POST["cultura"], $email);
			$stmt->execute();
					
			$userconn->close();
			
			unset($_POST["atribuir_cultura"]);
			unset($_POST["cultura"]);
			unset($_POST["investigador"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["delete_cultura"]) && isset($_POST["check_cultura"])){
		
		try{
			$userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					
			foreach($_POST["check_cultura"] as $check){	
				$stmt = $userconn->prepare("CALL ApagarCultura(?)");
				$stmt->bind_param("s", $check);
				$stmt->execute();
			}
					
			$userconn->close();
			
			unset($_POST["delete_cultura"]);
			
			echo '<meta http-equiv="refresh" content="0"/>';
		}catch(Exception $e){
			$error = $e->getMessage();
		?>
			<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
		<?php
		}
	}
	
	if(isset($_POST["logout"])){
				
		session_unset();
		session_destroy();
		unset($_POST["logout"]);
		
		echo '<meta http-equiv="refresh" content="0;url=login.php">';
	}
	?>
</body>
</html>