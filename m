Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF9513B462
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jan 2020 22:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgANVcl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jan 2020 16:32:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANVcl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jan 2020 16:32:41 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B43F324656;
        Tue, 14 Jan 2020 21:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579037560;
        bh=dozMZNZbwXQXYTYPrlUelgfZm/+WwDTPJ1CePGDuCLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tgTXs4Z4uC5Ug2qyrWa7r3M9ydC41IjJUg9yRfyWTP/ou74LzDuWMdSplppsecIW/
         Hw1b0cCk+aM8F/+EMk182zPEoSlJ5ZTI4BVX+6MCrJl1m0XX7m0hlibGuBUr/ki7fx
         bTZkvkfKhcpchpyHoBwPtUcVtKtY7JDfT0KJzTjU=
Date:   Tue, 14 Jan 2020 13:32:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fs-verity: use mempool for hash requests
Message-ID: <20200114213239.GI41220@gmail.com>
References: <20191231175545.20709-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231175545.20709-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 31, 2019 at 11:55:45AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When initializing an fs-verity hash algorithm, also initialize a mempool
> that contains a single preallocated hash request object.  Then replace
> the direct calls to ahash_request_alloc() and ahash_request_free() with
> allocating and freeing from this mempool.
> 
> This eliminates the possibility of the allocation failing, which is
> desirable for the I/O path.
> 
> This doesn't cause deadlocks because there's no case where multiple hash
> requests are needed at a time to make forward progress.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/verity/enable.c           |  8 +--
>  fs/verity/fsverity_private.h | 16 ++++--
>  fs/verity/hash_algs.c        | 98 +++++++++++++++++++++++++++---------
>  fs/verity/open.c             |  4 +-
>  fs/verity/verify.c           | 17 +++----
>  5 files changed, 97 insertions(+), 46 deletions(-)
> 

Applied to fscrypt.git#fsverity for 5.6.

- Eric
