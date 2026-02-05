/*****************************************************************************

Copyright (c) 1995, 2024, Oracle and/or its affiliates.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License, version 2.0, as published by the
Free Software Foundation.

This program is designed to work with certain software (including
but not limited to OpenSSL) that is licensed under separate terms,
as designated in a particular file or component or in included license
documentation.  The authors of MySQL hereby grant you an additional
permission to link the program and your derivative works with the
separately licensed software that they have either included with
the program or referenced in the documentation.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License, version 2.0,
for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA

*****************************************************************************/

/** @file include/fil0types.h
 The low-level file system page header & trailer offsets

 Created 10/25/1995 Heikki Tuuri
 *******************************************************/

#ifndef fil0types_h
#define fil0types_h

#include "univ.i"

/**           [File Header]             */

/**
 * InnoDB 为了性能和对齐，大量使用了原始指针偏移量 , 而不是直接使用struct进行映射
 */

/** The byte offsets on a file page for various
 * variables.(文件页中各项变量的字节偏移量) */

/** MySQL-4.0.14 space id the page belongs to (== 0) but in later
versions the 'new' checksum of the page (页的checksum值) */
constexpr uint32_t FIL_PAGE_SPACE_OR_CHKSUM = 0; 

/**
 * constexpr: constant expression"（常量表达式）
 * constexpr 告诉编译器：“这个值在编译期间就能完全确定下来，请把它当成一个编译时常量来对待。”
 */
/**
 * page offset inside space  (表空间中页的偏移量,)
 * 怎么理解?
 * 假设独立表空间a.ibd大小为1G,页大小为16K,那么总共 65536
 * 个页,FIL_PAGE_OFFSET就表示
 * 当前页在所有页当中的位置，若表空间的ID是10，搜索(10,1)就表示查找a中的第2个页
 * 
 * 就是page numver
 */
constexpr uint32_t FIL_PAGE_OFFSET = 4;

/** if there is a 'natural' predecessor of the page, its offset.
 *Otherwise FIL_NULL. This field is not set on BLOB pages, which are stored as a
 *singly-linked list. See also FIL_PAGE_NEXT.
 *(如果该页存在‘自然’前驱页，则记录其偏移量（页号）；否则为
 * FIL_NULL。此字段在以单向链表形式存储的 BLOB 页上不被设置。另请参阅
 * FIL_PAGE_NEXT。) 
 * ==> 指向前驱节点 (双向链表)
 * */
constexpr uint32_t FIL_PAGE_PREV = 8;

/** On page 0 of the tablespace, this is the server version ID */
constexpr uint32_t FIL_PAGE_SRV_VERSION = 8;

/** if there is a 'natural' successor of the page, its offset. Otherwise
 * FIL_NULL. B-tree index pages(FIL_PAGE_TYPE contains FIL_PAGE_INDEX) on the
 * same PAGE_LEVEL are maintained as a doubly linked list via FIL_PAGE_PREV and
 * FIL_PAGE_NEXT in the collation order of the smallest user record on each
 * page.
 * (如果该页存在‘自然’后继页，则记录其偏移量（页号）；否则为 FIL_NULL。处于相同
 * PAGE_LEVEL（页面层级）的 B 树索引页（即 FIL_PAGE_TYPE 为 FIL_PAGE_INDEX
 * 的页面），会根据每个页面上最小用户记录的排序顺序，通过 FIL_PAGE_PREV 和
 * FIL_PAGE_NEXT 维护成一个双向链表。) 当前页的下一个页
 * 
 * ===> 后续节点（双向链表）
 * */
constexpr uint32_t FIL_PAGE_NEXT = 12;

/** On page 0 of the tablespace, this is the server version ID */
constexpr uint32_t FIL_PAGE_SPACE_VERSION = 12;

/**
 *  lsn(Log Sequence Number) of the end of the newest modification log record to the page
 * （该页最后被修改的日志序列位置）
 *  */
constexpr uint32_t FIL_PAGE_LSN = 16;

/** file page type: FIL_PAGE_INDEX,..., 2 bytes. The contents of this field can
 * only be trusted in the following case: if the page is an uncompressed B-tree
 * index page, then it is guaranteed that the value is FIL_PAGE_INDEX. The
 * opposite does not hold. (文件页类型：FIL_PAGE_INDEX 等，占 2
 * 字节。该字段的内容仅在以下情况下是可靠的：如果该页是一个未压缩的 B
 * 树索引页，那么其值保证为 FIL_PAGE_INDEX。但反之则不一定成立（即：值位为
 * FIL_PAGE_INDEX 的页并不一定就是未压缩的 B 树索引页）)
 *
 *  In tablespaces created
 * by MySQL/InnoDB 5.1.7 or later, the contents of this field is valid for all
 * uncompressed pages. */
constexpr uint32_t FIL_PAGE_TYPE = 24;

