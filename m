Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AE4139A2D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jan 2020 20:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgAMT35 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Jan 2020 14:29:57 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55683 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726435AbgAMT35 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Jan 2020 14:29:57 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DJTpTZ002464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 14:29:52 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 46B314207DF; Mon, 13 Jan 2020 14:29:51 -0500 (EST)
Date:   Mon, 13 Jan 2020 14:29:51 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ext4: allow ZERO_RANGE on encrypted files
Message-ID: <20200113192951.GA76141@mit.edu>
References: <20191226154216.4808-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226154216.4808-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 26, 2019 at 09:42:16AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When ext4 encryption support was first added, ZERO_RANGE was disallowed,
> supposedly because test failures (e.g. ext4/001) were seen when enabling
> it, and at the time there wasn't enough time/interest to debug it.
> 
> However, there's actually no reason why ZERO_RANGE can't work on
> encrypted files.  And it fact it *does* work now.  Whole blocks in the
> zeroed range are converted to unwritten extents, as usual; encryption
> makes no difference for that part.  Partial blocks are zeroed in the
> pagecache and then ->writepages() encrypts those blocks as usual.
> ext4_block_zero_page_range() handles reading and decrypting the block if
> needed before actually doing the pagecache write.
> 
> Also, f2fs has always supported ZERO_RANGE on encrypted files.
> 
> As far as I can tell, the reason that ext4/001 was failing in v4.1 was
> actually because of one of the bugs fixed by commit 36086d43f657 ("ext4
> crypto: fix bugs in ext4_encrypted_zeroout()").  The bug made
> ext4_encrypted_zeroout() always return a positive value, which caused
> unwritten extents in encrypted files to sometimes not be marked as
> initialized after being written to.  This bug was not actually in
> ZERO_RANGE; it just happened to trigger during the extents manipulation
> done in ext4/001 (and probably other tests too).
> 
> So, let's enable ZERO_RANGE on encrypted files on ext4.
> 
> Tested with:
> 	gce-xfstests -c ext4/encrypt -g auto
> 	gce-xfstests -c ext4/encrypt_1k -g auto
> 
> Got the same set of test failures both with and without this patch.
> But with this patch 6 fewer tests are skipped: ext4/001, generic/008,
> generic/009, generic/033, generic/096, and generic/511.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
