Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B70565A8FA
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjAAFNt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjAAFNr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:47 -0500
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B1D63FB
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:45 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BB7C88264D;
        Sun,  1 Jan 2023 00:06:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549613; bh=wmLSBF1zgWOIZsmv1JCB3t+Rhraqtpxnys1RB8QVAco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4V8NBvtT8pCpAHwMyrbaV6lFpLY8wyImJXpTjmuMrkZNglylYIF7g/ASCWJ6u0yO
         hzTyV9FRVPYh2sooEt1WLKX1j086vYHDpzdpqqNH97CFoM0B1lgJZ56kPss81VrWYJ
         o4tbPs7PCVkItjhBNN/MU0vp4VO+graG7mIHNOkSDdBYgDOfSCWa+73ltBZ/LCRJZ2
         JX81K+CNuqpfF1mEsKlQkPxBACeRrjD/JT79r+LRfF164ZCYD6JVGWBQPCaZUp/1Y8
         wTO5B/A99kSHikejqrLiKpFAhir+O506us0EkRbmg0k8B9EXrsBIGTSEMhXLo58Plz
         +ah21spZH2HJg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 12/17] fscrypt: notify per-extent infos if master key vanishes
Date:   Sun,  1 Jan 2023 00:06:16 -0500
Message-Id: <6e98cad3640444193ac886267eca0f0a62ea9db0.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

When fscrypt_infos can be owned by an extent instead of an inode, a
new method of evicting the per-extent info for a key being removed is
needed. This change adds removal handling to per-extent infos for master
key removal.

This seems racy to me and I'd love to find a better way to do this, but
I can't think of it.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keyring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 846f480da081..0c4e917a5281 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -886,6 +886,13 @@ static void evict_dentries_for_decrypted_objects(struct fscrypt_master_key *mk)
 
 	list_for_each_entry(ci, &mk->mk_active_infos, ci_master_key_link) {
 		inode = ci->ci_inode;
+		if (!inode) {
+			spin_unlock(&mk->mk_active_infos_lock);
+			ci->ci_sb->s_cop->forget_extent_info(ci->ci_info_ptr);
+			spin_lock(&mk->mk_active_infos_lock);
+			continue;
+		}
+
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
 			spin_unlock(&inode->i_lock);
-- 
2.38.1

