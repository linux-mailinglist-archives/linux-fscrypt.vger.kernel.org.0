Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15CF139A4B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jan 2020 20:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgAMTo4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Jan 2020 14:44:56 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58893 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726435AbgAMTo4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Jan 2020 14:44:56 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DJiqV6009266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 14:44:53 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B75B34207DF; Mon, 13 Jan 2020 14:44:52 -0500 (EST)
Date:   Mon, 13 Jan 2020 14:44:52 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ext4: fix deadlock allocating crypto bounce page from
 mempool
Message-ID: <20200113194452.GF76141@mit.edu>
References: <20191231181149.47619-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231181149.47619-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 31, 2019 at 12:11:49PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ext4_writepages() on an encrypted file has to encrypt the data, but it
> can't modify the pagecache pages in-place, so it encrypts the data into
> bounce pages and writes those instead.  All bounce pages are allocated
> from a mempool using GFP_NOFS.
> 
> This is not correct use of a mempool, and it can deadlock.  This is
> because GFP_NOFS includes __GFP_DIRECT_RECLAIM, which enables the "never
> fail" mode for mempool_alloc() where a failed allocation will fall back
> to waiting for one of the preallocated elements in the pool.
> 
> But since this mode is used for all a bio's pages and not just the
> first, it can deadlock waiting for pages already in the bio to be freed.
> 
> This deadlock can be reproduced by patching mempool_alloc() to pretend
> that pool->alloc() always fails (so that it always falls back to the
> preallocations), and then creating an encrypted file of size > 128 KiB.
> 
> Fix it by only using GFP_NOFS for the first page in the bio.  For
> subsequent pages just use GFP_NOWAIT, and if any of those fail, just
> submit the bio and start a new one.
> 
> This will need to be fixed in f2fs too, but that's less straightforward.
> 
> Fixes: c9af28fdd449 ("ext4 crypto: don't let data integrity writebacks fail with ENOMEM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

					- Ted
