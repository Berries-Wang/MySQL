package link.bosswang.app.b.service.impl;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

@Service
public class StockServiceImpl implements StockService {
    @Resource
    private JdbcTemplate jdbcTemplate;


    @Transactional
    @Override
    public String reduce(String itemId) {
        System.out.println("正在扣减奖品" + itemId + "的库存");
        jdbcTemplate.execute("update item_info set stock = stock-1 where item_id='" + itemId + "';");
        System.out.println("奖品" + itemId + "的库存扣减完成");
        return "OK";
    }
}
