/*server-a*/
CREATE TABLE `seata_stu_order` (
                                   `id` bigint NOT NULL AUTO_INCREMENT,
                                   `order_id` varchar(100) DEFAULT NULL,
                                   `buyer_name` varchar(100) DEFAULT NULL,
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*server-b*/
CREATE TABLE `item_info` (
                             `id` bigint NOT NULL AUTO_INCREMENT,
                             `item_id` varchar(50) NOT NULL,
                             `item_name` varchar(50) NOT NULL,
                             `stock` int NOT NULL,
                             PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;