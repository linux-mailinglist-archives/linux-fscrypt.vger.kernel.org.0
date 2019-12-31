Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DB212DAC2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Dec 2019 18:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLaRzH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Dec 2019 12:55:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfLaRzH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Dec 2019 12:55:07 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C300206D9
        for <linux-fscrypt@vger.kernel.org>; Tue, 31 Dec 2019 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577814906;
        bh=iNad00qPqjdEtWb49YYEP82Id43BSDgnkLg+Rq4W9CY=;
        h=From:To:Subject:Date:From;
        b=HVI/7lF3guhqLWeL2CnEens7MvWMgygB6kLRVPQu5MoaD+APSaXaHuUzESD/aCBwl
         yPYnF5M0D3rNvbZqwdP2D33j9wVKlFQjlk5yznmkeS60PIKFrUIBK6vZY++2vP/+4U
         dpUklx63FPNqoY+Fih6+gCa+c9ULzbWpDk2E7Y5o=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fs-verity: use u64_to_user_ptr()
Date:   Tue, 31 Dec 2019 11:54:08 -0600
Message-Id: <20191231175408.20524-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

<linux/kernel.h> already provides a macro u64_to_user_ptr().
Use it instead of open-coding the two casts.

No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/enable.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 1645d6326e32..520db12e2945 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -216,8 +216,7 @@ static int enable_verity(struct file *filp,
 
 	/* Get the salt if the user provided one */
 	if (arg->salt_size &&
-	    copy_from_user(desc->salt,
-			   (const u8 __user *)(uintptr_t)arg->salt_ptr,
+	    copy_from_user(desc->salt, u64_to_user_ptr(arg->salt_ptr),
 			   arg->salt_size)) {
 		err = -EFAULT;
 		goto out;
@@ -226,8 +225,7 @@ static int enable_verity(struct file *filp,
 
 	/* Get the signature if the user provided one */
 	if (arg->sig_size &&
-	    copy_from_user(desc->signature,
-			   (const u8 __user *)(uintptr_t)arg->sig_ptr,
+	    copy_from_user(desc->signature, u64_to_user_ptr(arg->sig_ptr),
 			   arg->sig_size)) {
 		err = -EFAULT;
 		goto out;
-- 
2.24.1

