Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEED063903C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Nov 2022 20:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiKYTUy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Nov 2022 14:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKYTUy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Nov 2022 14:20:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC072CCAD
        for <linux-fscrypt@vger.kernel.org>; Fri, 25 Nov 2022 11:20:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CEFB82C0B
        for <linux-fscrypt@vger.kernel.org>; Fri, 25 Nov 2022 19:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54FCC433C1;
        Fri, 25 Nov 2022 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669404050;
        bh=TsKgHYqePFfdWcyQkwlq5qeu1v7YvXCF3Dko3dHrcNE=;
        h=From:To:Cc:Subject:Date:From;
        b=aRQpi8DC30/eHPdHm/w81QI2ypvK2BJufyjcNbpuKM8SEozUJFOMyRIJoQ9gCDF+x
         USjZhLUvoGHfC+w4VFIJtolmROIf9CosU34ZTwdeZLNGQR8a0rSSKgUwPXowRRWJkf
         Vb6HKJXAHie9rc7vnK6QBef0MAFmwYBYoRCjlwHDMD7qB29R2GuSgmNSkJk5vTEKQ+
         7o5/WSIQe+//fRzOAH3s+hLq4GqXCPj8oNv5xbCKAt39I9XhRtbfyXErt6dOL3x8yE
         sgt4eFNT2wohmSj+0QWqTmqJLSaWtVUucbk0WqeamiddGHM+uflYJOtPgsettu76mB
         zcxukLwL2o5Cw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] fscrypt: add comment for fscrypt_valid_enc_modes_v1()
Date:   Fri, 25 Nov 2022 11:20:47 -0800
Message-Id: <20221125192047.18916-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make it clear that nothing new should be added to this function.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 46757c3052ef9..84fa51604b151 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -61,6 +61,13 @@ fscrypt_get_dummy_policy(struct super_block *sb)
 	return sb->s_cop->get_dummy_policy(sb);
 }
 
+/*
+ * Return %true if the given combination of encryption modes is supported for v1
+ * (and later) encryption policies.
+ *
+ * Do *not* add anything new here, since v1 encryption policies are deprecated.
+ * New combinations of modes should go in fscrypt_valid_enc_modes_v2() only.
+ */
 static bool fscrypt_valid_enc_modes_v1(u32 contents_mode, u32 filenames_mode)
 {
 	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&

base-commit: 02aef4225258fa6d022ce9040716aeecc3afc521
-- 
2.38.1

