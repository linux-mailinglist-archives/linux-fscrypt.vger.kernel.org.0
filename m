Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B275096AF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 07:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384317AbiDUF0v (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 01:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiDUF0u (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 01:26:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0728BDFAB;
        Wed, 20 Apr 2022 22:24:02 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q19so3722396pgm.6;
        Wed, 20 Apr 2022 22:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptNcYKMP2I9D0WN8B4M/VfkLKR53Y5iVYHD6TbxFc6U=;
        b=AMRwCG3nUp5EE4g2BNFxqtPdBy9Yg0bottvFQICBOguL5h9OvNn6Hj39qVPOjzcHMr
         43aH11zzpdSMiS9BOWbI0NNG235rOxztPsiPLTL/cnzmNCKrf5TqAUYZXN+Y1WjBG9wH
         lAoXmibJysiWlt8pWXpKtQzmyyKrqPfHr1beWhOYOs/e5+SPg8T5fMyPSABpOxfrj80y
         E/3vAKgsN0Z3uS3a2U8EoFZy/uo9cbOieH4zHOWK7EHg53JEPmGWBe/PxjOaZlySKgxV
         5vrIsNfln+R0SriuiUrjSNEIsPBF1NUZybp4XRBnAxytY0DdgQjqXGr+6mBxa4y0Qzjg
         vccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptNcYKMP2I9D0WN8B4M/VfkLKR53Y5iVYHD6TbxFc6U=;
        b=WZCdsgSHz6yDBp6tcbS4R3JiTG55nbItgapZEEI2Zsdcg6OmFtgGoMRH26462tHFfN
         PKn9peaeLAvKLhkzKQCIFHeLoHx0fT+XqrR1ITlZYBzAvTHsztAMqWbUj8qL5bIpf6Sn
         T13okfeZRUrKeu+3ig2xXW5trltyyo3a5yGeeE7u8gflGjU3Jg7HhCXK9H5dFJieD1h9
         JCPF3ccZziWIviIdp5xH5V7K8y6391NvYAYgJQt16Lz+aYYbQ+O5okxWdDysxPwhzynj
         dYWxRLgiMRcQtteyCVypVtsOEa/6Dr7QIHpuHwU77bIcXqjaHxfZyohX0mUfbnwxZw/h
         iQpQ==
X-Gm-Message-State: AOAM531sscWnD1MnSo6OUe7MtUKE3wRMwr3Eho5qycn8p/OMco+fR6P3
        xlXLLmShU1j3pfEtObZbpPlmRycy8IE=
X-Google-Smtp-Source: ABdhPJxvPyKtRGbVuOTSZ+N6NGcQgcjmTr2wqkxG6eA4SUPbQz95ybbMdKe+bPsN4nVgAXlH0g8J3Q==
X-Received: by 2002:a05:6a00:1702:b0:50a:8181:fed7 with SMTP id h2-20020a056a00170200b0050a8181fed7mr16955898pfc.56.1650518641551;
        Wed, 20 Apr 2022 22:24:01 -0700 (PDT)
Received: from localhost ([2406:7400:63:fca5:5639:1911:2ab6:cfe6])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm22787846pfc.190.2022.04.20.22.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 22:24:01 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC 6/6] ext4: Use provided macro for checking dummy_enc_policy
Date:   Thu, 21 Apr 2022 10:53:22 +0530
Message-Id: <7ae6e9b0e700b494bcf2c92250a601b513d7e0c6.1650517532.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1650517532.git.ritesh.list@gmail.com>
References: <cover.1650517532.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

We have a macro which test is dummy_enc_policy is enabled or not.
Use that instead.

Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e7e5c9c057d7..73fb54c3efd3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2685,7 +2685,7 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
 	 * it to be specified during remount, but only if there is no change.
 	 */
 	if ((ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION) &&
-	    is_remount && !sbi->s_dummy_enc_policy.policy) {
+	    is_remount && !DUMMY_ENCRYPTION_ENABLED(sbi)) {
 		ext4_msg(NULL, KERN_WARNING,
 			 "Can't set test_dummy_encryption on remount");
 		return -1;
-- 
2.31.1

