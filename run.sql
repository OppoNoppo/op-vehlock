CREATE TABLE IF NOT EXISTS `op-vehkeys` (
  `plate` varchar(50) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  KEY `identifier` (`identifier`),
  KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `op-vehlock` (
  `plate` varchar(50) NOT NULL,
  `state` enum('true','false') NOT NULL DEFAULT 'true',
  PRIMARY KEY (`plate`),
  KEY `state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
