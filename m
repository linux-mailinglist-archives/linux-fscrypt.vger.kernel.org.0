Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6813619163
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 07:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiKDGsp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 02:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiKDGsA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 02:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76E32B266;
        Thu,  3 Nov 2022 23:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72F07B82B45;
        Fri,  4 Nov 2022 06:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1278CC433D7;
        Fri,  4 Nov 2022 06:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667544476;
        bh=dJSEu0lKsb2RDpf3fl/Ist4zPInufhx9O+WauiS9WhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjlxH85/NedKsuXVnTkh8+1DAbK841cz34G0JMLTMQkBycZtiQkCUtvCPrG7abf2N
         smMozBoqA5oNlXbHDNXQgsd1YQETmSbDRLjuDL7cyduxqxE5OikAaArXtr3CVJZMV+
         gxR8w3NQpbN1Z+b32RSTntRtV12QKFQhbEPeF5N3bLREHiH/KOzmpivKLAhlQkSW1C
         lRebOtSFZjB5nnEMqFwsmDnABkmsUrsz4YuAFkWPhK6pIfI6AofTp+vUDp11JvuPR+
         VlAwl40mg+EzaZu4jwHbqe1qoW7cSF8Juy49X2ZopNzzriOUQXYCB/bczlG80iUHij
         Gg5dCuGhtFkQw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-fscrypt@vger.kernel.org
Subject: [xfstests PATCH 2/3] generic/577: add missing file removal before empty file test
Date:   Thu,  3 Nov 2022 23:47:41 -0700
Message-Id: <20221104064742.167326-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104064742.167326-1-ebiggers@kernel.org>
References: <20221104064742.167326-1-ebiggers@kernel.org>
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

