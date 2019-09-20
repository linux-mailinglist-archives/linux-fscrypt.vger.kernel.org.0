Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A25B886E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Sep 2019 02:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390558AbfITAUH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Sep 2019 20:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391401AbfITAUH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Sep 2019 20:20:07 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 217CE21924;
        Fri, 20 Sep 2019 00:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568938803;
        bh=/iBbWJUHXXeizMoV7RFiy8dyUlcRnueuVF6qOxMeDNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkThbXT2O3BgCUSff5nGiS8tOEyB2rkMb/PREifE3naegUKA2pybrCBZ5cZXV9VfI
         iny1r9JKnrlhUOPsVkHLJx4fOngPpGtEuFcC/hkW5yhI7kvKxN2BP6BnchaLR2NyKp
         qWtWUXtmdFhMwP7j4uoDnI2G9xpOaRR90qEHj89E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 3/8] xfs_io/encrypt: add new encryption modes
Date:   Thu, 19 Sep 2019 17:18:17 -0700
Message-Id: <20190920001822.257411-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920001822.257411-1-ebiggers@kernel.org>
References: <20190920001822.257411-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add new encryption modes: AES-128-CBC and AES-128-CTS (supported since
Linux v4.11), and Adiantum (supported since Linux v5.0).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index 011a6410..f5046e5b 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -156,7 +156,7 @@ set_encpolicy_help(void)
 " -v VERSION -- version of policy structure\n"
 "\n"
 " MODE can be numeric or one of the following predefined values:\n"
-"    AES-256-XTS, AES-256-CTS\n"
+"    AES-256-XTS, AES-256-CTS, AES-128-CBC, AES-128-CTS, Adiantum\n"
 " FLAGS and VERSION must be numeric.\n"
 "\n"
 " Note that it's only possible to set an encryption policy on an empty\n"
@@ -170,6 +170,9 @@ static const struct {
 } available_modes[] = {
 	{FSCRYPT_MODE_AES_256_XTS, "AES-256-XTS"},
 	{FSCRYPT_MODE_AES_256_CTS, "AES-256-CTS"},
+	{FSCRYPT_MODE_AES_128_CBC, "AES-128-CBC"},
+	{FSCRYPT_MODE_AES_128_CTS, "AES-128-CTS"},
+	{FSCRYPT_MODE_ADIANTUM, "Adiantum"},
 };
 
 static bool
-- 
2.23.0.351.gc4317032e6-goog

