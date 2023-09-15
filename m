Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8857A1283
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Sep 2023 02:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjIOAsx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Sep 2023 20:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjIOAsx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Sep 2023 20:48:53 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F1626B8
        for <linux-fscrypt@vger.kernel.org>; Thu, 14 Sep 2023 17:48:48 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-41369b80875so7824541cf.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 14 Sep 2023 17:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1694738928; x=1695343728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bSsw3kwNV2Q9tcAcIVNmcgfQVqfl/ZZCUb/AkTd/jI4=;
        b=ExgVbjwMaQlYGE0q7Zi0ppl1lFwX1cq4ms2E0xS1rmdH+BMU26xHCwFMBhQ0IW5/xX
         5T8K5OZUvlwzbvjLGt+3DGtnQ0lSJFhFu8Z9rfUQ/lNTXZ4ZYYdSjTlMs7OStC54ASZn
         KXIZ7bWMwNLQk0EAvij2XlfL/ML44q3WyzMSQeWMiUIWpRCCA/keWf9eqxGp8YL8/aQl
         sT5eb+Q2qqZcZ6fDpH+QSxRO5ARaJp4+l/FOL3rL1gwGQ9/Uiu5pyvsSxX5DRdSoaugC
         zw6Il8DxWVNL1VTwPZTaK4Owsn2+ua3CDDWXc8lOypM7/9O0yH1I5rQQQaPteF/q3k1Y
         VPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694738928; x=1695343728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bSsw3kwNV2Q9tcAcIVNmcgfQVqfl/ZZCUb/AkTd/jI4=;
        b=plkkBWHjaKuYKDQlY5rGZmgQgvPTqjkZpovErXt6IvujCk9V4Aytm6/gNi5zg9hrtR
         Vxv5gA3evaVuhMV9Lv5uUsT4ktHyloYaEeZksPt8qUcu7c5IFy1qSzU4CBabk52n/z/t
         bQPLg05CUpCamGthRZHDis9sErGGPiHNcT2b+JxRDhJUYDfVhetI8T64Xdf7ZdOHQvt/
         yfgyAJIhydp2UQKYgnWn5q2vQeRgjOSB3AoeaAFHx9cPorjhugxxMOx05xkGHw77U3NR
         bRbFykEv6UPK7dS90P2PI3g5F/aPIFb9EVlbpQ8d/EaTs8HKDjBUYWIIP4IFRMmeQh/M
         EiTw==
X-Gm-Message-State: AOJu0Yx7SJQLuqo/+rM54B2crYxsLykuk5bqm0hQoeUySWMGpfOWP8/E
        CwlNA389yUxrsej5NKEDunAMqw==
X-Google-Smtp-Source: AGHT+IEkahJWjR1CwuX/xoH5Yipk+ZjMcvjwbxUY4s6qjKigRwSP0u5YyRM3coQml3No7Ce9xU4sHg==
X-Received: by 2002:ac8:4e44:0:b0:412:c81:eff3 with SMTP id e4-20020ac84e44000000b004120c81eff3mr4666642qtw.15.1694738927838;
        Thu, 14 Sep 2023 17:48:47 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id h11-20020ac8138b000000b00407ffb2c24dsm811866qtj.63.2023.09.14.17.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 17:48:47 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        clm@fb.com, ebiggers@kernel.org, ngompa13@gmail.com,
        sweettea-kernel@dorminy.me, kernel-team@meta.com
Subject: [RFC PATCH 0/4] fscrypt: add support for per-extent encryption
Date:   Thu, 14 Sep 2023 20:47:41 -0400
Message-ID: <cover.1694738282.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This is meant as a replacement for the last set of patches Sweet Tea sent [1].
This is an attempt to find a different path forward.  Strip down everything to
the basics.  Essentially all we appear to need is a nonce, and then we can use
the inode context to derive per-extent keys.

I'm sending this as an RFC to see if this is a better direction to try and make
some headway on this project.  The btrfs side doesn't change too much, the code
just needs to be adjusted to use the new helpers for the extent contexts.  I
have this work mostly complete, but I'm afraid I won't have it ready for another
day or two and I want to get feedback on this ASAP before I burn too much time
on it.

Additionally there is a callback I've put in the inline block crypto stuff that
we need in order to handle the checksumming.  I made my best guess here as to
what would be the easiest and simplest way to acheive what we need, but I'm open
to suggestions here.

The other note is I've disabled all of the policy variations other than default
v2 policies if you enable extent encryption.  This is for simplicity sake.  We
could probably make most of it work, but reflink is basically impossible for v1
with direct key, and is problematic for the lblk related options.  It appears
this is fine, as those other modes are for specific use cases and the vast
majority of normal users are encouraged to use normal v2 policies anyway.

This stripped down version gives us most of what we want, we can reflink between
different inodes that have the same policy.  We lose the ability to mix
differently encrypted extents in the same inode, but this is an acceptable
limitation for now.

This has only been compile tested, and as I've said I haven't wired it
completely up into btrfs yet.  But this is based on a rough wire up and appears
to give us everything we need.  The btrfs portion of Sweet Teas patches are
basically untouched except where we use these helpers to deal with the extent
contexts.  Thanks,

Josef

[1] https://lore.kernel.org/linux-fscrypt/cover.1693630890.git.sweettea-kernel@dorminy.me/

Josef Bacik (4):
  fscrypt: rename fscrypt_info => fscrypt_inode_info
  fscrypt: add per-extent encryption support
  fscrypt: disable all but standard v2 policies for extent encryption
  blk-crypto: add a process bio callback

 block/blk-crypto-fallback.c |  18 ++++
 block/blk-crypto-profile.c  |   2 +
 block/blk-crypto.c          |   6 +-
 fs/crypto/crypto.c          |  23 +++--
 fs/crypto/fname.c           |   6 +-
 fs/crypto/fscrypt_private.h |  78 ++++++++++++----
 fs/crypto/hooks.c           |   2 +-
 fs/crypto/inline_crypt.c    |  50 +++++++++--
 fs/crypto/keyring.c         |   4 +-
 fs/crypto/keysetup.c        | 174 ++++++++++++++++++++++++++++++++----
 fs/crypto/keysetup_v1.c     |  14 +--
 fs/crypto/policy.c          |  45 ++++++++--
 include/linux/blk-crypto.h  |   9 +-
 include/linux/fs.h          |   4 +-
 include/linux/fscrypt.h     |  41 ++++++++-
 15 files changed, 400 insertions(+), 76 deletions(-)

-- 
2.41.0

