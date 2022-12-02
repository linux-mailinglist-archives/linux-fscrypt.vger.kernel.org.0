Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB0D63FF44
	for <lists+linux-fscrypt@lfdr.de>; Fri,  2 Dec 2022 04:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiLBD4I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 22:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiLBD4H (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 22:56:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47741CFE63
        for <linux-fscrypt@vger.kernel.org>; Thu,  1 Dec 2022 19:56:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8044B82032
        for <linux-fscrypt@vger.kernel.org>; Fri,  2 Dec 2022 03:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64352C433D6
        for <linux-fscrypt@vger.kernel.org>; Fri,  2 Dec 2022 03:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669953363;
        bh=2BTq1ht91ixACHQMxH1BUTtBJH18g/gNHdJW/3v+IM0=;
        h=From:To:Subject:Date:From;
        b=hrrvJDmxWg0aK5bu7nPncxCNSQIAD3NWmgSD9SVrCQVW37t0q4O18/B4yvojBrg+g
         I041zwWiBKO5I1C81XlNOJ3fiZcFK6NluHk2VwLFojsaWoLuw3olEL1e9j2SbJmCoB
         CIHvKgmVrbAE09x1uMtDc6iI38UMMpYVBnEXPz1+WvXJl0SIvLlyCDqriKcDV6A/C9
         CBWgbrkN5A4pHdnUjDGxQt7dwtaS1wcnm8+aEpYIp40776RvrclvoHK6cNES8pM0yo
         bw1t2tHY3mZDroTNdHmw6DZ68bHHuufczok7D4WxpUOe5omgGv0ohN7/pE4AOVUeZD
         8y/fmO9yICXlA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: remove unused Speck definitions
Date:   Thu,  1 Dec 2022 19:55:29 -0800
Message-Id: <20221202035529.55992-1-ebiggers@kernel.org>
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

These old unused definitions were originally left around to prevent the
same mode numbers from being reused.  However, we've now decided to
reuse the mode numbers anyway.  So let's completely remove these old
unused definitions to avoid confusion.  There is no reason for any code
to be using these constants in any way; and indeed, Debian Code Search
shows no uses of them (other than in copies or translations of the
header).  So this should be perfectly safe.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/uapi/linux/fscrypt.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 47dbd1994bfe5..fd1fb0d5389d3 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -187,8 +187,6 @@ struct fscrypt_get_key_status_arg {
 #define FS_ENCRYPTION_MODE_AES_256_CTS	FSCRYPT_MODE_AES_256_CTS
 #define FS_ENCRYPTION_MODE_AES_128_CBC	FSCRYPT_MODE_AES_128_CBC
 #define FS_ENCRYPTION_MODE_AES_128_CTS	FSCRYPT_MODE_AES_128_CTS
-#define FS_ENCRYPTION_MODE_SPECK128_256_XTS	7	/* removed */
-#define FS_ENCRYPTION_MODE_SPECK128_256_CTS	8	/* removed */
 #define FS_ENCRYPTION_MODE_ADIANTUM	FSCRYPT_MODE_ADIANTUM
 #define FS_KEY_DESC_PREFIX		FSCRYPT_KEY_DESC_PREFIX
 #define FS_KEY_DESC_PREFIX_SIZE		FSCRYPT_KEY_DESC_PREFIX_SIZE
-- 
2.38.1

