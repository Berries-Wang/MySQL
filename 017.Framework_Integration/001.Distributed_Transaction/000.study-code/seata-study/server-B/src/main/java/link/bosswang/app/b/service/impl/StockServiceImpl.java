package link.bosswang.app.b.service.impl;

import com.alibaba.fastjson.JSONObject;
import io.seata.spring.annotation.GlobalTransactional;
import link.bosswang.app.b.dao.ItemRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class StockServiceImpl implements StockService {
    @Resource
    private JdbcTemplate jdbcTemplate;

    @Resource
    private ItemRepository itemRepository;

    @GlobalTransactional
    @Transactional
    @Override
    public String reduce(String itemId) {
        // 打印一下undo_log
        printfUndoLog();
        printfStock();

        System.out.println("正在扣减奖品" + itemId + "的库存");
        itemRepository.reduce(itemId);
        System.out.println("奖品" + itemId + "的库存扣减完成");

        printfStock();
        printfUndoLog();
        return "OK";
    }

    private void printfUndoLog() {
        System.out.println("---> 正在打印undo_log");
        List<Map<String, Object>> undoLogs = jdbcTemplate.queryForList("SELECT  * FROM undo_log");
        Optional.ofNullable(undoLogs).orElse(new LinkedList<>()).forEach(eleLog -> {
            System.out.println(JSONObject.toJSONString(eleLog));
        });
    }

    private void printfStock() {
        System.out.println("---> 正在打印Stock");
        List<Map<String, Object>> itenInfos = jdbcTemplate.queryForList("SELECT  * FROM item_info");
        Optional.ofNullable(itenInfos).orElse(new LinkedList<>()).forEach(eleLog -> {
            System.out.println(JSONObject.toJSONString(eleLog));
        });
    }
}
