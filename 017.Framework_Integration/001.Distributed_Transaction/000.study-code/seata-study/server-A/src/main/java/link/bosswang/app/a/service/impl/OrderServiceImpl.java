package link.bosswang.app.a.service.impl;

import com.alibaba.fastjson.JSONObject;
import io.seata.spring.annotation.GlobalTransactional;
import link.bosswang.app.a.api.StockService;
import link.bosswang.app.a.service.OrderService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.*;


@Service
public class OrderServiceImpl implements OrderService {
    @Resource
    private JdbcTemplate jdbcTemplate;

    @Resource
    private StockService stockService;

    @GlobalTransactional(timeoutMills = 600000000)
    @Transactional
    @Override
    public Map<String, Object> createOrder() {
        String tradeId = UUID.randomUUID().toString().replace("-", "");
        //printfUndoLog();
        String execSQL = "INSERT INTO seata_stu_order(order_id,buyer_name) VALUES ('" + tradeId + "','Wei.Wang:" + Math.random() + "');";
        System.out.println(execSQL);

        // 创建订单
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection conn) throws SQLException {

                return conn.prepareStatement(execSQL);
            }
        }, keyHolder);

        printfOrderInfo();
        long start = System.currentTimeMillis();
        // 减库存
        String reduceRes = stockService.reduce("item_id_999");
        System.out.println("---> " + reduceRes + " , 耗时:" + (System.currentTimeMillis() - start));
        //printfUndoLog();

        // int byZero = 1 / 0;
        HashMap<String, Object> rsp = new HashMap<>();
        rsp.put("success:" + keyHolder.getKey(), true);
        // 返回处理结果
        return rsp;

    }

    private void printfOrderInfo() {
        System.out.println("---> 正在打印undo_log");
        List<Map<String, Object>> undoLogs = jdbcTemplate.queryForList("select  * from seata_stu_order");
        Optional.ofNullable(undoLogs).orElse(new LinkedList<>()).forEach(eleLog -> {
            System.out.println(JSONObject.toJSONString(eleLog));
        });
    }
}
