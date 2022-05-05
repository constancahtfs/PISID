<?php
	session_start();
	
	$ip = "localhost";
	$user = "";
	$pass = "";
	$db = "estufa";
?>

<!DOCTYPE html>
<html>
<head>
<style>
@font-face {
	font-family: kanit;
	src: url(Kanit-Regular.ttf);
}

#title{
	text-align: center;
	font-size: 3em;
	margin-bottom: 50px;
	padding: 0;
}

body {
	font-family: kanit;

	background-image: linear-gradient(to top, rgba(132,188,116,1) 0%, rgba(255,255,255,1) 50%);
	background-attachment: fixed;
	
	padding-top: 150px;
}

label {
	padding: 0;
	margin: 0;
}

input{
	background-color: rgb(205,205,205);
	border: none;
	
	width: 100%;
	height: 20px;
	margin: 0;
}

#login{
	background-color: rgb(100,153,86);
	border: none;
	color: white;
	cursor: pointer;
	font-size: 1.2em;
	border-radius: 10px;
	
	width: 100px;
	height: 40px;
	padding: 0;
	margin-top: 50px;
	margin-left: 87.5px;
}
</style>
</head>
<body>

	<h1 id="title">Monitorização de Culturas</h1>
	
	<form style="padding: 0; margin: auto; width: 275px" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
		<label for="user">Email</label><br>
		<input style="margin-bottom: 25px" type="email" id="user" name="user" autocomplete="off"><br>
		<label for="pass">Password</label><br>
		<input type="password" id="pass" name="pass"><br>
		<input id="login" type="submit" value="Login" autocomplete="off">
	</form>
	
	<?php
	
	if($_SERVER["REQUEST_METHOD"] == "POST"){
		
		if(!empty($_POST["user"]) && !empty($_POST["pass"])){
			
			$user = $_POST["user"];
			$pass = $_POST["pass"];
			
			try{
				$userconn = new mysqli($ip, $user, $pass, $db);
				$queryconn = new mysqli($ip, "software@java.pt", "software1234", $db);
				
				$stmt = $queryconn->prepare("SELECT tipoutilizador FROM utilizador WHERE emailutilizador=?");
				$stmt->bind_param("s", $user);
				$stmt->execute();
				$result = $stmt->get_result();
				
				$queryconn->close();
				
				if($result->num_rows > 0){
					
					$row = $result->fetch_assoc();
					$tipo = $row["tipoutilizador"];
					
					if($tipo == 'I'){
						$_SESSION["user"] = $user;
						$_SESSION["pass"] = $pass;
						$userconn->close();
						$_SESSION["authenticated"] = true;
						header("Location: investigador.php");
						exit();
					}elseif($tipo == 'A'){
						$_SESSION["user"] = $user;
						$_SESSION["pass"] = $pass;
						$userconn->close();
						$_SESSION["authenticated"] = true;
						header("Location: admin.php");
						exit();
					}
				}
			}catch(Exception $e){
				$error = $e->getMessage();
			?>
				<script type='text/javascript'>alert("<?php echo $error; ?>");</script>
			<?php
			}
		}
	}
	?>

</body>
</html>