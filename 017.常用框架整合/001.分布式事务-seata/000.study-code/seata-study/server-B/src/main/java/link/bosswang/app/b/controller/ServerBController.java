package link.bosswang.app.b.controller;


import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/b")
public class ServerBController {

    @Resource
    private JdbcTemplate jdbcTemplate;

    /**
     * 测试分布式事务
     */
    @RequestMapping(value = "/test", method = RequestMethod.GET)
    @ResponseBody
    @Transactional
    public Map<String, Object> test() {
        jdbcTemplate.execute("INSERT INTO user_b(name,age) VALUES ('小汪_server_b',27);");
        HashMap<String, Object> rsp = new HashMap<>();
        rsp.put("app_name", "server-B");
        return rsp;
    }

    /**
     * 单事务回滚
     */
    @RequestMapping(value = "/rollback", method = RequestMethod.GET)
    @ResponseBody
    @Transactional
    public Map<String, Object> rollback() {
        jdbcTemplate.execute("INSERT INTO user_b(name,age) VALUES ('应该RollBack的',27);");
        throw new RuntimeException("RollBack");
    }
}
