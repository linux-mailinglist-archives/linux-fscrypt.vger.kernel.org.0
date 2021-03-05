Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552A932F3D9
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Mar 2021 20:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhCET1T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Mar 2021 14:27:19 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:44681 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhCET0r (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Mar 2021 14:26:47 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 680BD2B11;
        Fri,  5 Mar 2021 14:26:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 05 Mar 2021 14:26:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=J5FWW5HO3c8kpgrrRaPFjrymDw
        IfNpVfTtewo+6Gb2M=; b=Iyr+KWOCKDJEiZQi+Wh/0tt5QypxFaHPcw6HpUaHkj
        MKUODKCCO7nlaytnD5iW8HpNQsPZT3K/pIEcP87H7RCWj0l5OmJLr14dcGb9H4o8
        xA6eKuMcLcTy+WNke+sh2+yr+cFoRfnxpe3PUfI7hyRlgjNDQFaDQbpTBmVyBSVG
        7xuDzDa6cTOJWkOWq3OMI3P+zJnOOdgmQqEqsuwbkW6FIJ5VAAALR0LH1Odnzbtr
        hJenGynUFS6Lsdr1fYvKTcckiONtPggD4nwyPPXQzQIw6pgAP0nBeX4GI2l3H4gs
        nLfV3Og5RFL3uGAnToKXJ0a+g0akH0JgIBy9YwwrhqRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=J5FWW5HO3c8kpgrrRaPFjrymDwIfNpVfTtewo+6Gb2M=; b=iC25zTzE
        awpIbZwQ1yIUd1KSge0USUCpRMVDyJxGQ1zw+utmlfYYlTyzJ9F9OFEYU5pn1GJB
        LqVaYVMRnrISYTNvXmZ0Hb0nCcjgWZxUP2ayKtIyVPUwiHTnaE04HWDmEvi39amS
        60EvlBieqRUBMuwrqVkZ6ESRmxKP1pfb42Hli/3HzULBmk99N+vZFLEuun+7mpl9
        HSEKL7aAbIxawv5FLJaHOVsLpKVmS1Pjr0w8k54ze4IMkvnovcRSBsz11Bc7t+K8
        7Fr/Kd8NU1TzjZ2RDWSDF7T1ZAPTfxbG2o7Iwl2q8paePZGz8bBgBwL6YieHyrF0
        onYcGeGzUT6qmA==
X-ME-Sender: <xms:9YVCYLrxrCJreVixaz2pZwcgqvJb4Bn_gGiW98af5JxlKhNx0BNPZg>
    <xme:9YVCYFokPpDvFsA6TfQWJbIK5abGQbsegLN-Liy3hZ4UxrZ_nJy5Wi9D8uong4fb3
    S-FVor83gh5vSwJiZM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtiedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    eiueffuedvieeujefhheeigfekvedujeejjeffvedvhedtudefiefhkeegueehleenucfk
    phepudeifedruddugedrudefvddrheenucevlhhushhtvghrufhiiigvpedunecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:9YVCYIOudsWyMaFDU-FyqeG3XkBueBWtACRcnGmuSbtLII2QBm86jQ>
    <xmx:9YVCYO5r-XONRC6Pxk8RnGq4JwGrjJ8r_Z533-ESuFyrCptxnRx6sw>
    <xmx:9YVCYK6M1pcy7s4im6rllHfYoGi5FroRu25jkw4zGr4Ee6Cey7uKrw>
    <xmx:9oVCYATH7GM43j907mySQljbO0P4MWsR7HFQB90uDUBXp7YleeHgRQ>
Received: from localhost (unknown [163.114.132.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E3231080063;
        Fri,  5 Mar 2021 14:26:45 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org,
        'Eric Biggers ' <ebiggers@kernel.org>
Subject: [PATCH v2 3/5] btrfs: check verity for reads of inline extents and holes
Date:   Fri,  5 Mar 2021 11:26:31 -0800
Message-Id: <c8bf8ecce537f600e83438db334bf8f338dae7ae.1614971203.git.boris@bur.io>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1614971203.git.boris@bur.io>
References: <cover.1614971203.git.boris@bur.io>
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
index 0d6f8b33830f..653b066f3043 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2201,18 +2201,6 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
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
@@ -3427,14 +3415,14 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
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
@@ -3515,9 +3503,10 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 
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
@@ -3525,9 +3514,8 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
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
@@ -3537,7 +3525,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 		 */
 		if (block_start == EXTENT_MAP_INLINE) {
 			unlock_extent(tree, cur, cur + iosize - 1);
-			end_page_read(page, false, cur, iosize);
+			ret = end_page_read(page, false, cur, iosize);
 			cur = cur + iosize;
 			pg_offset += iosize;
 			continue;
@@ -3555,7 +3543,7 @@ int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 			*bio_flags = this_bio_flag;
 		} else {
 			unlock_extent(tree, cur, cur + iosize - 1);
-			end_page_read(page, false, cur, iosize);
+			ret = end_page_read(page, false, cur, iosize);
 			goto out;
 		}
 		cur = cur + iosize;
-- 
2.24.1

