Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96ED710F359
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Dec 2019 00:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfLBXX7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Dec 2019 18:23:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfLBXX7 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Dec 2019 18:23:59 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CF672070B;
        Mon,  2 Dec 2019 23:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575329039;
        bh=lZX2/5oOna+mrZByx/Tv6R6Up/081gLNvgkCi4uMBSI=;
        h=From:To:Cc:Subject:Date:From;
        b=GjSQIxuPN3LsIUsGVWkwDrS2xDk+HY8+n1LLJ4Z6vI0zBNXwwZE1M9pJHsvBwElWY
         F+ladbyPruyR59p7gXrPZ67VLs8ubijHF89ulzMn+ygvHafb2ZxZWNo33qlfNCDw0y
         7vbLX6A4YUErZ5wMRjsoQTQmEvtxQP+OdIXa4uCw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org
Subject: [xfstests-bld PATCH] kernel-configs: enable CONFIG_CRYPTO_ESSIV in 5.4 configs
Date:   Mon,  2 Dec 2019 15:23:40 -0800
Message-Id: <20191202232340.243744-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

On kernel 5.5 and later, CONFIG_CRYPTO_ESSIV is needed for one of the
fscrypt tests (generic/549) to run.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 kernel-configs/i386-config-5.4   | 1 +
 kernel-configs/x86_64-config-5.4 | 1 +
 2 files changed, 2 insertions(+)

diff --git a/kernel-configs/i386-config-5.4 b/kernel-configs/i386-config-5.4
index 195211e..3495a0d 100644
--- a/kernel-configs/i386-config-5.4
+++ b/kernel-configs/i386-config-5.4
@@ -170,6 +170,7 @@ CONFIG_IMA_APPRAISE=y
 CONFIG_EVM=y
 # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_ADIANTUM=y
+CONFIG_CRYPTO_ESSIV=y
 CONFIG_CRYPTO_CRC32C_INTEL=y
 CONFIG_CRYPTO_CRC32_PCLMUL=y
 CONFIG_CRYPTO_AES_NI_INTEL=y
diff --git a/kernel-configs/x86_64-config-5.4 b/kernel-configs/x86_64-config-5.4
index 9a6baaa..e8d2b68 100644
--- a/kernel-configs/x86_64-config-5.4
+++ b/kernel-configs/x86_64-config-5.4
@@ -177,6 +177,7 @@ CONFIG_IMA_APPRAISE=y
 CONFIG_EVM=y
 # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
 CONFIG_CRYPTO_ADIANTUM=y
+CONFIG_CRYPTO_ESSIV=y
 CONFIG_CRYPTO_CRC32C_INTEL=y
 CONFIG_CRYPTO_CRC32_PCLMUL=y
 CONFIG_CRYPTO_AES_NI_INTEL=y
-- 
2.24.0.393.g34dc348eaf-goog

