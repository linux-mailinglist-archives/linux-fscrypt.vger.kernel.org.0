Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68319139A41
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jan 2020 20:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgAMTfN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Jan 2020 14:35:13 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56822 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728641AbgAMTfM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Jan 2020 14:35:12 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DJZ8wB005092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 14:35:09 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 633164207DF; Mon, 13 Jan 2020 14:35:08 -0500 (EST)
Date:   Mon, 13 Jan 2020 14:35:08 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ext4: re-enable extent zeroout optimization on encrypted
 files
Message-ID: <20200113193508.GD76141@mit.edu>
References: <20191226161114.53606-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226161114.53606-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 26, 2019 at 10:11:14AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For encrypted files, commit 36086d43f657 ("ext4 crypto: fix bugs in
> ext4_encrypted_zeroout()") disabled the optimization where when a write
> occurs to the middle of an unwritten extent, the head and/or tail of the
> extent (when they aren't too large) are zeroed out, turned into an
> initialized extent, and merged with the part being written to.  This
> optimization helps prevent fragmentation of the extent tree.
> 
> However, disabling this optimization also made fscrypt_zeroout_range()
> nearly impossible to test, as now it's only reachable via the very rare
> case in ext4_split_extent_at() where allocating a new extent tree block
> fails due to ENOSPC.  'gce-xfstests -c ext4/encrypt -g auto' doesn't
> even hit this at all.
> 
> It's preferable to avoid really rare cases that are hard to test.
> 
> That commit also cited data corruption in xfstest generic/127 as a
> reason to disable the extent zeroout optimization, but that's no longer
> reproducible anymore.  It also cited fscrypt_zeroout_range() having poor
> performance, but I've written a patch to fix that.
> 
> Therefore, re-enable the extent zeroout optimization on encrypted files.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
