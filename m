Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8739A1BD5C9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Apr 2020 09:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgD2HV5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 29 Apr 2020 03:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgD2HVp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 29 Apr 2020 03:21:45 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B68C09B044
        for <linux-fscrypt@vger.kernel.org>; Wed, 29 Apr 2020 00:21:42 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h186so1613538qkc.22
        for <linux-fscrypt@vger.kernel.org>; Wed, 29 Apr 2020 00:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dcBMNhJyVF3JG7u2k+hpIfX5J5/+YNOMhft7o2B+Ju4=;
        b=dfrGTfJjx+xsOcKHeejLK4oMt9g5AcqcRK5/UgBb14pn/JbWFb1vMwUyV+V1slwjtj
         2nFObH6Yei1hbvG9BW2Ll9vbpOcTaaQWiATCvTV1B/VYCTXeUPCW+hLpf049cVmCdboI
         rHS6z3TM/IJRit3QH4E1ap9PyEFxHqulYCq7YE0up+baJBD6tgxW4NrGKOf9TJ+F3+Km
         QcXzGA2M5GB6W6B2ghC6wC+zS04Bwtty77EltXC43D73oIukh3a67IIcPcLbMepNDXfr
         2Xrzb2Hp+Ov7eBjxW/m2vgPs2VZpLO9whdG848N9ksL78T4b8vthHOeR4v9S1c4cj0LF
         qOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dcBMNhJyVF3JG7u2k+hpIfX5J5/+YNOMhft7o2B+Ju4=;
        b=BcxTyMQ0364bfrWWQi9OZDILD/HV39EVzSrbM/OOO1L3Q5wMMirceguBGdQdI9byto
         0SWgPsFyS9p0L2/vqAvP33s75bJT35Z2rQ4KHNY0IuwV57uVis12ZL36hJk5Vjeic6dw
         sWbg3bEl8LszAwP0KyGXwiC+P3BppGYxyEWjtCDefz6hvtxXSis4cP2wdC1ZVoId6e24
         yFVGj0vB8Ea2Zaw/zp8lCsfRkZ0J9wajpeeoyp4ljK9hyZB8ObNuX/0hKeWoGjzmPp1o
         qNPFnqbVwAx6hvMFI9j//mxso/9nrTjJj9hWtwuBe//ym1MLpn38sgotgGWGlY6atmN5
         65Kw==
X-Gm-Message-State: AGi0PuZF8kkAlipZ86djd42HpSFFKA3NF/w0eMEib/1Zw7pSv3qO9HVS
        zBzSoE5WN26Co7+D4ZfqjjBhzXxKuys=
X-Google-Smtp-Source: APiQypJz89cxZWdYzpcW5zsQCLnnJh9hiKeWJOQg2VT8hOJvTQfkY3cXLSwBZXj2P4l7aalg3AeJ9YcyX18=
X-Received: by 2002:ad4:55e7:: with SMTP id bu7mr32187009qvb.88.1588144901506;
 Wed, 29 Apr 2020 00:21:41 -0700 (PDT)
Date:   Wed, 29 Apr 2020 07:21:18 +0000
In-Reply-To: <20200429072121.50094-1-satyat@google.com>
Message-Id: <20200429072121.50094-10-satyat@google.com>
Mime-Version: 1.0
References: <20200429072121.50094-1-satyat@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v11 09/12] fs: introduce SB_INLINECRYPT
From:   Satya Tangirala <satyat@google.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Introduce SB_INLINECRYPT, which is set by filesystems that wish to use
blk-crypto for file content en/decryption. This flag maps to the
'-o inlinecrypt' mount option which multiple filesystems will implement,
and code in fs/crypto/ needs to be able to check for this mount option
in a filesystem-independent way.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/proc_namespace.c | 1 +
 include/linux/fs.h  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 273ee82d8aa97..8bf195d3bda69 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -49,6 +49,7 @@ static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 		{ SB_DIRSYNC, ",dirsync" },
 		{ SB_MANDLOCK, ",mand" },
 		{ SB_LAZYTIME, ",lazytime" },
+		{ SB_INLINECRYPT, ",inlinecrypt" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4f6f59b4f22a8..38fc6c8d4f45b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1376,6 +1376,7 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_NODIRATIME	2048	/* Do not update directory access times */
 #define SB_SILENT	32768
 #define SB_POSIXACL	(1<<16)	/* VFS does not apply the umask */
+#define SB_INLINECRYPT	(1<<17)	/* Use blk-crypto for encrypted files */
 #define SB_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define SB_I_VERSION	(1<<23) /* Update inode I_version field */
 #define SB_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
-- 
2.26.2.303.gf8c07b1a785-goog

