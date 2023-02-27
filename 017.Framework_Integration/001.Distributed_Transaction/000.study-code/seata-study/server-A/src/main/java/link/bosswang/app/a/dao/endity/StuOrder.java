package link.bosswang.app.a.dao.endity;


import lombok.Data;
import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;

@Entity
@Data
@ToString
@Table(name = "seata_stu_order")
public class StuOrder implements Serializable {
    @Id
    private Long id;
    private String orderId;
    private String buyerName;

    public StuOrder(String orderId, String buyerName) {
        this.orderId = orderId;
        this.buyerName = buyerName;
    }

    public StuOrder() {
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }
}
