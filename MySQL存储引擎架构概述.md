# Overview of MySQL Storage Engine Architecture(MySQL存储引擎架构概述)
&nbsp;&nbsp;The MySQL pluggable storage engine architecture enables a database professional to select a specialized storage engine for a particular application need while being completely shielded from the need to manage any specific application coding requirements. The MySQL server architecture isolates the application programmer and DBA from all of the low-level implementation details at the storage level, providing a consistent and easy application model and API. Thus, although there are different capabilities across different storage engines, the application is shielded from these differences.(MySQL可插拔存储引擎架构使数据库专业人员能够为特定的应用程序需求选择专门的存储引擎，同时完全不需要管理任何特定的应用程序编码需求。MySQL服务器架构将应用程序程序员和DBA与存储层的所有底层实现细节隔离开来，从而提供了一致且简单的应用程序模型和API。因此，尽管在不同的存储引擎之间存在不同的功能，但应用程序不会受到这些差异的影响。)

## MySQL Architecture with Pluggable Storage Engines
<div style="margin-left:30px;"><img src="./pics/mysql-pluggable-storage-engine-architecture.png"/></div>


&nbsp;&nbsp;The pluggable storage engine architecture provides a standard set of management and support services that are common among all underlying storage engines. The storage engines themselves are the components of the database server that actually perform actions on the underlying data that is maintained at the physical server level.(可插拔存储引擎体系结构提供了一组标准的管理和支持服务，这些服务在所有底层存储引擎中都是通用的。存储引擎本身是数据库服务器的组件，它实际对维护在物理服务器级别的底层数据执行操作。)

&nbsp;&nbsp;This efficient and modular architecture provides huge benefits for those wishing to specifically target a particular application need—such as data warehousing, transaction processing, or high availability situations—while enjoying the advantage of utilizing a set of interfaces and services that are independent of any one storage engine.(这种高效的模块化体系结构为那些希望专门针对特定应用程序需求(如数据仓库、事务处理或高可用性情况)的人提供了巨大的好处，同时享受利用一组独立于任何存储引擎的接口和服务的优势。)

&nbsp;&nbsp;The application programmer and DBA interact with the MySQL database through Connector APIs and service layers that are above the storage engines. If application changes bring about requirements that demand the underlying storage engine change, or that one or more storage engines be added to support new needs, no significant coding or process changes are required to make things work. The MySQL server architecture shields the application from the underlying complexity of the storage engine by presenting a consistent and easy-to-use API that applies across storage engines.(应用程序程序员和DBA通过位于存储引擎之上的连接器api和服务层与MySQL数据库交互。如果应用程序更改带来了需要更改底层存储引擎的需求，或者需要添加一个或多个存储引擎以支持新需求，则不需要进行重大的编码或流程更改即可使其正常工作。MySQL服务器架构通过提供一个适用于存储引擎的一致且易于使用的API，使应用程序免受存储引擎底层复杂性的影响。)

---

## 参考资料
1. [16.11 Overview of MySQL Storage Engine Architecture](https://dev.mysql.com/doc/refman/8.0/en/pluggable-storage-overview.html#mysql-architecture-diagram)