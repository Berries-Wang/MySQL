package link.bosswang.app.a.dao;

import link.bosswang.app.a.dao.endity.StuOrder;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;


@org.springframework.stereotype.Repository
public interface OrderRepository extends Repository<StuOrder, Long> {

    @Modifying
    @Query(value = "INSERT INTO seata_stu_order(order_id,buyer_name) VALUES(:#{#stuOrder.orderId},:#{#stuOrder.buyerName});", nativeQuery = true)
    public abstract int saveStuOrder(@Param("stuOrder") StuOrder stuOrder);
}
