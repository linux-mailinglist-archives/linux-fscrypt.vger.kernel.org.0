Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080306C0478
	for <lists+linux-fscrypt@lfdr.de>; Sun, 19 Mar 2023 20:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCSTjg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 19 Mar 2023 15:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCSTj3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 19 Mar 2023 15:39:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C3F11E87;
        Sun, 19 Mar 2023 12:39:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23FF861166;
        Sun, 19 Mar 2023 19:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E61EC433EF;
        Sun, 19 Mar 2023 19:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679254743;
        bh=wOFl1sorqP7Hib+xYi2OZdOJlqgfvdW/EjWY9nlzE3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnM1JSCU1gPgGaK9fpb5UjGxqZBWXUq2MzWKOeQi2k4//FcJqZyCDRfycnXaCUbuv
         zuVvaQ6TH0bP43nO+jgcrMfn6QVMqRvQUdXyLcMuFdNzjMKOUaf1ZATotYMyHxlYkr
         W2sqIKEgidLg9tuc4uuO/IBObTyAUIv8Zw2w9gXENnJdp0QdroCQp3HO35hTHNP58K
         jYeOyv43yzLCAcFnLu9Y0OutC3XB+Gwaog4cmZjWiY/u4R7afR/XsDQXA2AZ4hrrNA
         yU/Ia0EFDau/9O14Xaxg7W/uvR8mK3jXhonqavjyjnTXZyERYL57BPYPC5swdWxJ3K
         KrJpllbmntiSQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 1/3] fscrypt-crypt-util: fix HKDF self-test with latest OpenSSL
Date:   Sun, 19 Mar 2023 12:38:45 -0700
Message-Id: <20230319193847.106872-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230319193847.106872-1-ebiggers@kernel.org>
References: <20230319193847.106872-1-ebiggers@kernel.org>
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

In OpenSSL 3.0, EVP_PKEY_derive() fails if the output is zero-length.
Therefore, update test_hkdf_sha512() to not test this case.

This only affects the algorithm self-tests within fscrypt-crypt-util,
which are not compiled by default.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 087ae09a..4bb4f4e5 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -975,7 +975,9 @@ static void test_hkdf_sha512(void)
 		size_t ikmlen = 1 + (rand() % sizeof(ikm));
 		size_t saltlen = rand() % (1 + sizeof(salt));
 		size_t infolen = rand() % (1 + sizeof(info));
-		size_t outlen = rand() % (1 + sizeof(actual_output));
+		// Don't test zero-length outputs, since OpenSSL 3.0 and later
+		// returns an error for those.
+		size_t outlen = 1 + (rand() % sizeof(actual_output));
 
 		rand_bytes(ikm, ikmlen);
 		rand_bytes(salt, saltlen);
-- 
2.40.0

