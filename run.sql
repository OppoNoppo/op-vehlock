CREATE TABLE IF NOT EXISTS `op-vehkeys` (
  `plate` varchar(50) NOT NULL,
  `initial_owner` varchar(255) NULL,
  `key_combo` varchar(50) NULL,
  KEY `initial_owner` (`initial_owner`),
  KEY 'key_combo' (`key_combo`),
  KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `op-vehlock` (
  `plate` varchar(50) NOT NULL,
  `state` enum('true','false') NOT NULL DEFAULT 'true',
  PRIMARY KEY (`plate`),
  KEY `state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
