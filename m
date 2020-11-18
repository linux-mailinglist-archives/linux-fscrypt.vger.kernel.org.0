Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23A52B745E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Nov 2020 03:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgKRCvE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 21:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgKRCvE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 21:51:04 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A27A52168B;
        Wed, 18 Nov 2020 02:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605667864;
        bh=yQLMqwIXjBjRAFtQBs5wUsPvR7JiE//0NeTddTe+FTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ph8iDYNt3/JLiNU/2Xtn6irLPFDpoop2/QKV7tOrRNZjd/Q4R5JwJSWQx6mUuNhPd
         vTu5PzGdoWTo8E4SOZVwQaSVjpaM9xLgagUhfVoiv8S8pZRFOn2rPTzkAz03MYAJGh
         f8ZdbI8ic5P5jhX15uu0Bo3stnebkLqsNFYLGPHQ=
Date:   Tue, 17 Nov 2020 18:51:02 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 0/8] add support for direct I/O with fscrypt using
 blk-crypto
Message-ID: <X7SMFj8cQGjP/xip@sol.localdomain>
References: <20201117140708.1068688-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117140708.1068688-1-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 17, 2020 at 02:07:00PM +0000, Satya Tangirala wrote:
> This patch series was tested by running xfstests with test_dummy_encryption
> with and without the 'inlinecrypt' mount option, and there were no
> meaningful regressions. One regression was for generic/587 on ext4,
> but that test isn't compatible with test_dummy_encryption in the first
> place, and the test "incorrectly" passes without the 'inlinecrypt' mount
> option - a patch will be sent out to exclude that test when
> test_dummy_encryption is turned on with ext4 (like the other quota related
> tests that use user visible quota files).

It would be helpful to have some more testing results that show that the direct
I/O support is really working as intended, especially in the new case where
logical_block_size < data_unit_size and buffers are only logical_block_size
aligned --- both with real hardware and with blk-crypto-fallback.  Using my
patchset https://lkml.kernel.org/r/20201112194011.103774-1-ebiggers@kernel.org
it should be possible to test with real eMMC inline encryption hardware on
Snapdragon 630; it has logical_block_size=512.

Also note, generic/587 was already added to the ext4/encrypt and ext4/encrypt_1k
exclusion lists by xfstests-bld commit 02e4bfe628b4.

- Eric
