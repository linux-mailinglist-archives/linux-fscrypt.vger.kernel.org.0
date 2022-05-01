Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1F6516206
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 07:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbiEAFY6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 01:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241129AbiEAFYx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 01:24:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFC813D4A;
        Sat, 30 Apr 2022 22:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AB0DB80CB7;
        Sun,  1 May 2022 05:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6D0C385A9;
        Sun,  1 May 2022 05:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651382486;
        bh=jqXB6Jkq9HrDfu4rbkwhKs3qEhNsFNKmueB2odaCHew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZXy0A8ysk0ShzbALiZZJWmt/Y/PUvx93pim0D8oXHV+wX7dB7BDoCtumgSj+bwhu
         w8MDeR7PBQkGwx036fWilzUoE37oMZHUdKOeJzjXVJxCHs0hGWeQDUrNwENRTu0xSP
         zSUGZmXbj6Ii0RVfkOhy0cqE8qjUkhjX++/gs07zDW8DnNVnI1ANr7v5E46VTZKdY5
         iKgGUn/y5A5LxerpOlUETfiQH1HGUZWPD8KCqc/SSTU+ZpEMzRDSMnuZ2/GvwyYofj
         bO+SbXhh0+DyWuV3INC09myXanTsYd05mb40xfz2UecOh9OIZXxgh7p4UGV0PDtFIk
         kbg4ZIFliKSIw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: [xfstests PATCH 2/2] ext4/053: test changing test_dummy_encryption on remount
Date:   Sat, 30 Apr 2022 22:19:28 -0700
Message-Id: <20220501051928.540278-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220501051928.540278-1-ebiggers@kernel.org>
References: <20220501051928.540278-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The test_dummy_encryption mount option isn't supposed to be settable or
changeable via a remount, so add test cases for this.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/ext4/053 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/ext4/053 b/tests/ext4/053
index 84f3eab9..3d530953 100755
--- a/tests/ext4/053
+++ b/tests/ext4/053
@@ -686,6 +686,9 @@ for fstype in ext2 ext3 ext4; do
 		mnt test_dummy_encryption=v2
 		not_mnt test_dummy_encryption=bad
 		not_mnt test_dummy_encryption=
+		# Can't be set or changed on remount.
+		mnt_then_not_remount defaults test_dummy_encryption
+		mnt_then_not_remount test_dummy_encryption=v1 test_dummy_encryption=v2
 		do_mkfs -O ^encrypt $SCRATCH_DEV ${SIZE}k
 	fi
 	not_mnt test_dummy_encryption
-- 
2.36.0

