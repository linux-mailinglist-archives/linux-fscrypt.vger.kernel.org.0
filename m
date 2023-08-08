Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A424C774621
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbjHHSx4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjHHSxh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:53:37 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EECA15A8D8;
        Tue,  8 Aug 2023 10:08:17 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 82A338353E;
        Tue,  8 Aug 2023 13:08:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514497; bh=1CtPCyW+9LFbA9Iwks8XlKITZk9CwP+wFLt76MORpo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wACjgxlnPyRb/0iqiMDNkZy37bXDBMBJsvVlG2FacwyVlYc9qtb9mHlA+chPR5CCK
         nrAJanEMkTZc0i4mwG87f4HTQ/7DsS7ukLWEk6ZuNrQrHCkU17vTHBGq/k+1HNSgXm
         8NNger2nA3PUHxiIAyXx/SFEIjl/jryudKmxeSbI1IHwXUUn5PpY9lEVeTsklHjC8U
         BOZj8iDueetAIl1tyfYhJWYUUe3DyCRWSuU0yN3LkqIJmC1KA7Zh8JDEdFuL/mxC0q
         +2zguRoD0I/EEYsPYVLKcP6/B3oHCHaPGFq5FJi3OOx8WMT2qvuF5pY5KYoGrdkcyK
         bLFAYAXdyNJdQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v6 1/8] fscrypt: move inline crypt decision to info setup
Date:   Tue,  8 Aug 2023 13:08:01 -0400
Message-ID: <f1f1a99ff06dd097990da72d343cadb391de0726.1691505830.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505830.git.sweettea-kernel@dorminy.me>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.41.0

