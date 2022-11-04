Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB5861A2D3
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 21:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKDU7T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 16:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDU7S (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 16:59:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FC93E0AB;
        Fri,  4 Nov 2022 13:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BB8DB82F9E;
        Fri,  4 Nov 2022 20:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC46CC433B5;
        Fri,  4 Nov 2022 20:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667595553;
        bh=z2Z7oAEeLI3ZtcvGG/yWA4vtLSrNDZaa0EypXjklsjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjUcRwpkGlPpEIz74z0t9I6dvVM6yO0LF6aaryuceMVy0Y9d0kLYaqwIkSPXTYFen
         aowiybg5vAb3ysHTcK+2IGtJuHvYKfQrfAlK8hTTLSeWu3C2d21KQNQt1687FVkbIB
         L/mPCkIkC/cc2Nis4s6RgIdWLxyxAML1tq03Xs1E7UFEd29U1Sh4wM/8hghKLNZl3V
         hd7QThj/DAgyo6HmeN5v9RdcKTNqRf3lFOlZaE7IhplGwOZ5CyC1kD0RJ4eRPJ97xN
         rTOByCiNMZTgkOEIHuTpkSc0Fiohb5hNYds2Wx0Yx4Mx3GsGzPcxuMzbVhd7qXRy+Z
         EnTjLKwKUS6NQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Andrey Albershteyn <aalbersh@redhat.com>
Subject: [xfstests PATCH v2 2/3] generic/577: add missing file removal before empty file test
Date:   Fri,  4 Nov 2022 13:58:29 -0700
Message-Id: <20221104205830.130132-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104205830.130132-1-ebiggers@kernel.org>
References: <20221104205830.130132-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The fix for _fsv_have_hash_algorithm() exposed a bug where one of the
test cases in generic/577 isn't deleting the file from the previous test
case before it tries to write to it.  That causes a failure, since due
to the fix for _fsv_have_hash_algorithm(), the file from the previous
test case now ends up with verity enabled and therefore cannot be
written to.  Fix this by deleting the file.

Reported-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/577 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/577 b/tests/generic/577
index 98c3888f..5f7e0573 100755
--- a/tests/generic/577
+++ b/tests/generic/577
@@ -121,6 +121,7 @@ if _fsv_have_hash_algorithm sha512 $fsv_file; then
 fi
 
 echo -e "\n# Testing empty file"
+rm -f $fsv_file
 echo -n > $fsv_file
 _fsv_sign $fsv_file $sigfile.emptyfile --key=$keyfile --cert=$certfile | \
 		_filter_scratch
-- 
2.38.1

