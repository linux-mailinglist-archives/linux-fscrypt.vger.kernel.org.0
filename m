Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D71139A55
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jan 2020 20:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgAMTr2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Jan 2020 14:47:28 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59422 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728641AbgAMTr2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Jan 2020 14:47:28 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DJlOQC010425
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 14:47:25 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id AD3A04207DF; Mon, 13 Jan 2020 14:47:24 -0500 (EST)
Date:   Mon, 13 Jan 2020 14:47:24 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ext4: fix deadlock allocating bio_post_read_ctx from
 mempool
Message-ID: <20200113194724.GG76141@mit.edu>
References: <20191231181222.47684-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231181222.47684-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 31, 2019 at 12:12:22PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Without any form of coordination, any case where multiple allocations
> from the same mempool are needed at a time to make forward progress can
> deadlock under memory pressure.
> 
> This is the case for struct bio_post_read_ctx, as one can be allocated
> to decrypt a Merkle tree page during fsverity_verify_bio(), which itself
> is running from a post-read callback for a data bio which has its own
> struct bio_post_read_ctx.
> 
> Fix this by freeing the first bio_post_read_ctx before calling
> fsverity_verify_bio().  This works because verity (if enabled) is always
> the last post-read step.
> 
> This deadlock can be reproduced by trying to read from an encrypted
> verity file after reducing NUM_PREALLOC_POST_READ_CTXS to 1 and patching
> mempool_alloc() to pretend that pool->alloc() always fails.
> 
> Note that since NUM_PREALLOC_POST_READ_CTXS is actually 128, to actually
> hit this bug in practice would require reading from lots of encrypted
> verity files at the same time.  But it's theoretically possible, as N
> available objects isn't enough to guarantee forward progress when > N/2
> threads each need 2 objects at a time.
> 
> Fixes: 22cfe4b48ccb ("ext4: add fs-verity read support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
