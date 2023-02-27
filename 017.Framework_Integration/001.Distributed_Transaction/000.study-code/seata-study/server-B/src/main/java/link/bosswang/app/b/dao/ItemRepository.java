package link.bosswang.app.b.dao;

import link.bosswang.app.b.dao.entity.ItemInfo;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.query.Param;

@org.springframework.stereotype.Repository
public interface ItemRepository extends Repository<ItemInfo, Long> {
    @Modifying
    @Query(value = "UPDATE item_info SET stock = stock-1 WHERE item_id = :itemId", nativeQuery = true)
    public abstract int reduce(@Param("itemId") String itemId);
}
