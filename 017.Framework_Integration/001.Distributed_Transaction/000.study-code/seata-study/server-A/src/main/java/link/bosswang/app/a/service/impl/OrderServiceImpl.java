package link.bosswang.app.a.service.impl;

import io.seata.spring.annotation.GlobalTransactional;
import link.bosswang.app.a.api.StockService;
import link.bosswang.app.a.service.OrderService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;


@Service
public class OrderServiceImpl implements OrderService {
    @Resource
    private JdbcTemplate jdbcTemplate;

    @Resource
    private StockService stockService;


    /**
     * create table `seata_stu_order`(`id` bigint not null primary key auto_increment, `order_id` varchar(100) , `buyer_name` varchar(100));
     */
    @GlobalTransactional
    @Transactional
    @Override
    public Map<String, Object> createOrder() {
        String tradeId = UUID.randomUUID().toString().replace("-", "");
        // 创建订单
        jdbcTemplate.execute("INSERT INTO seata_stu_order(order_id,buyer_name) VALUES ('" + tradeId + " ','Wei.Wang')");

        // 减库存
        stockService.reduce("item_id_999");

        int byZero = 1 / 0;

        // 返回处理结果
        return new HashMap<>();

    }
}
