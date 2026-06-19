-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 19, 2026 at 11:27 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `seeree_assessment1_bishwajitpattanaik`
--

-- --------------------------------------------------------

--
-- Table structure for table `order_master`
--

CREATE TABLE `order_master` (
  `OrderID` int(11) NOT NULL,
  `OrderDate` date NOT NULL,
  `ProdID` int(11) NOT NULL,
  `ProdRate` decimal(10,2) NOT NULL,
  `OrderQty` int(11) NOT NULL,
  `OrderValue` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_master`
--

INSERT INTO `order_master` (`OrderID`, `OrderDate`, `ProdID`, `ProdRate`, `OrderQty`, `OrderValue`) VALUES
(1, '2026-06-19', 1, 55000.00, 3, 165000.00),
(2, '2026-06-19', 2, 450.00, 100, 45000.00),
(3, '2026-06-19', 3, 800.00, 25, 20000.00);

-- --------------------------------------------------------

--
-- Table structure for table `product_master`
--

CREATE TABLE `product_master` (
  `ProdID` int(11) NOT NULL,
  `ProdName` varchar(100) NOT NULL,
  `ProdRate` decimal(10,2) NOT NULL,
  `ProdQty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_master`
--

INSERT INTO `product_master` (`ProdID`, `ProdName`, `ProdRate`, `ProdQty`) VALUES
(1, 'Laptop', 55000.00, 17),
(2, 'Mouse', 450.00, 0),
(3, 'Keyboard', 800.00, 55),
(4, 'Monitor', 9500.00, 30),
(5, 'Printer', 12000.00, 15);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `order_master`
--
ALTER TABLE `order_master`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `ProdID` (`ProdID`);

--
-- Indexes for table `product_master`
--
ALTER TABLE `product_master`
  ADD PRIMARY KEY (`ProdID`),
  ADD UNIQUE KEY `ProdName` (`ProdName`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `order_master`
--
ALTER TABLE `order_master`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `product_master`
--
ALTER TABLE `product_master`
  MODIFY `ProdID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_master`
--
ALTER TABLE `order_master`
  ADD CONSTRAINT `order_master_ibfk_1` FOREIGN KEY (`ProdID`) REFERENCES `product_master` (`ProdID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
