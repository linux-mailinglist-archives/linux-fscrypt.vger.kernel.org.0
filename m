Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CD83748A2
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 May 2021 21:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhEETVv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 May 2021 15:21:51 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53665 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235377AbhEETVs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 May 2021 15:21:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6DE5B5C0199;
        Wed,  5 May 2021 15:20:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 05 May 2021 15:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=OTn2VJGUKEh++E08+3NbIo7Gy2
        0jA/Y9uR37p8Tn0Kc=; b=FTcgRhX3EZlZd8POnj528VDWUT8fOKEk4m88hT4EfF
        87zlBXiBd2hzz7JCgBiZ5ikqG5Pe03tn+215u+/lSYFZSR5oym4MvQ/Dv2LhoDyH
        V4WJjtJ8lTNe/S4THXHJLKimtdJTMqVeCZnemo61+Kixzlb526EMHV9icnzjOE43
        DiO234Sr5kn5zjwTagAlp4jKhLUNNEq5Jpr0v1OTHqozXumGlPehwQ2sFJxmq7ss
        oMudCt92xVUjHTFIgOQT7w22Va694fBJnrasCmM/CLxPWfo9UG8Qz8fKDSuX4z8S
        y8glTQ4hXYdCDZk9cybYq/qLRXNTmFWhx++2fYVKCqkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=OTn2VJGUKEh++E08+3NbIo7Gy20jA/Y9uR37p8Tn0Kc=; b=jUOHsVsm
        jIwYaRJmSVfAgcZdmeWGv5NprJiyKGjMML/8M5P/HmBSSjvRB57LT59J8RiCtsQ+
        wkuFcujlD1EERYswizHJNaE/28wYHFwK7eHLazL2UTVKFEeLP4xeNJF4ruYNLv/j
        sCU0+Rk3cR6HtUdRlheWytquLI/Cy6Z/5zvGporHQSTO3kv17FiOmAv+2DSdSgqs
        Fo45gHYeI6MhiVX6uyp4cs5HG5MgSfffOmgLyQdPgbrUibPcbbOhJZt1uGlGLxoB
        oaA+xiVtA8eXnQph2mgIdY5druXmrnet1hEC48WFxhIoCLxBbBuFlB81V+EUxwNZ
        IdN1MjZl3wKGjA==
X-ME-Sender: <xms:E_CSYOEnEuz4f6oRtc8le8JYpoYFQyXWtGt10jSHkKUcsqwO_K9cgA>
    <xme:E_CSYPU88fynuAuX1jQzTmiYDrYzd8atow3vNHZ-IVTwd6Mg9fN-I8xgqK5W2FC7Q
    5Ls8NEPqr0gfYyaZGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:E_CSYIJqtw5yZVWQ5fl3KTxXYWyWktmL_hEL6baZv7OG4XZQp6IhPg>
    <xmx:E_CSYIGRhD7BtIy3aVkNXhVgkT56sFIE1TXwTLf9GBSBiuJYJtD9KQ>
    <xmx:E_CSYEWeW_ZfKqAzwahACub3OruSL620CSDEjjSnsdV-1VEB9kaJGg>
    <xmx:E_CSYNeV4huw5ucRskBzHFvoe6abbZhKTUS5cnZJlOSc2ehj6xzm5Q>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 15:20:51 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v4 4/5] btrfs: fallback to buffered io for verity files
Date:   Wed,  5 May 2021 12:20:42 -0700
Message-Id: <6d7ffab08e76b18a5e29eff7268f860803a82c61.1620241221.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620241221.git.boris@bur.io>
References: <cover.1620241221.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Reading the contents with direct IO would circumvent verity checks, so
fallback to buffered reads. For what it's worth, this is how ext4
handles it as well.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a99470303bd9..34bc22fa6b1f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3628,6 +3628,9 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 
+	if (fsverity_active(inode))
+		return 0;
+
 	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
 		return 0;
 
-- 
2.30.2

