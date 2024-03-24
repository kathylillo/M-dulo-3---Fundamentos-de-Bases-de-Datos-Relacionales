CREATE SCHEMA alke_wallet;
USE alke_wallet;

-- Crear tabla Usuario
CREATE TABLE Usuario (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL,
    clave VARCHAR(50) NULL,
    saldo DECIMAL(10, 2) NOT NULL
);

 -- Crear nuevo campo llamado apellido no nulo  en la tabla usuario
ALTER TABLE usuario ADD COLUMN  apellido varchar (20) not null;

-- Insertar algunos datos nuevos 
INSERT INTO  usuario (nombre, apellido,correo_electronico,saldo)
  VALUES ('Roxana ','San Juan','correo1@correo.cl',180),
         ('Juana','Duran','correo2@correo.cl',150),
         ('Alvaro', 'Herrera','correo3@correo.cl',120);

-- vista Usuario 
 SELECT * FROM usuario; 
 SELECT nombre,apellido FROM usuario;
 
 -- Consulta de  un usuario con su  Id ,  nombre y apellido. 
SELECT  user_id, nombre ,apellido
FROM usuario 
WHERE user_id =2; 

    -- Actualizar la columna clave con el nuevo valor predeterminado concatenado
UPDATE usuario
SET clave = CONCAT('clave-nueva', user_id)
WHERE clave IS NULL ;
      -- Vista 
    SELECT * FROM usuario ;
    
-- Modificar la definición de la columna clave para hacerla NOT NULL
ALTER TABLE usuario MODIFY clave varchar(20) NOT NULL;
   
-- Insertar usuarios 
INSERT INTO  usuario (nombre,apellido,correo_electronico,saldo,clave)
  VALUES ('Roberto',' Salinas ','rob@correo.cl',150,'9874'),
		 ('Julia','Morales','juli@mail.com', 12,'ABC123'),
         ('Pablo',' Perez ','pablo@correo.com',8,'1963K'),
		 ('Sofia',' Avalos ','sofi@correo.com',15,'198900'),
		 ('Monica',' Arce ','arce@correo.com',30,'jsncjsnv'),
		 ('Jack',' Black ','jack@correo.com',800,'jack95'),
		 ('Ricky',' Martin ','ricky@correo.com',7060,'dfv789');
        
     -- vista  
 SELECT *  FROM usuario ; 
 
-- Crear tabla Moneda
CREATE TABLE Moneda (
    currency_id INT PRIMARY KEY AUTO_INCREMENT,
    currency_name VARCHAR(100) NOT NULL ,
    currency_symbol VARCHAR(4),
    UNIQUE (currency_name)
);

 -- insertar monedas 
INSERT INTO  moneda (currency_name,currency_symbol)
VALUES ('Peso Chileno', 'CLP$'),('Dolar Estadounidense','US$'),
	   ('Euro','€'),(' yuan Renminbi','¥'),
       ('Libra esterlina','£'),('Rupia India','₹');

 -- Vista de moneda 
SELECT * FROM moneda;

-- Crear tabla Transaccion
CREATE TABLE Transaccion  (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_user_id INT NOT NULL,
    receiver_user_id INT NOT NULL,
    importe DECIMAL(10, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    FOREIGN KEY (sender_user_id) REFERENCES Usuario(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_user_id) REFERENCES Usuario(user_id) ON DELETE CASCADE 
);

-- Alterar tabla transaccion agregando union con columna currency_id como fk .
 ALTER TABLE Transaccion
ADD COLUMN currency_id INT,
ADD FOREIGN KEY (currency_id )  REFERENCES Moneda(currency_id) ON DELETE CASCADE;


  -- Agregar transacciones con nuvo campo de moneda
INSERT INTO  Transaccion (sender_user_id,receiver_user_id,importe,transaction_date,currency_id)  
    VALUES (1,3,25, now(),1),(3,4,15,now(),1),
		   (2,1,20, now(),2),(1,4,63, now(),2),
           (4,10,15, now(),3),(10,3,25, now(),3),
		   (6,2,178, now(),4),(5,3,29, now(),4),
		   (9,6,95, now(),5),(8,10,175, now(),5),
           (7,8,100, now(),6),(6,7,63, now(),6);
           
 -- Vista Usuario
 SELECT * FROM usuario ;
 
-- Consulta para obtener todas las transacciones registradas
SELECT * FROM Transaccion;

-- Consulta para obtener el nombre de la moneda elegida por un usuario específico (Se elige solo durante el envio de dinero).
SELECT Moneda.currency_name
FROM Moneda
INNER JOIN Transaccion ON Transaccion.currency_id = Moneda.currency_id
WHERE Transaccion.sender_user_id = 7;

-- Consulta para obtener el nombre de la moneda elegida por un usuario específico como emisor y receptor.
SELECT Moneda.currency_name
FROM Moneda
INNER JOIN Transaccion ON Transaccion.currency_id = Moneda.currency_id
WHERE Transaccion.sender_user_id = 3 OR Transaccion.receiver_user_id = 3;


-- Consulta para obtener todas las transacciones realizadas por un usuario específico
SELECT * FROM Transaccion
WHERE sender_user_id = 3 OR receiver_user_id = 3;

-- vista de id usuario , nombre, transacciones y moneda seleccionada 
CREATE VIEW Vista_Transacciones AS
SELECT U.user_id AS id_usuario,
       U.nombre,
       T.transaction_id AS id_transaccion,
       T.importe,
       M.currency_name AS moneda
FROM Usuario U
INNER JOIN Transaccion T ON U.user_id = T.sender_user_id OR U.user_id = T.receiver_user_id
INNER JOIN Moneda M ON T.currency_id = M.currency_id;

-- vista
SELECT * FROM Vista_Transacciones;


-- Sentencia DML para modificar el campo correo electrónico de un usuario específico
UPDATE Usuario
SET correo_electronico = 'nuevocorreo@mail.com'
WHERE user_id = 3;

-- Vista 
SELECT * FROM usuario; 

-- Sentencia para eliminar los datos de una transacción (eliminado de la fila completa)
DELETE FROM Transaccion WHERE transaction_id = 1;

-- Vista 
SELECT * FROM transaccion;

 -- Inicio de transaccion sumar o restar saldo a usuarios 
SET autocommit=OFF; 
START TRANSACTION ;

-- Modificar cuentas restando y/ o  sumando saldo por su ID
UPDATE usuario SET Saldo=Saldo+100 WHERE user_id = 1;
UPDATE usuario SET Saldo=Saldo-20 WHERE user_id = 2;

-- Vista
 select * from usuario;

/*
no guardar cambios (similar a Ctrl Z)
 ROLLBACK; 
*/
/*
guardar cambios 
COMMIT; 
*/
-- fin de transaccion 
SET autocommit=ON; 
