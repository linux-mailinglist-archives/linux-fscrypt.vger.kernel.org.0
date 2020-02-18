Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAFB163558
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Feb 2020 22:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgBRVs7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Feb 2020 16:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgBRVs7 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Feb 2020 16:48:59 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF4C206E2;
        Tue, 18 Feb 2020 21:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582062538;
        bh=6Thj2Y1ouWsYzVdYK5ylYXtbW9w75KWMPCI3X9zmQ9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XpKQQHh022aPNMkN2vu5p331h+imBvxChUft5Y8h0ICd1D6RPuRHdqEQb2XEpK3bF
         sbz+q/8XTGFo+TjCxHLinQB5DbUTXZcBdDflR47eT6uH3YIqokQPzeWj+o0KLggAfY
         AUpUBE8DZm4SEYtMTT2lRrQ8Ka6FY1l5yl2x53z8=
Date:   Tue, 18 Feb 2020 13:48:57 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH v2] xfs_io/encrypt: support passing a keyring key to
 add_enckey
Message-ID: <20200218214856.GA147283@gmail.com>
References: <20200203182013.43474-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203182013.43474-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Feb 03, 2020 at 10:20:13AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a '-k' option to the 'add_enckey' xfs_io command to allow exercising
> the key_id field that is being added to struct fscrypt_add_key_arg.
> 
> This is needed for the corresponding test in xfstests.
> 
> For more details, see the corresponding xfstests patches as well as
> kernel commit 93edd392cad7 ("fscrypt: support passing a keyring key to
> FS_IOC_ADD_ENCRYPTION_KEY").
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> No changes since v1.
> 
> This applies to the for-next branch of xfsprogs.
> 
>  configure.ac          |  1 +
>  include/builddefs.in  |  4 ++
>  io/encrypt.c          | 90 +++++++++++++++++++++++++++++++------------
>  m4/package_libcdev.m4 | 21 ++++++++++
>  man/man8/xfs_io.8     | 10 +++--
>  5 files changed, 98 insertions(+), 28 deletions(-)
> 

Any comments on this patch?  The corresponding xfstests patches were merged.

- Eric
