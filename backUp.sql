-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         11.4.2-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para financialtracker
CREATE DATABASE IF NOT EXISTS `financialtracker` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `financialtracker`;

-- Volcando estructura para tabla financialtracker.employee
CREATE TABLE IF NOT EXISTS `employee` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(250) DEFAULT NULL,
  `DNI` int(11) DEFAULT NULL,
  `BirthDate` date DEFAULT NULL,
  `JoinDate` date DEFAULT NULL,
  `Status` tinyint(1) DEFAULT NULL,
  `Phone` int(11) DEFAULT NULL,
  `Sex` varchar(20) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT NULL,
  `ModifiedAt` datetime DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=565 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla financialtracker.employee: ~0 rows (aproximadamente)


-- Volcando estructura para tabla financialtracker.loan
CREATE TABLE IF NOT EXISTS `loan` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `SoliNum` char(5) DEFAULT NULL,
  `UserID` int(11) DEFAULT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `GuarantorID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `Refinancied` decimal(10,2) DEFAULT NULL,
  `Dues` int(11) DEFAULT NULL,
  `PaymentDate` date DEFAULT NULL,
  `State` enum('Pendiente','Aceptado','Denegado') DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT NULL,
  `ModifiedAt` datetime DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SoliNum` (`SoliNum`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla financialtracker.loan: ~0 rows (aproximadamente)

-- Volcando estructura para tabla financialtracker.loandetail
CREATE TABLE IF NOT EXISTS `loandetail` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `LoanID` int(11) DEFAULT NULL,
  `RequestNumber` char(5) DEFAULT NULL,
  `Refinanced` decimal(10,2) DEFAULT NULL,
  `LoanAmount` decimal(10,2) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `Dues` int(11) DEFAULT NULL,
  `TotalInterest` decimal(10,2) DEFAULT NULL,
  `TotalIntangibleFund` decimal(10,2) DEFAULT NULL,
  `MonthlyCapitalInstallment` decimal(10,2) DEFAULT NULL,
  `MonthlyInterestFee` decimal(10,2) DEFAULT NULL,
  `MonthlyIntangibleFundFee` decimal(10,2) DEFAULT NULL,
  `MonthlyFeeValue` decimal(10,2) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  `ModifiedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla financialtracker.loandetail: ~0 rows (aproximadamente)

-- Volcando estructura para tabla financialtracker.payment
CREATE TABLE IF NOT EXISTS `payment` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EmployeeID` int(11) DEFAULT NULL,
  `CreatedByID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `Reason` varchar(50) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT NULL,
  `ModifiedAt` datetime DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla financialtracker.payment: ~0 rows (aproximadamente)

-- Volcando estructura para tabla financialtracker.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(100) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT NULL,
  `ModifiedAt` datetime DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla financialtracker.roles: ~0 rows (aproximadamente)

-- Volcando estructura para tabla financialtracker.users
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Role` enum('admin','user') DEFAULT NULL,
  `Name` varchar(250) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Password` varchar(100) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` datetime DEFAULT NULL,
  `ModifiedAt` datetime DEFAULT NULL,
  `ModifiedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla financialtracker.users: ~1 rows (aproximadamente)
INSERT INTO `users` (`ID`, `Role`, `Name`, `Email`, `Password`, `CreatedBy`, `CreatedAt`, `ModifiedAt`, `ModifiedBy`) VALUES
	(2, 'admin', NULL, 'sistemas@gmail.com', '$2a$10$9/qEDSW4n2dIai7D/31cQOxl.Sf1ZlrBKaCTjPiBZt2tt7YfGwpG2', NULL, NULL, NULL, NULL);

-- Definir el delimitador para el trigger
DELIMITER //

-- Crear el trigger BEFORE INSERT para la tabla loan
CREATE TRIGGER format_numeration
BEFORE INSERT ON loan
FOR EACH ROW
BEGIN
    -- Formatear el campo SoliNum con ceros a la izquierda
    -- Se usa el valor de ID después de que ha sido generado
    SET NEW.SoliNum = LPAD((SELECT COALESCE(MAX(ID), 0) + 1 FROM loan), 5, '0');
END;
//

-- Restablecer el delimitador
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
