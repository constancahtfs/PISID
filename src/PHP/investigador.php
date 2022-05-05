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

#culturas{
	height: 671px;
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

input[type=submit], button{
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

a{
	display: flex;
	align-items: center;
	padding: 5px;
	margin: 0;
	height: 40px;
}

a:link, a:visited{
	text-decoration: none;
	color: white;
}

#c{
	display: flex;
	align-items: center;
	padding: 5px;
	margin: 0;
	height: 40px;
	background-color: rgb(86,131,73);
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

</style>
</head>
<body>

	<div style="position: absolute; width: 100%; z-index: -1">
		<header>
			<p id="c">Culturas</p>
			
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
						<th>Zona</th>
						<th>Estado</th>
						<th></th>
					  </tr>
					  
					  <?php
					  
					  $queryconn = new mysqli($ip, "software@java.pt", "software1234", $db);
					  $userconn = new mysqli($ip, $_SESSION["user"], $_SESSION["pass"], $db);
					  
					  $stmt = $queryconn->prepare("SELECT idutilizador FROM utilizador WHERE emailutilizador=?");
					  $stmt->bind_param("s", $_SESSION["user"]);
					  $stmt->execute();
					  $result_id = $stmt->get_result();
					  if($result_id->num_rows > 0){
						  $row_id = $result_id->fetch_assoc();
						  $id = $row_id["idutilizador"];
					  }
					  
					  $queryconn->close();
					  
					  $stmt = $userconn->prepare("SELECT nomecultura, idzona, estado FROM cultura WHERE idutilizador=?");
					  $stmt->bind_param("s", $id);
					  $stmt->execute();
					  $result = $stmt->get_result();

					  $userconn->close();
					  
					  $i = 0;
					  while($row = mysqli_fetch_array($result)){
						  $nome = $row["nomecultura"];
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
						<td><?php echo htmlspecialchars($zona); ?></td>
						<td><?php echo htmlspecialchars($estado); ?></td>
						<td><input type="hidden" name="cultura[]" value="<?php echo htmlspecialchars($nome); ?>"> <input type="hidden" name="estado[]" value="<?php echo htmlspecialchars($estado); ?>"> <button style="width: 100px; height: 40px; margin-right: -120px" type="submit" name="int" value="<?php echo htmlspecialchars($i); ?>">Editar</button></td>
					  </tr>
					  
					  <?php
					  $i++;
					  }
					  ?>
					</table>
				</div>
			</form>
		</div>
	</div>
	
	<?php
	
	if(isset($_POST["int"])){
		
		$_SESSION["cultura"] = $_POST["cultura"][$_POST["int"]];
		$_SESSION["estado"] = $_POST["estado"][$_POST["int"]];
		
		header("Location: parametros.php");
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