/** this is only defined for the first page of the system tablespace: the file
 * has been flushed to disk at least up to this LSN. For FIL_PAGE_COMPRESSED
 * pages, we store the compressed page control information in these 8 bytes.
 *
 * (该字段仅对系统表空间（System
 * Tablespace）的第一页有定义：表示文件已至少冲刷（Flush）到磁盘至该
 * LSN（日志序列号）处。对于 FIL_PAGE_COMPRESSED（压缩）页，这 8
 * 个字节则用于存储压缩页的控制信息)
 */
constexpr uint32_t FIL_PAGE_FILE_FLUSH_LSN = 26;

/** If page type is FIL_PAGE_COMPRESSED then the 8 bytes starting at
 * FIL_PAGE_FILE_FLUSH_LSN are broken down as follows: (如果页面类型为
 * FIL_PAGE_COMPRESSED，则从 FIL_PAGE_FILE_FLUSH_LSN 开始的 8
 * 个字节将按如下方式进行拆解：)
 */

/** Control information version format (u8) */
constexpr uint32_t FIL_PAGE_VERSION = FIL_PAGE_FILE_FLUSH_LSN;

/** Compression algorithm (u8) */
constexpr uint32_t FIL_PAGE_ALGORITHM_V1 = FIL_PAGE_VERSION + 1;

/** Original page type (u16) */
constexpr uint32_t FIL_PAGE_ORIGINAL_TYPE_V1 = FIL_PAGE_ALGORITHM_V1 + 1;

/** Original data size in bytes (u16)*/
constexpr uint32_t FIL_PAGE_ORIGINAL_SIZE_V1 = FIL_PAGE_ORIGINAL_TYPE_V1 + 2;

/** Size after compression (u16) */
constexpr uint32_t FIL_PAGE_COMPRESS_SIZE_V1 = FIL_PAGE_ORIGINAL_SIZE_V1 + 2;

/** This overloads FIL_PAGE_FILE_FLUSH_LSN for RTREE Split Sequence Number */
constexpr uint32_t FIL_RTREE_SPLIT_SEQ_NUM = FIL_PAGE_FILE_FLUSH_LSN;

/** starting from 4.1.x this contains the space id of the page */
constexpr uint32_t FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID = 34;

/** alias for space id */
constexpr uint32_t FIL_PAGE_SPACE_ID = FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID;

/** start of the data on the page (页面上数据的起始位置)*/
constexpr uint32_t FIL_PAGE_DATA = 38;

/*----------------------------------------------------*/

/** File page trailer(文件页尾（File Page Trailer）) */

/** the low 4 bytes of this are used to store the page checksum, the last 4
 * bytes should be identical to the last 4 bytes of FIL_PAGE_LSN (其中的低 4
 * 字节用于存储页面校验和（Checksum），最后 4 字节则应与 FIL_PAGE_LSN 的最后 4
 * 字节保持一致)
 */
constexpr uint32_t FIL_PAGE_END_LSN_OLD_CHKSUM = 8;

/** size of the page trailer */
constexpr uint32_t FIL_PAGE_DATA_END = 8;

/** First in address is the page offset. */
constexpr size_t FIL_ADDR_PAGE = 0;

/** Then comes 2-byte byte offset within page.*/
constexpr size_t FIL_ADDR_BYTE = 4;

/** Address size is 6 bytes. */
constexpr size_t FIL_ADDR_SIZE = 6;

/** Path separator e.g., 'dir;...;dirN' */
constexpr char FIL_PATH_SEPARATOR = ';';

/** A wrapper class to help print and inspect the file page header. */
struct Fil_page_header {
  /** The constructor that takes a pointer to page header as argument.
  @param[in]  frame  the pointer to the page header. */
  explicit Fil_page_header(const byte *frame) : m_frame(frame) {}

  /** Get the space id from the page header.
  @return the space identifier. */
  [[nodiscard]] space_id_t get_space_id() const noexcept;

  /** Get the page number from the page header.
  @return the page number. */
  [[nodiscard]] page_no_t get_page_no() const noexcept;

  /** Get the FIL_PAGE_PREV header value.
  @return the previous page number. */
  [[nodiscard]] page_no_t get_page_prev() const noexcept;

  /** Get the FIL_PAGE_NEXT header value.
  @return the next page number. */
  [[nodiscard]] page_no_t get_page_next() const noexcept;

  /** Get the page type from the page header.
  @return the page type. */
  [[nodiscard]] uint16_t get_page_type() const noexcept;

  /** Print the page header to the given output stream.
  @param[in]  out  the output stream.
  @return the output stream. */
  std::ostream &print(std::ostream &out) const noexcept;

 private:
  /**
   *  Pointer to the page header. 
   * {} (列表初始化): 等价于 const byte *m_frame = nullptr;
   * */
  const byte *m_frame{};
};

/** Overload the global output operator to handle an object of type
Fil_page_header.
@param[in]  out      the output stream.
@param[in]  header   an object of type Fil_page_header.
@return the output stream. */
inline std::ostream &operator<<(std::ostream &out,
                                const Fil_page_header &header) noexcept {
  return (header.print(out));
}

#endif /* fil0types_h */
