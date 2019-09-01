Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FCAA494C
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Sep 2019 14:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfIAM3h (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Sep 2019 08:29:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41468 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfIAM3h (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Sep 2019 08:29:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so652775pfo.8;
        Sun, 01 Sep 2019 05:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7pFKxrn4Tag5NCFVJvyKYGSRNOxqJ2kUh7j9Lq98bjY=;
        b=dqO9BF2TVmNHGoEZKYxghJdVTn4ANhsY3kfOm+cO30nRJ0J1ZVrMHLYMXU/MfxL2gN
         QMp1rjVEIdClA5XBdNYHgvEPetH0AtMrsdMtJh0PDIYPUU7LH1mzw4H2zSEqEtIyo1/u
         McNcTAqK9CvXyXGsiejr7SZpv5aWnlXaA1ePG7oVbwR/HZ73qsRYPcb+yF+lglDEEO1W
         Q932DDorpqHspPRxo64bUfBGN+KvR0Ux+DsqZAHf6LEH1Du45P69pTcZxkPnWQ5uLUIP
         SAZO+fMtHbVeps/epsqg8Jz+vwX5dprt3fEn9iJOJDqIuiQseAreZNjecIXUqIHUB1MJ
         2zBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7pFKxrn4Tag5NCFVJvyKYGSRNOxqJ2kUh7j9Lq98bjY=;
        b=NkYjYMjqWvkESgCg8Gw1Qs8gtM7YktQ1a/TzHP0pDUNuJ7XQPsMlbcDeTCNk93UQLZ
         HpiFLxCaNeBjyyPcWaf5H2i5nOJwb6167QoRi2ZVHjppoqxvPmcJLTVmdnt9BICVC5G+
         PT3ZceSN1Q302LwKT5Ap/clIQXSvSpVEiN2shXNlb+lzz+emB8OBReFwIket2+QjB1hw
         r/f/kgk1L9g9uQguTYsZ4GGqm2Yw3NxnkCaeqO0qHx00A0X6aWYQcwSBlixlXyXdJ21L
         /mxC3L2cHPNcNYLvUcucOu02w7qih+CxAgDdtLnSL8actAxVLaJgmhyDAwW5aREyaBc/
         Ko3g==
X-Gm-Message-State: APjAAAVwDAEwBIcJ9RttCj24JdRAYCsmOY3jxXlKXcsY2k8zssKe13Az
        UAQjGvpZgtZDAKvRT3jbbn8=
X-Google-Smtp-Source: APXvYqzJ8bd/MgQEddCLwY/rXwtwPsjcXNpY488Z1MNE+lufMZjEWOV0TncUO7jWQlQXNvKjQnb4Gg==
X-Received: by 2002:aa7:920b:: with SMTP id 11mr28221516pfo.231.1567340976248;
        Sun, 01 Sep 2019 05:29:36 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id z13sm2691454pfq.121.2019.09.01.05.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2019 05:29:35 -0700 (PDT)
Date:   Sun, 1 Sep 2019 20:29:29 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] xfstests: add tests for fscrypt key management
 improvements
Message-ID: <20190901122926.GF2622@desktop>
References: <20190812175809.34810-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812175809.34810-1-ebiggers@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 12, 2019 at 10:58:00AM -0700, Eric Biggers wrote:
> Hello,
> 
> This patchset adds xfstests for the kernel patchset
> "[PATCH v8 00/20] fscrypt: key management improvements"
> https://lkml.kernel.org/linux-fsdevel/20190805162521.90882-1-ebiggers@kernel.org/T/#u
> 
> These tests test the new ioctls for managing filesystem encryption keys,
> and they test the new encryption policy version.
> 
> These tests depend on new xfs_io commands, for which I've sent a
> separate patchset for xfsprogs.
> 
> Note: currently only ext4, f2fs, and ubifs support encryption.  But I
> was told previously that since the fscrypt API is generic and may be
> supported by XFS in the future, the command-line wrappers for the
> fscrypt ioctls should be in xfs_io rather than in fstests directly
> (https://marc.info/?l=fstests&m=147976255831951&w=2).
> 
> We'll want to wait for the kernel patches to be mainlined before merging
> this, but I'm making it available now for any early feedback.
> 
> This version of the xfstests patchset can also be retrieved from tag
> "fscrypt-key-mgmt-improvements_2019-08-12" of
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git

Sorry for getting so long to review this patchset. The patches all look
in a good shape to me, thanks a lot! Please see the reply to patch "3/9"
for the only minor issues I noticed.

But it'd be really helpful if other fscrypt folks could help review the
new tests!

Thanks,
Eryu

> 
> Eric Biggers (9):
>   common/encrypt: disambiguate session encryption keys
>   common/encrypt: add helper functions that wrap new xfs_io commands
>   common/encrypt: support checking for v2 encryption policy support
>   common/encrypt: support verifying ciphertext of v2 encryption policies
>   generic: add basic test for fscrypt API additions
>   generic: add test for non-root use of fscrypt API additions
>   generic: verify ciphertext of v2 encryption policies with AES-256
>   generic: verify ciphertext of v2 encryption policies with AES-128
>   generic: verify ciphertext of v2 encryption policies with Adiantum
> 
>  common/encrypt           | 180 +++++++++++++++++++----
>  src/fscrypt-crypt-util.c | 304 ++++++++++++++++++++++++++++++++++-----
>  tests/ext4/024           |   2 +-
>  tests/generic/397        |   4 +-
>  tests/generic/398        |   8 +-
>  tests/generic/399        |   4 +-
>  tests/generic/419        |   4 +-
>  tests/generic/421        |   4 +-
>  tests/generic/429        |   8 +-
>  tests/generic/435        |   4 +-
>  tests/generic/440        |   8 +-
>  tests/generic/800        | 127 ++++++++++++++++
>  tests/generic/800.out    |  91 ++++++++++++
>  tests/generic/801        | 136 ++++++++++++++++++
>  tests/generic/801.out    |  62 ++++++++
>  tests/generic/802        |  43 ++++++
>  tests/generic/802.out    |   6 +
>  tests/generic/803        |  43 ++++++
>  tests/generic/803.out    |   6 +
>  tests/generic/804        |  45 ++++++
>  tests/generic/804.out    |  11 ++
>  tests/generic/group      |   5 +
>  22 files changed, 1018 insertions(+), 87 deletions(-)
>  create mode 100755 tests/generic/800
>  create mode 100644 tests/generic/800.out
>  create mode 100755 tests/generic/801
>  create mode 100644 tests/generic/801.out
>  create mode 100755 tests/generic/802
>  create mode 100644 tests/generic/802.out
>  create mode 100755 tests/generic/803
>  create mode 100644 tests/generic/803.out
>  create mode 100755 tests/generic/804
>  create mode 100644 tests/generic/804.out
> 
> -- 
> 2.23.0.rc1.153.gdeed80330f-goog
> 
