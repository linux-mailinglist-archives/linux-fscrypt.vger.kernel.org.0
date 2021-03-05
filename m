Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C44032F3D8
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Mar 2021 20:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhCET1T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Mar 2021 14:27:19 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53397 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhCET0u (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Mar 2021 14:26:50 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id A48D72B0E;
        Fri,  5 Mar 2021 14:26:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 05 Mar 2021 14:26:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=XbinyDEAT9G7Ltz/6B0Kj/lXpL
        DS2Shro9+tdT6xF5I=; b=KLWj+gekLzQSFXug1/6sPN8ryxSosZUc368LXQRUHL
        P3WjzXYLqSYLQEJMq8liuLAazVRSV8e5XfrpF65TaiA+okxDSVlXbVgNMMDCGY3Y
        ij8iHGTAOOmMn0Zhlj44/+1TzhjFoQRv8YgdGUeOVOekNjizzCRTy1/qc+WMAyhA
        HSDyGN0W5DG35T9UWrAdoKSgXVHxLYw+xS9y/iyBnHGnJyI++yO0JyY/RRN+cN1q
        zy+PTeFMddz4NTGG6oUCD7HZ3xYQLyWFMXRmpFTVn+EXyxJ7vZlutH8O8ABUEAoP
        UMTds1m/aAoBkeFmFdKqxGnFMd0jqTIb7qUu0mv51lww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=XbinyDEAT9G7Ltz/6B0Kj/lXpLDS2Shro9+tdT6xF5I=; b=n/V7fRHi
        mejTcldxcub7KdsxyyxHjWGfs1TjF9T2nBGA1RMDKkFfm1fgGQ0YzmBLsxBxa2Ft
        +oX8spPZGtG5G4Ko0u9B/v+CC5agNzyQoUze3KMG7q1o6VT6iyuujmvsV9/60x6e
        NujdVIj8oP1VucCX5Ic5O0SJXad0E6gVrAksdl7ztPEUphifSQhSuRNHCyOuL0t8
        FXFpxvGXwX3LQVFS1WHU8t4ySGyar0dPj6McC/hkxkAWJT+9xLxcqDps62LWpzyh
        ie/9sBa6oDqf/89zNA+wd5EYnC0NONxnGcC0sM9JaclvsqCOgN2s1z78jLzKcidI
        6oDvQDFr4gl9BA==
X-ME-Sender: <xms:-YVCYAQgR1D-0LTkTH5aPo2u3x8ewFeExObIkykVbUSNMXaZwnzAyw>
    <xme:-YVCYNxVslgWUzgi1MEc9q_48R79BAgESvs0VmMRMp5lmaL-ySA7pOfNpFGivoAsO
    dlopwgaGMRp_-q3gJI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtiedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    eiueffuedvieeujefhheeigfekvedujeejjeffvedvhedtudefiefhkeegueehleenucfk
    phepudeifedruddugedrudefvddrheenucevlhhushhtvghrufhiiigvpeefnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:-YVCYN2OQuMjio_EBz6U44_z9aCPMH5wLI7RgkZfiUZKmf_ZhjjSGw>
    <xmx:-YVCYEDOUC4NkYbUCi3DyFL1vOsCMC4xIe0w1vucc4HFe4xWqBYTeA>
    <xmx:-YVCYJgV-TCvK5LjbBfMcbGVKlaGSQYr2Wp2ep35vdFQjXttQtnvhA>
    <xmx:-YVCYJZhG9NjYKxnmXo1K9rSDyLe0ZKnrw0un1SEpHHLIGOWIh2bYg>
Received: from localhost (unknown [163.114.132.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBD16108005F;
        Fri,  5 Mar 2021 14:26:48 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org,
        'Eric Biggers ' <ebiggers@kernel.org>
Subject: [PATCH v2 4/5] btrfs: fallback to buffered io for verity files
Date:   Fri,  5 Mar 2021 11:26:32 -0800
Message-Id: <518322d5993f6eea18d5c4ee0cdaaa97fed9a405.1614971203.git.boris@bur.io>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1614971203.git.boris@bur.io>
References: <cover.1614971203.git.boris@bur.io>
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
index 75f1406021e5..c948c30e132c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3623,6 +3623,9 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 
+	if (fsverity_active(inode))
+		return 0;
+
 	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
 		return 0;
 
-- 
2.24.1

