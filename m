Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AB5285741
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Oct 2020 05:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgJGDso (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 6 Oct 2020 23:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbgJGDsb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 6 Oct 2020 23:48:31 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D231208C3;
        Wed,  7 Oct 2020 03:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602042511;
        bh=utdOvzVHh89b4CpLVpb/B52DJTCKTgZ4TatN41r7vCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DAaVPOwJ/Oo5GVLzk9uGENtdZtKxJUoCECj95UyceMUuaD19dko63qK5FPJ0xYvZH
         pAKVj9DaXhWCjJPiqysw5TgaBKd2mEoW5WKs4CXTgaScgMmgfnSbCFukXhjCwI1ueM
         RNPVtN8K/4Gz3YjOidGulDFCDFo3g2LJKJ30WO5c=
Date:   Tue, 6 Oct 2020 20:48:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Daeho Jeong <daehojeong@google.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/5] xfstests: test f2fs compression+encryption
Message-ID: <20201007034829.GA912@sol.localdomain>
References: <20201001002508.328866-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001002508.328866-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 30, 2020 at 05:25:02PM -0700, Eric Biggers wrote:
> Add a test which verifies that encryption is done correctly when a file
> on f2fs uses both compression and encryption at the same time.
> 
> Patches 1-4 add prerequisites for the test, while patch 5 adds the
> actual test.  Patch 2 also fixes a bug which could cause the existing
> test generic/602 to fail in extremely rare cases.  See the commit
> messages for details.
> 
> The new test passes both with and without the inlinecrypt mount option.
> It requires CONFIG_F2FS_FS_COMPRESSION=y.
> 
> I'd appreciate the f2fs developers taking a look.
> 
> Note, there is a quirk where the IVs in compressed files are off by one
> from the "natural" values.  It's still secure, though it made the test
> slightly harder to write.  I'm not sure how intentional this quirk was.
> 
> Eric Biggers (5):
>   fscrypt-crypt-util: clean up parsing --block-size and --inode-number
>   fscrypt-crypt-util: fix IV incrementing for --iv-ino-lblk-32
>   fscrypt-crypt-util: add --block-number option
>   common/f2fs: add _require_scratch_f2fs_compression()
>   f2fs: verify ciphertext of compressed+encrypted file

Jaegeuk, Chao, Daeho: any comments on this?

- Eric
