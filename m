Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D48D358CB7
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhDHSeO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:34:14 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:41111 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232608AbhDHSeO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:34:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8088ED40;
        Thu,  8 Apr 2021 14:34:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 08 Apr 2021 14:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=N20CXryfB2nGoFxRclfcVkf9Fv
        xw9P7I4zlwZ715vks=; b=NAQ7eCklW/aDM9qpkleYp5wT6L2GZyJaN9lWkX5Th1
        DfJVzunDmJsy6wbQLnhVpXyJh6EHC1lmJrnRmWchUep5UJH+uAWN+M8mnZPKU1Oc
        eyCGWBpdcWlX+cHZY4u8ML/UI3FPjov6kPYja6VD2aoblegaQczvZcH809a5pbd6
        zCGQ5+SHxb2OE6AKKtTZkYaIEnVBXtSRrqyosEvEpYP+O9JSmgrlD8RIqf+JIJ7p
        V/1RwEOShVURpfJxQeyK+fUah85OgPi8Acxst1OrB/kKLj4VJJ4LkQrGa97KlVF/
        +ZY4Q1djfQNzctvYZoJSy7KFtNAdBaLtbApW/Nbo/dNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=N20CXryfB2nGoFxRclfcVkf9Fvxw9P7I4zlwZ715vks=; b=tNwcHom/
        cDbe9rcyuzXP5uxPAApAYcoXB9KhJnzJK5tyw2z4JQnRyatXEERqLS7xvxwK5l/a
        ZphL2QOPLe3hPz96WmvERmgh2n2MY2hUlFWFyjsRTgkao6WdMRxpkg/EpwDppSHx
        JtehI+jc13P5jfZ2r/3RBETKxCBlt5EH1oQ9YHwjo9QboJaV9wAi38+mWE7ROX/+
        6Fl1HnziSFxfbS9sY3SThNoN4BHsDgJSfy096twJJyS20ImbcwXpot04Isi9Md5n
        2r4abtqq/eKg3OvinTTxHM2MDvhbOMFbjrH7u48tC7N4mp0uJ5se7AwIrI69r0FN
        eq2h+B+S/ocDDQ==
X-ME-Sender: <xms:mkxvYO3pBzzoSDwCOUAdKgJCELnqHNh-DCdIwGGhksk1WVBlV7FspQ>
    <xme:mkxvYCqEDKHjIqpiwNdI_s-OURsk7jaSKOhyO3BdjxQ3Kg59p5SLvCSwaMNXsIPIj
    ao7Kj9UfpExmTpdq3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:mkxvYNPolYsaWDhYUvnThqsIktkLkY-1iXKbwJ7dOObABwXXtxtc7A>
    <xmx:mkxvYLrsKy4QgEZZYGuTeA0nSkYvvPhVjfrDkPJtTmmT5EBgG8K3yg>
    <xmx:mkxvYIvoT9dzU8O7_9tDEsRj3mXEHzeYoXp23apEnqbtvs47uXP9eA>
    <xmx:mkxvYG0UcuVbxZHtnxnRIjskq-jyVFTV7dxuueAr--bUXBZgs8op3g>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id E144A1080057;
        Thu,  8 Apr 2021 14:34:01 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 3/5] btrfs: check verity for reads of inline extents and holes
Date:   Thu,  8 Apr 2021 11:33:54 -0700
Message-Id: <533e9f42d156fa2bd27b28c0c62a956e3245f3b9.1617900170.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617900170.git.boris@bur.io>
References: <cover.1617900170.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The majority of reads receive a verity check after the bio is complete
as the page is marked uptodate. However, there is a class of reads which
are handled with btrfs logic in readpage, rather than by submitting a
bio. Specifically, these are inline extents, preallocated extents, and
holes. Tweak readpage so that if it is going to mark such a page
uptodate, it first checks verity on it.

Now if a veritied file has corruption to this class of EXTENT_DATA
items, it will be detected at read time.

There is one annoying edge case that requires checking for start <
last_byte: if userspace reads to the end of a file with page aligned
size and then tries to keep reading (as cat does), the buffered read
code will try to read the page past the end of the file, and expects it
to be filled with 0s and marked uptodate. That bogus page is not part of
the data hashed by verity, so we have to ignore it.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_io.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bf784c10040b..a15f289e29e6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2202,18 +2202,6 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	return bitset;
 }
 
-/*
- * helper function to set a given page up to date if all the
- * extents in the tree for that page are up to date
- */
-static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
-{
-	u64 start = page_offset(page);
-	u64 end = start + PAGE_SIZE - 1;
-	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
-		SetPageUptodate(page);
-}
-
 int free_io_failure(struct extent_io_tree *failure_tree,
 		    struct extent_io_tree *io_tree,
 		    struct io_failure_record *rec)
@@ -3467,14 +3455,14 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur,
 					     cur + iosize - 1, &cached);
-			end_page_read(page, true, cur, iosize);
+			ret = end_page_read(page, true, cur, iosize);
 			break;
 		}
 		em = __get_extent_map(inode, page, pg_offset, cur,
 				      end - cur + 1, em_cached);
 		if (IS_ERR_OR_NULL(em)) {
 			unlock_extent(tree, cur, end);
-			end_page_read(page, false, cur, end + 1 - cur);
+			ret = end_page_read(page, false, cur, end + 1 - cur);
 			break;
 		}
 		extent_offset = cur - em->start;
@@ -3555,9 +3543,10 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
+
 			unlock_extent_cached(tree, cur,
 					     cur + iosize - 1, &cached);
-			end_page_read(page, true, cur, iosize);
+			ret = end_page_read(page, true, cur, iosize);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -3565,9 +3554,8 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		/* the get_extent function already copied into the page */
 		if (test_range_bit(tree, cur, cur_end,
 				   EXTENT_UPTODATE, 1, NULL)) {
-			check_page_uptodate(tree, page);
 			unlock_extent(tree, cur, cur + iosize - 1);
-			end_page_read(page, true, cur, iosize);
+			ret = end_page_read(page, true, cur, iosize);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -3577,7 +3565,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		 */
 		if (block_start == EXTENT_MAP_INLINE) {
 			unlock_extent(tree, cur, cur + iosize - 1);
-			end_page_read(page, false, cur, iosize);
+			ret = end_page_read(page, false, cur, iosize);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -3595,7 +3583,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 			*bio_flags = this_bio_flag;
 		} else {
 			unlock_extent(tree, cur, cur + iosize - 1);
-			end_page_read(page, false, cur, iosize);
+			ret = end_page_read(page, false, cur, iosize);
 			goto out;
 		}
 		cur = cur + iosize;
-- 
2.30.2

