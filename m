Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD68C6DCBB1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 21:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDJTkY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 15:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJTkX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 15:40:23 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00EC10D7
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 12:40:22 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D7BF88023A;
        Mon, 10 Apr 2023 15:40:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681155622; bh=ICxqBiWWNIPjhSuPacp2YUBjYU78VvV6ho2HQWm0wWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuDA7DZML2GdHVNha88qeSkvqxA+VqKKH9HD+nvDctL+aUheOSGti2UpTMH8lH3s9
         iyIWMnPydke36+I7KyURlrqa7kZioAF49e55lmsru2H/slAlfEvgyvQx4wKIiO+ZEL
         RL9Ot3f1U/yqRsi/ehZr5J8P33pupBaz9G6LGQvALO7G503Dv0jzjDxsBUcLJ7b9VG
         zNYyrSFhtFUjXT+v6Sh77+4vH9mB/HbCdjJNzi7zd0DXr5OyFhyewW7oB4xr/4t5zV
         +qLh+V78AA4wDpeSZT/i6Pki0HYg/kbK1Yr+1q/teRsVz/P++hutP7w400u5w94/8R
         unBzHNk93XnjQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 01/11] fscrypt: move inline crypt decision to info setup.
Date:   Mon, 10 Apr 2023 15:39:54 -0400
Message-Id: <ccdc0954569bd439492e26912616247751ee6cde.1681155143.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681155143.git.sweettea-kernel@dorminy.me>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

setup_file_encryption_key() is doing a lot of things at the moment --
setting the crypt_info's inline encryption bit, finding and locking a
master key, and calling the functions to get the appropriate prepared
key for this info. Since setting the inline encryption bit has nothing
to do with finding the master key, it's easy and hopefully clearer to
select the encryption implementation in fscrypt_setup_encryption_info(),
the main fscrypt_info setup function, instead of in
setup_file_encryption_key() which will long-term only deal in setting
up the prepared key for the info.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 361f41ef46c7..b89c32ad19fb 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -443,10 +443,6 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	struct fscrypt_master_key *mk;
 	int err;
 
-	err = fscrypt_select_encryption_impl(ci);
-	if (err)
-		return err;
-
 	err = fscrypt_policy_to_key_spec(&ci->ci_policy, &mk_spec);
 	if (err)
 		return err;
@@ -580,6 +576,10 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	WARN_ON_ONCE(mode->ivsize > FSCRYPT_MAX_IV_SIZE);
 	crypt_info->ci_mode = mode;
 
+	res = fscrypt_select_encryption_impl(crypt_info);
+	if (res)
+		goto out;
+
 	res = setup_file_encryption_key(crypt_info, need_dirhash_key, &mk);
 	if (res)
 		goto out;
-- 
2.40.0

