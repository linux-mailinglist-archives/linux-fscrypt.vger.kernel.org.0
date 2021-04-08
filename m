Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A443358CB9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhDHSeQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:34:16 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60099 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232840AbhDHSeP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:34:15 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id BC743EC2;
        Thu,  8 Apr 2021 14:34:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:34:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=gd728l4b8OPmwqPe77VVeDs5yO
        I+vftdu42Je/9HNEc=; b=rSPEYfPLyHpYKG517Y/a4lNxs8hq4aJ1ukFlmPd43/
        mGUzPASjpFSqEKgrD/zmCaWYyUCu5GJRtoFWsHaf+3dUvWEJoKugPxILs3c5vW2R
        1NByMnHyl7J0rxMwcq+T+jbD0GkngPWbb4U8nduQmVfQRbCpk2reKfGeOVPg6uDx
        EAaxelszMEY38xNtAgHI6F1UZuvOv0AwsI4WZeEohJE2+Ocro76D4IQFf3lHiBlp
        O+SCpwhqQE1NcDwmqnLMSucNsgbPRMLtiXMtReoA8Y84q+L7Iy0E8q+vyJTaNYLF
        VwO42RrKuBUMaGVH5QCagtTYW4/q8sQ3RkNJXvQ4BJ+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=gd728l4b8OPmwqPe77VVeDs5yOI+vftdu42Je/9HNEc=; b=Jc9rCtiM
        1JO/hiKsFbK1wj0oUIsvZ36Q/7LHWIhiTgvlpj96RiWOXWl99aiYUADgE9OuC4hi
        Vh/NI6NNmGrko8TEfuXz8CWnqt05NMQ/qT3vMla4dszVil/0WXreCZwONcVh+p/m
        nTCQMpuoIKu/l46GY7BcQxpa7A47EovrmxHcv6SMgE7alWaSeUFLGpGtqle9xlr3
        PpKdAx5WYpGzKMI4+g1CjPGATwYga8rJAgiCnIaOcq3uOT4tpBqgYTg4Hxuo0rTx
        jaWGs/CBtSc9us1gnGxIgOYNIWSVeHb4dGkawIYy/MbhMGVsxv7s9Kv9jiKdVdbJ
        ewWwoxrSCoK5VQ==
X-ME-Sender: <xms:m0xvYLEyplqWTP3YsmtCoXzOOlc7m8Xzscfy1OjPjf5C326qdikZOg>
    <xme:m0xvYHaW47FvoS0WZgsgux5qu6gctVo-6Wk5jVqv4USAeShrbVbK7U0Vunci-ZMzG
    ZGThwxER1mvaKuyWmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:m0xvYDXSadOQlfPZXwZ6PiMg7t2rPEPI9vzDK3iiQtiwEbb6dNy_dw>
    <xmx:m0xvYFk8r0oJ8t2tRQDsw8YRyECRKwmBJPBNthS2FZllEp-jDY4j3A>
    <xmx:m0xvYGA2HzXJmkT9MWoBufPQ_N68bwHuwYM4LhPQ6NhYt6vLKSm8Dg>
    <xmx:m0xvYCQ5e5E3dJWGu158AjpSXLw5w5AueJr7T2f02CnyPR7W-Ta4gQ>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 311311080057;
        Thu,  8 Apr 2021 14:34:03 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 4/5] btrfs: fallback to buffered io for verity files
Date:   Thu,  8 Apr 2021 11:33:55 -0700
Message-Id: <f532399163803a1955acdff27926fa74ebb763c5.1617900170.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617900170.git.boris@bur.io>
References: <cover.1617900170.git.boris@bur.io>
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
index e8dcada0d239..9f8d90bbbe26 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3613,6 +3613,9 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 
+	if (fsverity_active(inode))
+		return 0;
+
 	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
 		return 0;
 
-- 
2.30.2

