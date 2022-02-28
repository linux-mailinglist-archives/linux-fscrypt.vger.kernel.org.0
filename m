Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6864C6404
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiB1Hti (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiB1Htf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:49:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB4D3D1D3;
        Sun, 27 Feb 2022 23:48:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5FD1CE0FAF;
        Mon, 28 Feb 2022 07:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7850C340F1;
        Mon, 28 Feb 2022 07:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646034533;
        bh=saAwFH1FaLLdJFFEVyAhzNz7xcWflZ0a5XcegzPx/rs=;
        h=From:To:Cc:Subject:Date:From;
        b=FPZnksqEk9wAbFrqdMG9siRfXhsYw7zNgGA6+75HGF6LOvGxBmkxEcqPszI9IvTca
         dPh5lDQGatFjax5iX4f0ShpiiNE9aKn1xxPgM6cb8U668LZkO+y4yGesLQeNqUxt10
         CcSLwUo45oYN5lHADDPTd+zEihfx+IqACOuJbuAn3fjDyX+8Fpg4v+WnvSwGLEZp94
         fFyEovLWj83b/7ENzL71MYx/eVz3gfBdfWs8nSv0cXXg4s6ZokW8NhbPa8CeW25lcq
         n1RaULvduZStoc3D4LAzVGDJkfyuqAm/P4en/4NC5oxXX2Hf+tbTtfMiIbQGVWT+KC
         ACqrixdG/l8gw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [RFC PATCH 0/8] xfstests: test the fscrypt hardware-wrapped key support
Date:   Sun, 27 Feb 2022 23:47:14 -0800
Message-Id: <20220228074722.77008-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series adds xfstests for the "hardware-wrapped inline encryption
keys" feature which I've proposed adding to the kernel
(https://lore.kernel.org/linux-fscrypt/20220228070520.74082-1-ebiggers@kernel.org/T/#u).

This applies to the master branch of xfstests (commit 2ea74ba4e70b).

For now, the new tests just include ciphertext verification tests.
These are the most important type of test to have here, as they validate
the on-disk format, which must be gotten right from the start.  They
verify that all the cryptography is implemented correctly, including
both the parts handled by the hardware and the parts handled by the
kernel.  Naturally, to do their work they exercise the new UAPIs too.

For now this is an RFC, as the corresponding kernel patches have yet to
be applied.  Patches 1-5 are cleanups that could be applied earlier, but
I need to look them over again first and probably will resend them.

In any case, any reviews would be greatly appreciated!

I've verified that the new tests run and pass when all their
prerequisites are met, namely:                                                             
                                                                         
- Hardware supporting the feature must be present.  I tested this on the
  SM8350 HDK (note: this currently requires a custom TrustZone image);
  this hardware is compatible with both of IV_INO_LBLK_{64,32}.
- The kernel patches for hardware-wrapped key support must be applied.
- The filesystem must be ext4 or f2fs.
- The kernel must have CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y.
- The fscryptctl program must be available, and must have my patches for
  hardware-wrapped key support applied.  These can currently be found at
  https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys.

Eric Biggers (8):
  fscrypt-crypt-util: use an explicit --direct-key option
  fscrypt-crypt-util: refactor get_key_and_iv()
  fscrypt-crypt-util: add support for dumping key identifier
  common/encrypt: log full ciphertext verification params
  common/encrypt: verify the key identifiers
  fscrypt-crypt-util: add hardware KDF support
  common/encrypt: support hardware-wrapped key testing
  generic: verify ciphertext with hardware-wrapped keys

 common/config            |   1 +
 common/encrypt           | 149 +++++++++++--
 src/fscrypt-crypt-util.c | 454 ++++++++++++++++++++++++++++++++-------
 tests/generic/900        |  30 +++
 tests/generic/900.out    |   6 +
 tests/generic/901        |  30 +++
 tests/generic/901.out    |   6 +
 7 files changed, 579 insertions(+), 97 deletions(-)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out
 create mode 100755 tests/generic/901
 create mode 100644 tests/generic/901.out


base-commit: 2ea74ba4e70b546279896e2a733c8c7f4b206193
-- 
2.35.1

