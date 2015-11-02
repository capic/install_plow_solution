-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u1
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Lun 02 Novembre 2015 à 13:10
-- Version du serveur :  5.5.44-0+deb8u1
-- Version de PHP :  5.6.14-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Base de données :  `plowshare`
--

-- --------------------------------------------------------

--
-- Structure de la table `download`
--

CREATE TABLE IF NOT EXISTS `download` (
`id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `package_id` int(11) DEFAULT NULL,
  `link` varchar(512) NOT NULL,
  `size_file` int(11) NOT NULL,
  `size_part` int(11) NOT NULL,
  `size_file_downloaded` int(11) NOT NULL,
  `size_part_downloaded` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `progress_part` int(3) NOT NULL,
  `average_speed` int(11) NOT NULL,
  `current_speed` int(11) NOT NULL,
  `time_spent` int(11) NOT NULL,
  `time_left` int(11) NOT NULL,
  `pid_plowdown` int(11) NOT NULL,
  `pid_curl` int(11) NOT NULL,
  `pid_python` int(11) NOT NULL,
  `directory` varchar(2048) NOT NULL,
  `directory_id` int(11) NOT NULL,
  `file_path` varchar(2048) NOT NULL,
  `priority` smallint(1) NOT NULL DEFAULT '0',
  `theorical_start_datetime` datetime DEFAULT NULL,
  `lifecycle_insert_date` datetime NOT NULL,
  `lifecycle_update_date` datetime DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `download_directory`
--

CREATE TABLE IF NOT EXISTS `download_directory` (
`id` int(11) NOT NULL,
  `path` varchar(2048) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `download_logs`
--

CREATE TABLE IF NOT EXISTS `download_logs` (
  `id` int(11) NOT NULL,
  `logs` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `download_package`
--

CREATE TABLE IF NOT EXISTS `download_package` (
`id` int(11) NOT NULL,
  `name` varchar(512) NOT NULL,
  `unrar_progress` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `download_status`
--

CREATE TABLE IF NOT EXISTS `download_status` (
`id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `ord` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `download_status`
--

INSERT INTO `download_status` (`id`, `name`, `ord`) VALUES
(1, 'waiting', 1),
(2, 'in progress', 2),
(3, 'finished', 3),
(4, 'error', 4),
(5, 'pause', 5),
(6, 'cancel', 6),
(7, 'undefined', 7),
(8, 'starting', 8),
(9, 'moving', 9),
(10, 'moved', 10),
(11, 'error moving', 11);

-- --------------------------------------------------------

--
-- Structure de la table `link`
--

CREATE TABLE IF NOT EXISTS `link` (
`id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `link` varchar(512) NOT NULL,
  `size` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `link_status`
--

CREATE TABLE IF NOT EXISTS `link_status` (
`id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `ord` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `link_status`
--

INSERT INTO `link_status` (`id`, `name`, `ord`) VALUES
(1, 'on line', 1),
(2, 'deleted', 2);

--
-- Index pour les tables exportées
--

--
-- Index pour la table `download`
--
ALTER TABLE `download`
 ADD PRIMARY KEY (`id`), ADD KEY `download_package_constraint` (`package_id`);

--
-- Index pour la table `download_directory`
--
ALTER TABLE `download_directory`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `download_logs`
--
ALTER TABLE `download_logs`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `download_package`
--
ALTER TABLE `download_package`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `download_status`
--
ALTER TABLE `download_status`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `link`
--
ALTER TABLE `link`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `link_status`
--
ALTER TABLE `link_status`
 ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `download`
--
ALTER TABLE `download`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=189;
--
-- AUTO_INCREMENT pour la table `download_directory`
--
ALTER TABLE `download_directory`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `download_package`
--
ALTER TABLE `download_package`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT pour la table `download_status`
--
ALTER TABLE `download_status`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT pour la table `link`
--
ALTER TABLE `link`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `link_status`
--
ALTER TABLE `link_status`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `download`
--
ALTER TABLE `download`
ADD CONSTRAINT `download_package_constraint` FOREIGN KEY (`package_id`) REFERENCES `download_package` (`id`) ON DELETE CASCADE;
