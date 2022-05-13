Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E95526D75
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 01:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiEMXVs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 May 2022 19:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiEMXVo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 May 2022 19:21:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6DD2FCAF8;
        Fri, 13 May 2022 16:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7338D60E16;
        Fri, 13 May 2022 23:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA8BC34100;
        Fri, 13 May 2022 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652484054;
        bh=FJqchHCORnLCNFnQpFOuuMgpj/VDBAVWYv8RiIVneO0=;
        h=From:To:Cc:Subject:Date:From;
        b=gYGehX9LGVfhole35UbJ26ARVUHQYtRlY1+6KlmRG7N80f4WNYdPxXYJsxLL7Rn2V
         mK7q4szQ3es5vfA5XLEtTUVXb9xgpbfvnRGeXD3YtoDqYam9kWJdTyJ6sddcNKN0Jh
         hUDpONKGKacqn9m+j6QvXmDZikJp+02XXYizcVmxWIDkhM/xdPaSMIoCntBYn1S9TB
         fgW5oT/wh2wuxHJekrufFjNVypS/tG6Uqwy29pj0hyDVA/1UbaQob+pszeB1/XmBZe
         TvlWQ/K3o6jkkIyh24tjAnPndxcqELqp5QeAbm0liNWvY8/1QahvOtrfQRTj9kRXpb
         aCwXDQTgK9kAw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v3 0/5] test_dummy_encryption fixes and cleanups
Date:   Fri, 13 May 2022 16:16:00 -0700
Message-Id: <20220513231605.175121-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series cleans up and fixes the way that ext4 and f2fs handle the
test_dummy_encryption mount option.

Some patches from v2 were already applied to the fscrypt and f2fs trees.
This series just includes the remaining patches.  Patches 1-2 can be
applied to the ext4 tree now.  The remaining patches will need to wait
until their prerequisites get merged via the fscrypt tree.

Changed from v2 (besides the omitted patches as mentioned above):
    - Split the parse_apply_sb_mount_options() fix into its own patch
    - Fixed a couple bugs in
      "ext4: fix up test_dummy_encryption handling for new mount API"

Eric Biggers (5):
  ext4: fix memory leak in parse_apply_sb_mount_options()
  ext4: only allow test_dummy_encryption when supported
  ext4: fix up test_dummy_encryption handling for new mount API
  f2fs: use the updated test_dummy_encryption helper functions
  fscrypt: remove fscrypt_set_test_dummy_encryption()

 fs/crypto/policy.c      |  13 ---
 fs/ext4/ext4.h          |   6 --
 fs/ext4/super.c         | 180 +++++++++++++++++++++++-----------------
 fs/f2fs/super.c         |  29 +++++--
 include/linux/fscrypt.h |   2 -
 5 files changed, 124 insertions(+), 106 deletions(-)

-- 
2.36.1

