package link.bosswang.app.a.service.impl;

import com.alibaba.fastjson.JSONObject;
import io.seata.spring.annotation.GlobalTransactional;
import link.bosswang.app.a.api.StockService;
import link.bosswang.app.a.dao.OrderRepository;
import link.bosswang.app.a.dao.endity.StuOrder;
import link.bosswang.app.a.service.OrderService;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

import javax.annotation.Resource;
import java.util.*;


@Service
public class OrderServiceImpl implements OrderService {
    @Resource
    private JdbcTemplate jdbcTemplate;

    @Resource
    private StockService stockService;

    @Resource
    private OrderRepository orderRepository;

    @Resource
    private TransactionTemplate transactionTemplate;

    @GlobalTransactional
    @Transactional
    @Override
    public Map<String, Object> createOrder() {

        StuOrder stuOrder = new StuOrder(UUID.randomUUID().toString(), "Wei.Wang:" + Math.random());
        int saveRes = orderRepository.saveStuOrder(stuOrder);
        System.out.println("jpa: " + saveRes);

        long start = System.currentTimeMillis();
        // 减库存
        String reduceRes = stockService.reduce("item_id_999");
        System.out.println("---> " + reduceRes + " , 耗时:" + (System.currentTimeMillis() - start));
      //  printfOrderInfo();

        // int byZero = 1 / 0;
        HashMap<String, Object> rsp = new HashMap<>();
        rsp.put("success:", true);
        // 返回处理结果
        return rsp;

    }

    private void printfOrderInfo() {
        System.out.println("---> 正在打印undo_log");
        List<Map<String, Object>> orderInfos = jdbcTemplate.queryForList("SELECT  * FROM seata_stu_order");
        Optional.ofNullable(orderInfos).orElse(new LinkedList<>()).forEach(eleLog -> {
            System.out.println(JSONObject.toJSONString(eleLog));
        });
    }
}
