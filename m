Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57753E223B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 23 Oct 2019 20:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733023AbfJWSAj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Oct 2019 14:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732839AbfJWSAj (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Oct 2019 14:00:39 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 943DA2086D;
        Wed, 23 Oct 2019 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571853638;
        bh=ZFgiT3OjAKq+CRzK7V4UjYE5iaOaPGhTFyBjKIw1MvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y/w3tJFxi5WrI31jxu610TsjOEaJYZ2EmI9YVzq8sqEWHJIy1yfY1SvuNWh+fePqG
         JNpO1QMDSKhLVmvtzWnsNhaE38rthyCdYWG3dcFoaX+mKEYoR8YQuXnHmCjNhf4vyE
         YM7//DFZz6f2MLuW5Ng7yRfTLIFZPURHb0unC7GM=
Date:   Wed, 23 Oct 2019 11:00:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 0/9] xfstests: add tests for fscrypt key management
 improvements
Message-ID: <20191023180035.GA208503@gmail.com>
Mail-Followup-To: fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <20191015181643.6519-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015181643.6519-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 15, 2019 at 11:16:34AM -0700, Eric Biggers wrote:
> Hello,
> 
> This patchset adds xfstests for the new fscrypt functionality that was
> merged for 5.4 (https://git.kernel.org/torvalds/c/734d1ed83e1f9b7b),
> namely the new ioctls for managing filesystem encryption keys and the
> new/updated ioctls for v2 encryption policy support.  It also includes
> ciphertext verification tests for v2 encryption policies.
> 
> These tests require new xfs_io commands, which are present in the
> for-next branch of xfsprogs.  They also need a kernel v5.4-rc1 or later.
> As is usual for xfstests, the tests will skip themselves if their
> prerequisites aren't met.
> 
> Note: currently only ext4, f2fs, and ubifs support encryption.  But I
> was told previously that since the fscrypt API is generic and may be
> supported by XFS in the future, the command-line wrappers for the
> fscrypt ioctls should be in xfs_io rather than in xfstests directly
> (https://marc.info/?l=fstests&m=147976255831951&w=2).
> 
> This patchset can also be retrieved from tag
> "fscrypt-key-mgmt-improvements_2019-10-15" of
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
> 
> Changes since v2:
> 
> - Updated "common/encrypt: disambiguate session encryption keys" to
>   rename the new instance of _generate_encryption_key() in generic/576.
> 
> Changes since v1:
> 
> - Addressed comments from Eryu Guan regarding
>   _require_encryption_policy_support().
> 
> - In generic/801, handle the fsgqa user having part of their key quota
>   already consumed before beginning the test, in order to avoid a false
>   test failure on some systems.
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

Does anyone have any more comments on these tests?

- Eric
