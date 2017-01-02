-- phpMyAdmin SQL Dump
-- version 4.6.4deb1
-- https://www.phpmyadmin.net/
--
-- Client :  localhost:3306
-- Généré le :  Lun 02 Janvier 2017 à 20:26
-- Version du serveur :  5.6.30-1+b1
-- Version de PHP :  7.0.12-1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Base de données :  `plowshare_dev`
--

-- --------------------------------------------------------

--
-- Structure de la table `action`
--

CREATE TABLE `action` (
  `id` int(11) NOT NULL,
  `lifecycle_insert_date` datetime NOT NULL,
  `lifecycle_update_date` datetime NOT NULL,
  `order` int(11) NOT NULL DEFAULT '1',
  `download_id` int(11) DEFAULT NULL,
  `download_package_id` int(11) DEFAULT NULL,
  `action_status_id` int(11) NOT NULL,
  `action_type_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Déclencheurs `action`
--
DELIMITER $$
CREATE TRIGGER `action_lifecycle_insert_date_trg` BEFORE INSERT ON `action` FOR EACH ROW BEGIN
	DECLARE packageid integer;

    SET @packageid = NULL;

    IF (NEW.download_package_id) THEN
    	SET @packageId := NEW.download_package_id;
    ELSE
    	SET @packageId := (SELECT package_id FROM download WHERE id = NEW.download_id);
    END IF;

	IF (packageid IS NULL) THEN
		SELECT MAX('order') INTO @newseqno
		FROM action
		WHERE download_id = NEW.download_id;
	ELSE
		SELECT MAX('order') INTO @newseqno
		FROM action
		WHERE download_id = NEW.download_id or download_package_id = @packageid;
	END IF;

  SET NEW.order = COALESCE(@newseqno + 1, 1);
  SET NEW.lifecycle_insert_date = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `action_has_properties`
--

CREATE TABLE `action_has_properties` (
  `action_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `property_value` varchar(2048) NOT NULL,
  `directory_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `action_status`
--

CREATE TABLE `action_status` (
  `id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `translation_key` varchar(1024) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `action_status`
--

INSERT INTO `action_status` (`id`, `name`, `translation_key`) VALUES
(1, 'WAITING', 'action.status.WAITING'),
(2, 'IN_PROGRESS', 'action.status.IN_PROGRESS'),
(3, 'FINISHED', 'action.status.FINISHED'),
(4, 'ERROR', 'action.status.ERROR');

-- --------------------------------------------------------

--
-- Structure de la table `action_target`
--

CREATE TABLE `action_target` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `translation_key` varchar(1024) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `action_target`
--

INSERT INTO `action_target` (`id`, `name`, `translation_key`) VALUES
(1, 'DOWNLOAD', 'action.target.DOWNLOAD'),
(2, 'PACKAGE', 'action.target.PACKAGE');

-- --------------------------------------------------------

--
-- Structure de la table `action_type`
--

CREATE TABLE `action_type` (
  `id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `translation_key` varchar(1024) NOT NULL,
  `action_target_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `action_type`
--

INSERT INTO `action_type` (`id`, `name`, `translation_key`, `action_target_id`) VALUES
(1, 'MOVE_DOWNLOAD', 'action.type.MOVE_DOWNLOAD', 1),
(2, 'UNRAR_PACKAGE', 'action.type.UNRAR_PACKAGE', 2),
(3, 'DELETE_PACKAGE', 'action.type.DELETE_PACKAGE', 2),
(4, 'RENAME_DOWNLOAD\r\n', 'action.type.RENAME_DOWNLOAD', 1);

-- --------------------------------------------------------

--
-- Structure de la table `action_type_has_property`
--

CREATE TABLE `action_type_has_property` (
  `action_type_id` int(11) NOT NULL,
  `property_id` int(11) NOT NULL,
  `editable` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `action_type_has_property`
--

INSERT INTO `action_type_has_property` (`action_type_id`, `property_id`, `editable`) VALUES
(1, 1, 0),
(1, 2, 0),
(1, 3, 1),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(2, 1, 0),
(2, 3, 0),
(2, 4, 0),
(3, 2, 0),
(4, 2, 0),
(4, 7, 1);

-- --------------------------------------------------------

--
-- Structure de la table `application_configuration`
--

CREATE TABLE `application_configuration` (
  `id_application` int(11) NOT NULL,
  `download_activated` tinyint(1) NOT NULL,
  `api_log_database_level` tinyint(1) NOT NULL,
  `python_log_level` int(11) NOT NULL,
  `python_log_format` varchar(1024) NOT NULL,
  `python_log_directory_id` int(11) NOT NULL,
  `python_log_console_level` int(11) NOT NULL,
  `python_directory_download_temp_id` int(1) NOT NULL,
  `python_directory_download_id` int(11) NOT NULL,
  `python_directory_download_text_id` int(11) NOT NULL,
  `notification_address` varchar(1024) NOT NULL,
  `periodic_check_minutes` int(11) NOT NULL,
  `lifecycle_insert_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lifecycle_update_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `directory`
--

CREATE TABLE `directory` (
  `id` int(11) NOT NULL,
  `path` varchar(2048) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `directory`
--

INSERT INTO `directory` (`id`, `path`) VALUES
(1, '/mnt/HD/HD_a2/telechargement/temp_plowdown/'),
(2, '/mnt/HD/HD_a2/telechargement/'),
(3, '/var/www/plow_solution_dev/log/'),
(4, '/mnt/HD/HD_a2/telechargement/telechargements_texte/dev/'),
(17, '/mnt/HD/HD_a2/'),
(20, '/mnt/HD/HD_b2/Media/Videos/Films/_A REGARDER/');

-- --------------------------------------------------------

--
-- Structure de la table `download`
--

CREATE TABLE `download` (
  `id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `host_id` int(11) DEFAULT NULL,
  `package_id` int(11) DEFAULT NULL,
  `link` varchar(512) NOT NULL,
  `size_file` bigint(11) NOT NULL,
  `size_part` bigint(11) NOT NULL,
  `size_file_downloaded` bigint(11) NOT NULL,
  `size_part_downloaded` bigint(11) NOT NULL,
  `status` int(11) NOT NULL,
  `progress_part` int(3) NOT NULL,
  `average_speed` int(11) NOT NULL,
  `current_speed` int(11) NOT NULL,
  `time_spent` int(11) NOT NULL,
  `time_left` int(11) NOT NULL,
  `pid_plowdown` int(11) NOT NULL,
  `pid_curl` int(11) NOT NULL,
  `pid_python` int(11) NOT NULL,
  `file_path` varchar(2048) NOT NULL,
  `priority` smallint(1) NOT NULL DEFAULT '0',
  `theorical_start_datetime` datetime DEFAULT NULL,
  `lifecycle_insert_date` datetime NOT NULL,
  `lifecycle_update_date` datetime DEFAULT NULL,
  `directory_id` int(11) NOT NULL,
  `application_configuration_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `download_host`
--

CREATE TABLE `download_host` (
  `id` int(11) NOT NULL,
  `name` varchar(1024) NOT NULL,
  `simultaneous_downloads` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `download_host`
--

INSERT INTO `download_host` (`id`, `name`, `simultaneous_downloads`) VALUES
(1, '1fichier', 1),
(2, 'uptobox', 1),
(3, 'dl_free_fr', 2),
(4, 'mega', 1),
(5, 'uploaded_net', 1),
(6, 'zippyshare', 1),
(7, 'rapidgator', 3),
(8, 'keep2share', 2);

-- --------------------------------------------------------

--
-- Structure de la table `download_host_picture`
--

CREATE TABLE `download_host_picture` (
  `id` int(11) NOT NULL,
  `picture` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `download_host_picture`
--

INSERT INTO `download_host_picture` (`id`, `picture`) VALUES
(1, 0x89504e470d0a1a0a0000000d49484452000000200000001208060000003ac8dc52000003864944415478daa5556b48935118fe288a6e44d10f291032b0a2fb45caae5a5a514694dd89a2822e9a5074a31b4146a5564e2b139ba636142f6996a6d3615a6ab66965de9695ba9959a69bd3e936dde6d339a71699ee827be1e33be76cdf39cffbbccffb1c0e66a2b7b7b7cf5c6f30a2bdb31bdf5b3b51dbd8868acf2d7853d18417250dc828a84592a8069169e5b829909035396c0dced28f35722546af0801b7e026b8f941bfdf0bc9e3720b4316ddc6d0c5b731cc3518c397f03062290f239785b0c769d3038b87fe9b1c67296b1a418f24eca0a8a715a86f52e1a34c89aaba56bc953623afb401d96f64c82caa43dacbcf88134a11935e09b7c30910645643abd363aa7714267886c168ecbbb7a357043c7c92fa339059588bc92483593b633067772c28a6993ba231697db8cdb47e6a5062fab687d0751b18539cf3d57e00b839017026e0b881322f27f51db7ea2ea13f14d1cf2af09194829b1788f0c76503b2341083ab7d12d9bb55a5c1cf364dbfffb6903565870e5c97b607ef6b9a9141320f4f29c3e5882204c54aa068d732101ebe49ec83ad679f62e15e81d95299e25a5431f65c7a8ee0f8b74c94a6a0e5f18f2c66ec0c28424166151cd68563f3e934f4e80d7f518e59198ac2b246882b9b180bd662edb16426ccb82c296690d299a8f73a91cad6a95ecc76819164f689d0edb4890f5e7ce91f60d518bffa1e1bd30d03093b9682b6aa42a5652c8d75bf03e72d9170587b1f8f736bf0eda71ada6ebdf536a41f1ff417e27ab498cda76d8d420e517b7cf6efac2c95e0dff0f44dc694cd7c4c2402a61d63b30f980ea04a6e6a5133c3d97e2e9d8d291bff2bda5cf805e6da6744cd8a2eb81e886363973f021cb53c84b9a22d2c5cbc5f808eaeeec101a007f4e88d18eb76076d1d5a9ce2e5a3aab6053bcfa75bddd4143e0122a8070bc014d456a9258b243204c488c127ad55f4a1d126002efb04d0e8f4f60158496cb592644e59a02d4af5909023b57a3865cf542ebb0050bbac6b54b131d543dd3715bb17ac85b45e01f72389f689d040d0d35e566b7ad87c2eb91be4dfdbe14d5c910aec24d1c55152e7fd5784ccfd28436bfc92b1e250021c3746e00bb9b6070d808a90da34b563ea093466ef8a61fe5d5afd83b963ae440ee1eb7aa4e6919b30ab9add1bfefc626c389ec20cc99a6d5b65a093642e12cbf0eadd57d6fb476f887022380f6742f37121ac005789ef07c48a714b5082b0a4f7e03f2967e5a17e6fab59fd02d51100b55ebc58d90000000049454e44ae426082),
(2, 0x89504e470d0a1a0a0000000d49484452000000100000001008060000001ff3ff61000001fa4944415478daa591ef6b525118c7cfffa14c25c5994610b6746b6b6f06ab45b4810442c5ddbdeedebbe9060321081a7bb7f9a379695050901812c420fa07c477faa25ecc68fd706c76b11722820afe78f7eddc531cb7f29d073ef07deec3f99cfb9c434c261346818c2c18b35860b96087c56ec798cdc63032ab69cf466b87c3f11f56ab1566b319e44ae01eeebe3dc0d2c107dc78f418d39b519617dfbdc7e5c525ac472228168b28140a1ca3ce66b3f0f97c207e350ce1db09a4d35f5878f10af3da3ea4932ac4631d13e20ae23b3b18b63a9d0e2449029954d7207c29b30db79ebfc4fcde3388651dcbdf4fa92084d81941a95442a55261b9d7eb4151144310e682054390dae7826b12fd83dd5d2ec86432c8e7f35ca0aa2ac8d46a6420a023dc3c23f0856424620341bbdd46b7db65b956ab211008805c5ffb47a00d04fe904205312ea856ab68341a2c379b4d88a208321d5eff2328ffc49dd76f709b4a8ccc042b0a92f13817a4d369e4723996fbfd3ea2d128c84c6403c25119cb3f2a78f0e933ee7f3c649b0d26e5553c4d24b840d775d4ebf5f382297a510f0fbfb211387404e1e8187e41c45e3239f4195bad16645906b974750233f41ee6b6b631f7e42f34cf6e6cc2437bc160109aa621954a718cda38ddebf5825c74b9e01a1f87cbe93c0ffdc67a1427ad8761f488dbedc628108fc78351f80d769e6294a5bdaeea0000000049454e44ae426082),
(3, 0x89504e470d0a1a0a0000000d4948445200000040000000400806000000aa6971de000008934944415478daed5b0b7054e515a662913724bc1fc150dee038447120199450903084302a546ce8a45661aad8b115549cd2da71e828a28882d8b1808002ca88d05aacc858c7a105b5b5c9ae79ede69dec23d9ddecf3de7de5f5f59c3f7b6f76379b073ae334bbbb33df0c7bff73fe7bbeef3fffb9ff0d7b060d8af1b97af5ea60c2bd84d384af096d040c30b485623f1de23278507f3e64388ff0557979396c361b24494247470706da8763e6d8990373614eccad2ff23b083eb3d9ac4e120fe00f73626eccb127f2fbaaababe1f3f984537b7b7b5c81393137e6c85ca3c96fd6ebf5686d6d8d4bf2e1223047e6ca9c15f243084697cb15b7c4a3c15c897325736701f259111e686b6b4b0830d75016e4b300a72d164bc29057c09c993b0ba0936539e104e08248dc6b580057201010c52191d0d2d2c2020459808423af80b90b01588d44445200458060309890480aa008c04f8144445280a4002101fc7e7f424215808f858988a4008a005eaf372191144011805f87bf2dbc860604de7d1bad3bb7a3fdfef568cfcd46fbe63c04ce9ffd4ef37e1ff84e02781bcd08fee9203a5666a2237331dad7af42c7ddcbd1b1f456819693c7068e00fcf7f3eb81eff225b4adcf41fbad0bd0f6e41368adab458bc78396661b5acb4ad1aa29128f99eb9df7fbc6b712c0f7ee19b42d988fb6b973d0b6692302544d594d1e53b383f6d7ff3bf908013cb47afd817ce50a5a66cf434b5aba40f0d227fdf68d09b7bbf7718b05527d03a4ca2a487575e27b7fe7968c46483a1d248d06524d0d3c565b379beb13c066837ff94a04264e17086edc2c563ba66d7d3de423c7e0fbd983f0afdb00dfb64721e92b3ac79c4ec867de83afe021f8d7e6c1bbe7f90821a42fbe14d77c79f7c17f4b060233662330790602e973e0bf230bbe5f3e06a9b824865856c81f5e8477e72ef857ad4560e63c0426a575c69b3e17feccbbe07dea19781a0cdd05705300ddc00aeedb0fe98f7b21ed7901f2fd5be01d3b59852f270fd2d3bb21ed781ad2e33be1f9fc0adc2e17a4975e8177c6dc085b8674f95378fefd35e4d5eb22c7ee582eeee7f9e002e4b51bbae6bf6f33fcc74e20f8af6b08bc7934c247fef9d6ae38394b0ebd01f9f6accef1942924f87604fef22182d7be80fff7cf45c6f1e2cbaa6faf02784e9e827bea8fe09e360beec9e9708f9cd0858937c3336b913aee59743b3c07df803b331bee5113213f5040416e53eda53b57c3f3da61b82900feee59781b3cf317435ab916beb74ec29dff60976d760e025ffd47bcaca8b5e4e809b8474f526de403873ae3fcecf3ce7b2ad70bb62258ae170558a94bd253bf8d885dbef8717701f87f4aa22135362140691f74b9211d781db6a1a92ae4731710209b4073b340d0ed81ebd93d70defb00fcda6211007f17f6c3c6c13e3f43fcdb55b00dfe22adb0e779bdffbc8ae6454bd479dd8f3f2988737abacc66383ffe047622a58c374f9b4dd9b85790731c7f07b694699dd753a6423efc6771bc65622eaa1b8e3367d1bc3a57f5e518e413a784280a47550027edcb6828464e12a169f15298868c11b0e56c100146d8f0bea6a094001cff2d8439759aeac370ef7f4d1d677b47b90ee6990bd4f1c62933e1d8fb32ac3b76a169d53a98c74fef1c1b350156faeedaf70afc55d5e23e7612c634629ceadb74cb12d85f780996ad8fa29132c234768ab86e1e9f86e64d5be039721c7eab55900fe7d8ab000a2c47de42ed8da33af1c3d122ed7ab367987e5ad0e5437010790e3cdcc6fcd023ea78ddb0541897de05236d1573de46587ef5041c87dfa4baf10ff80d4635a585d80e070ccb5674f98e990413f91957ac8179533eac94f24eaa1df2b52f4576b2e8caaa47c7a90ae0a04963822a6b4dc632e86f182160a014172bdc933dc172e932f4a4bee2637ef8111140b88dbdb111556973549bda8c4cf51ddd1776ae50b385e7a5553752416ba2e256313c55f5356df985eac7354379322984d9b791ea19fbda1b1a22e2e85300f3a93328f9c13081d29bc6c0498fa8dec833aab2d7a83e150b332051958eb6b1537dd1dd3c57b5d3cd98032b55ec083bda7ab6c222185f3d848aac6c94dc305ccc6d79ff3cca468e537dabb256c256561e39bfc1000bd59786679f836ec162940e1d835aca4a7b45656c01ec767b775000bacc15d00c1a2a505bf0b05034a66d08064a3dc55e337804ec940d22a018b68dafbede654bd0de341a654bb2a05f938b72ba6f49fa3c75ac829eeb8e8b7f17abcc2b5bffd86f227cbf49998cf2a57742470295ddb60cc513a6775ea74ce1b83d1aadc88ee8587a15c074ee7cd70d46a4c251a4e9953c437f77aeea5347cf6a0eb6275b4e533ba573f53d3f4169da6c141309ed90d1f866e47894527654d37e6e3c70105269994a5cf195697b588f1e47d59af5289d3e0bc56327413b3c05c5a95351462b5e47dbce7ae21dc894f24aed8915832a4033158b68e87f9ca392a9dffe6ba15e2cbb70b82815ed17fe0afbdf3e8287f6799ff6444abc3bd81d90e9f4c8475e6f9305fe501d50ea4d2c5f1e13eff5e4eba594f7d2c1cd4fd7941aa208d6dbfd7b14c074f1236868cf31795e19273db2fa22c3e0609547635f370f47f4caf4d72fdaf77afc2204e09f9285439f7b8fbafa865dbb8571b44d3c20a600e64f3f83f6c691827c091d819d35b571493e42002b9d9214e8e90d4d597dd3f32f0ac3f0f178424c011a9ef91d4c7fa073fcd9737052418a57f21102f00f861428454c9cbec2aec72354019a9a9a1212490114011ae9d09288480a9014202400ff963e1191144011c0643225249202840470353434c048efd3890483c1c00248e2e7f2b5b5b50927007366eea26142a7d309451209cc596998c8d7683409270073565a66b869aab2aaaa2a61c83357ee16114d534adb5c515111eaebebc105319ec11c99abda3617d63bb85fabd58ae210afe4991b7364ae3d354cefe63e9ad2d2d2b8235f5656267a84421c07f7d93c5d5858289a8e2b2b2b45da0c4470ec5ced994ba8797a617f3bc8391b3611de0bb5a0638082637f3fc425e6aaff0ffda25a39539087900000000049454e44ae426082),
(4, 0x89504e470d0a1a0a0000000d49484452000000100000001008060000001ff3ff61000000df4944415478da63b825afc64009c6262802c46d407c09887f40f105206e82cae1352018883f00f17f1cf823540d56034012fff06886e17fc886c0348b424dff4f2406a9154336a0092609027fde3cf97f3fd806ae01c40689810092216dc8065c403600047e3db9f9ffbea7191883d8308064c02564037e201bf0f7f33b30fdfdce793046164332e0274e03be9cd8fefff5f45ab8adaf67d481c5d00cf88cd30b20c520f6cb8965600c626331e022ce408419808cb11880128862944623c50909864380f8131ecd9ff02565f4cc7419887f01f117203e07c4cdc464269231001c72f2dcda80e8360000000049454e44ae426082);

-- --------------------------------------------------------

--
-- Structure de la table `download_logs`
--

CREATE TABLE `download_logs` (
  `id` int(11) NOT NULL,
  `logs` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `download_package`
--

CREATE TABLE `download_package` (
  `id` int(11) NOT NULL,
  `name` varchar(512) NOT NULL,
  `unrar_progress` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `download_priority`
--

CREATE TABLE `download_priority` (
  `id` int(11) NOT NULL,
  `translation_key` varchar(1024) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `download_priority`
--

INSERT INTO `download_priority` (`id`, `translation_key`) VALUES
(1, 'download.priority.LOW'),
(2, 'download.priority.NORMAL'),
(3, 'download.priority.HIGH'),
(4, 'download.priority.MAX');

-- --------------------------------------------------------

--
-- Structure de la table `download_status`
--

CREATE TABLE `download_status` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `translation_key` varchar(1024) NOT NULL,
  `ord` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `download_status`
--

INSERT INTO `download_status` (`id`, `name`, `translation_key`, `ord`) VALUES
(1, 'WAITING', 'download.status.WAITING', 1),
(2, 'IN_PROGRESS', 'download.status.IN_PROGRESS', 2),
(3, 'FINISHED', 'download.status.FINISHED', 3),
(4, 'ERROR', 'download.status.ERROR', 4),
(5, 'PAUSED', 'download.status.PAUSED', 5),
(6, 'CANCELED', 'download.status.CANCELED', 6),
(7, 'UNDEFINED', 'download.status.UNDEFINED', 7),
(8, 'STARTING', 'download.status.STARTING', 8),
(9, 'MOVING', 'download.status.MOVING', 9),
(10, 'MOVED', 'download.status.MOVED', 10),
(11, 'ERROR_MOVING', 'download.status.ERROR_MOVING', 11),
(12, 'UNRARING', 'download.status.UNRARING', 12),
(13, 'UNRARED', 'download.status.UNRARED', 13),
(14, 'UNRAR_ERROR', 'download.status.UNRAR_ERROR', 14),
(15, 'FILE_DELETING', 'download.status.FILE_DELETING', 15),
(16, 'FILE_DELETED', 'download.status.FILE_DELETED', 16),
(17, 'FILE_DELETING_ERROR', 'download.status.FILE_DELETING_ERROR', 17),
(999, 'TREATMENT_IN_PROGRESS', 'download.status.TREATMENT_IN_PROGRESS', 999);

-- --------------------------------------------------------

--
-- Structure de la table `link`
--

CREATE TABLE `link` (
  `id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `link` varchar(512) NOT NULL,
  `size` int(11) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `link_status`
--

CREATE TABLE `link_status` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `translation_key` varchar(1024) NOT NULL,
  `ord` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `link_status`
--

INSERT INTO `link_status` (`id`, `name`, `translation_key`, `ord`) VALUES
(1, 'ON_LINE', 'link.status.ON_LINE', 1),
(2, 'DELETED', 'link.status.DELETED', 2);

-- --------------------------------------------------------

--
-- Structure de la table `property`
--

CREATE TABLE `property` (
  `id` int(11) NOT NULL,
  `name` varchar(1024) NOT NULL,
  `translation_key` varchar(1024) NOT NULL,
  `property_type_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `property`
--

INSERT INTO `property` (`id`, `name`, `translation_key`, `property_type_id`) VALUES
(1, 'PERCENTAGE', 'property.PERCENTAGE', 4),
(2, 'DIRECTORY_SRC', 'property.DIRECTORY_SRC', 1),
(3, 'DIRECTORY_DST', 'property.DIRECTORY_DST', 1),
(4, 'TIME_LEFT', 'property.TIME_LEFT', 5),
(5, 'TIME_ELAPSED', 'property.TIME_ELAPSED', 5),
(6, 'TIME_TOTAL', 'property.TIME_TOTAL', 5),
(7, 'NEW_NAME\r\n', 'property.NEW_NAME', 1);

-- --------------------------------------------------------

--
-- Structure de la table `property_type`
--

CREATE TABLE `property_type` (
  `id` int(11) NOT NULL,
  `name` varchar(512) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `property_type`
--

INSERT INTO `property_type` (`id`, `name`) VALUES
(1, 'directory'),
(2, 'string'),
(3, 'integer'),
(4, 'float'),
(5, 'time');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `action`
--
ALTER TABLE `action`
  ADD PRIMARY KEY (`id`),
  ADD KEY `download_id` (`download_id`),
  ADD KEY `action_status_id` (`action_status_id`),
  ADD KEY `action_type_id` (`action_type_id`),
  ADD KEY `download_package_id` (`download_package_id`);

--
-- Index pour la table `action_has_properties`
--
ALTER TABLE `action_has_properties`
  ADD PRIMARY KEY (`action_id`,`property_id`),
  ADD KEY `directory_id` (`directory_id`),
  ADD KEY `directory_id_2` (`directory_id`),
  ADD KEY `action_has_properties_property_fk` (`property_id`);

--
-- Index pour la table `action_status`
--
ALTER TABLE `action_status`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `action_target`
--
ALTER TABLE `action_target`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `action_type`
--
ALTER TABLE `action_type`
  ADD PRIMARY KEY (`id`),
  ADD KEY `action_target_id` (`action_target_id`);

--
-- Index pour la table `action_type_has_property`
--
ALTER TABLE `action_type_has_property`
  ADD PRIMARY KEY (`action_type_id`,`property_id`),
  ADD KEY `athp_property_fk` (`property_id`);

--
-- Index pour la table `application_configuration`
--
ALTER TABLE `application_configuration`
  ADD PRIMARY KEY (`id_application`),
  ADD KEY `python_directory_download_text_id` (`python_directory_download_text_id`),
  ADD KEY `python_directory_download_text_2` (`python_directory_download_text_id`);

--
-- Index pour la table `directory`
--
ALTER TABLE `directory`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `download`
--
ALTER TABLE `download`
  ADD PRIMARY KEY (`id`),
  ADD KEY `download_package_constraint` (`package_id`),
  ADD KEY `status` (`status`),
  ADD KEY `host_id` (`host_id`),
  ADD KEY `application_configuration_id` (`application_configuration_id`),
  ADD KEY `directory_id` (`directory_id`),
  ADD KEY `priority` (`priority`);

--
-- Index pour la table `download_host`
--
ALTER TABLE `download_host`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `download_host_picture`
--
ALTER TABLE `download_host_picture`
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
-- Index pour la table `download_priority`
--
ALTER TABLE `download_priority`
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
-- Index pour la table `property`
--
ALTER TABLE `property`
  ADD PRIMARY KEY (`id`),
  ADD KEY `property_type_id` (`property_type_id`);

--
-- Index pour la table `property_type`
--
ALTER TABLE `property_type`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `action`
--
ALTER TABLE `action`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;
--
-- AUTO_INCREMENT pour la table `directory`
--
ALTER TABLE `directory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT pour la table `download`
--
ALTER TABLE `download`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1822;
--
-- AUTO_INCREMENT pour la table `download_host`
--
ALTER TABLE `download_host`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT pour la table `download_package`
--
ALTER TABLE `download_package`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=180;
--
-- AUTO_INCREMENT pour la table `download_status`
--
ALTER TABLE `download_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1000;
--
-- AUTO_INCREMENT pour la table `link`
--
ALTER TABLE `link`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `link_status`
--
ALTER TABLE `link_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `download`
--
ALTER TABLE `download`
  ADD CONSTRAINT `download_application_configuration_fk` FOREIGN KEY (`application_configuration_id`) REFERENCES `application_configuration` (`id_application`),
  ADD CONSTRAINT `download_directory_fk` FOREIGN KEY (`directory_id`) REFERENCES `directory` (`id`);
