package link.bosswang.app.b.dao.entity;


import lombok.Data;
import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;

@Entity
@Data
@ToString
@Table(name = "item_info")
public class ItemInfo implements Serializable {
    @Id
    private Long id;
    private String itemId;
    private String itemName;
    private Integer stock;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }
}
