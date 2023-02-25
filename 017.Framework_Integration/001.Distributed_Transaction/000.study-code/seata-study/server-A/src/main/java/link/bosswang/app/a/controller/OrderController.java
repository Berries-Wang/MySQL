package link.bosswang.app.a.controller;


import link.bosswang.app.a.service.OrderService;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Map;

@Controller
@RequestMapping(value = "/order")
public class OrderController {


    @Resource
    private OrderService orderService;

    /**
     * 测试分布式事务
     */
    @RequestMapping(value = "/create", method = RequestMethod.GET)
    @ResponseBody
    @Transactional
    public Map<String, Object> create() {
        return orderService.createOrder();
    }
}
