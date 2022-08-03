Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED15B589479
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Aug 2022 00:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbiHCWll (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Aug 2022 18:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiHCWlk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Aug 2022 18:41:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCF8167E6
        for <linux-fscrypt@vger.kernel.org>; Wed,  3 Aug 2022 15:41:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3225b644be1so153340537b3.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 03 Aug 2022 15:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=S0/vw0Nl67oHNQJ7Nte4HHrn/ydSAQzvDvRWkCxsVwg=;
        b=fizuI03MKx7Hqdzk03+NQOEGQuKC7s8Z+MB/3OmUIIImCRdZmY2Vfp0uxufA73M5jC
         j8abPbZstQoWhsS2yih16vdwhjSQdfcfvKnDafSHlrtmXzc+lJviMfFYowqM2Y/fTy/J
         zVrnJ8D/NUgzDlU5JqQop84Slq74yS6snL+GrLwbG8fHUih8dEQx+bcNJjf2VVhZWPGk
         m5JyI1sYUP2LLj4e55/XhQ6lzb5JzDvI/AS+qTZNAF4pOKOGvmh+VmVtq3bD4WYntkJc
         1tG3iAvSOBthFIVvBM2EiSAtuU0owJHoRG5gT04zlERB7sbLGNZyq2aBLRNG+XIw1lWv
         FmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=S0/vw0Nl67oHNQJ7Nte4HHrn/ydSAQzvDvRWkCxsVwg=;
        b=6Lqx+Gb7u4gLwHW0jl72b1FgVMH+mF2B+TyX1Q7rgsmB5JWAT5JRd7jcqEmFpwme/b
         s2dOGFExGkVyk0Zp4sOPeeZJuvdrn6vxw5xeARq7cwdP+GKWMlIukykUPEtU6tQqCZHp
         XH5UV2CvWJQynhIBlXo14Z7i4Ly+TfTcGXpbpkUZBbZzvr9NvXn2dzd2HsJJi7dcpeO/
         mFY1voUa1vIufWkWiefAgdQJk8Zvjn3hcC3BUK8UpVYhk49W7yugq1ZBYqVwYP6OxTtJ
         MO2rNV5okHLZExJID2C0N4tn3C/Fn+Fd5PXqBRpmfFIkCIYeOT4T/1UQSGMKi8pXPagB
         UwRQ==
X-Gm-Message-State: ACgBeo3xBeSyGC3HcgWiHW4DmjaOJyVtTZgSSTKQ9JPc0sa5/u2Kmbp+
        BGF/Ui9kIwx1ZAIlj7+W11zDXuaQ5w==
X-Google-Smtp-Source: AA6agR4DFWEUuN06cJE7eMjWK5wXU7KQugMPBPvdHcXkoW0A97qz2kX0sUYnV1JGfRpli9LrzOpYKrIADA==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a81:b613:0:b0:31f:4324:7bf9 with SMTP id
 u19-20020a81b613000000b0031f43247bf9mr25393496ywh.408.1659566498546; Wed, 03
 Aug 2022 15:41:38 -0700 (PDT)
Date:   Wed,  3 Aug 2022 15:41:19 -0700
Message-Id: <20220803224121.420705-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH v5 0/2] generic: test HCTR2 filename encryption
From:   Nathan Huckleberry <nhuck@google.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset is not intended to be accepted yet.  It is reliant on HCTR2
support in the kernel which has not yet been accepted.  See the HCTR2 patchset
here: https://lore.kernel.org/all/20220520181501.2159644-1-nhuck@google.com/

HCTR2 is a new wide-block encryption mode that can used for filename encryption
in fscrypt.  This patchset adds a reference implementation of HCTR2 to the
fscrypt testing utility and adds tests for filename encryption with HCTR2.

More information on HCTR2 can be found here: "Length-preserving encryption with
HCTR2": https://ia.cr/2021/1441

Changes in v5:
* Added links to relevant references for POLYVAL and HCTR2
* Removed POLYVAL partial block handling
* Referenced HCTR2 commit in test

Changes in v4:
* Add helper functions for HCTR2 hashing
* Fix accumulator alignment bug
* Small style fixes

Changes in v3:
* Consolidate tests into one file

Changes in v2:
* Use POLYVAL multiplication directly instead of using GHASH trick
* Split reference implementation and tests into two patches
* Remove v1 policy tests
* Various small style fixes

Nathan Huckleberry (2):
  fscrypt-crypt-util: add HCTR2 implementation
  generic: add tests for fscrypt policies with HCTR2

 common/encrypt           |   2 +
 src/fscrypt-crypt-util.c | 358 ++++++++++++++++++++++++++++++++-------
 tests/generic/900        |  31 ++++
 tests/generic/900.out    |  16 ++
 4 files changed, 350 insertions(+), 57 deletions(-)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

-- 
2.37.1.455.g008518b4e5-goog

