Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C537C7D96
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Oct 2023 08:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjJMGRe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Oct 2023 02:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJMGRe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Oct 2023 02:17:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF9595;
        Thu, 12 Oct 2023 23:17:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275CEC433C8;
        Fri, 13 Oct 2023 06:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697177851;
        bh=Y2nRxDCSuhkznRPXdeWCkaxbTh12MTpQtizlDW24RAo=;
        h=From:To:Cc:Subject:Date:From;
        b=boeUJp6iNRWXcEotnbkgQpHPeDxJslI74oeF2CBy4Hy99Dvwh9RemPBaZVb7hXDJH
         Aq5qb5Xzu4qYyXF0aRm2eMV/3ZtE3efnu/WudFjrxxL97lV405HB2uogQOXDvQRzhP
         OUSdo5w4S7WoWWKPJ5e7alFnapw/U8+LNzZ15nDbPeQMdmGFZzxUBN1BZQ+Jbx80Jy
         U+nqAvG3BzvIkG0yefpMGZREWZu3AfqT20VgPo3MnbTmWhZokjrLasZTxG2KsKRpKb
         tbVaOlw6OfTMhJ1fgJm+bynOPfHJBL1Vp0T05s9BXStTjwUWhdFdhbES2g1j5ZFWl8
         CBcqU30/NfugQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 0/4] xfstests: test custom crypto data unit size
Date:   Thu, 12 Oct 2023 23:13:59 -0700
Message-ID: <20231013061403.138425-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series adds a test for the functionality introduced by the kernel
patch
"fscrypt: support crypto data unit size less than filesystem block size"
(https://lore.kernel.org/linux-fscrypt/20230925055451.59499-6-ebiggers@kernel.org/).
It is a ciphertext verification test, as opposed to general I/O test.

This feature is not yet in mainline, but I've applied it for 6.7.

The test depends on an xfsprogs patch that adds the '-s' option to the
set_encpolicy command of xfs_io, allowing the new log2_data_unit_size
field to be set via a shell script.

As usual, the test skips itself when any prerequisite isn't met.

Eric Biggers (4):
  fscrypt-crypt-util: rename block to data unit
  common/rc: fix _require_xfs_io_command with digits in argument
  common/encrypt: support custom data unit size
  generic: add test for custom crypto data unit size

 common/encrypt           | 42 +++++++++++++-----
 common/rc                |  2 +-
 src/fscrypt-crypt-util.c | 93 ++++++++++++++++++++--------------------
 tests/f2fs/002           |  6 +--
 tests/generic/900        | 27 ++++++++++++
 tests/generic/900.out    | 11 +++++
 6 files changed, 121 insertions(+), 60 deletions(-)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out


base-commit: 59299b65ac8f15935ab45e7920cbfda8a6beffd1
-- 
2.42.0

