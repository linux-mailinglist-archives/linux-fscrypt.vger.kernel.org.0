Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BE613B45C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jan 2020 22:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgANVbd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jan 2020 16:31:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANVbd (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jan 2020 16:31:33 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B3EB24656;
        Tue, 14 Jan 2020 21:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579037492;
        bh=GYh5yHnh97crjUGcpNk4U6wgwEXtefUmh/sSj0nDhcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gy5kqOExzRwji185eoB98JBO7eFuWv/RF0w4IPYwJHE7O3C14sKdF4CTZuMLYUhli
         nOzatFMeiKnnTyXd2psPtdj1xFMw8jRowwvjxH7l2SzLsCQN+R6GzFAWgSgVV7EUx3
         kNcZ7+QZ+D77atEjVGVwo+B2/3TMSDF/JmZEfgCg=
Date:   Tue, 14 Jan 2020 13:31:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Victor Hsieh <victorhsieh@google.com>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH v2] fs-verity: implement readahead of Merkle
 tree pages
Message-ID: <20200114213130.GG41220@gmail.com>
References: <20200106205533.137005-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106205533.137005-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 06, 2020 at 12:55:33PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When fs-verity verifies data pages, currently it reads each Merkle tree
> page synchronously using read_mapping_page().
> 
> Therefore, when the Merkle tree pages aren't already cached, fs-verity
> causes an extra 4 KiB I/O request for every 512 KiB of data (assuming
> that the Merkle tree uses SHA-256 and 4 KiB blocks).  This results in
> more I/O requests and performance loss than is strictly necessary.
> 
> Therefore, implement readahead of the Merkle tree pages.
> 
> For simplicity, we take advantage of the fact that the kernel already
> does readahead of the file's *data*, just like it does for any other
> file.  Due to this, we don't really need a separate readahead state
> (struct file_ra_state) just for the Merkle tree, but rather we just need
> to piggy-back on the existing data readahead requests.
> 
> We also only really need to bother with the first level of the Merkle
> tree, since the usual fan-out factor is 128, so normally over 99% of
> Merkle tree I/O requests are for the first level.
> 
> Therefore, make fsverity_verify_bio() enable readahead of the first
> Merkle tree level, for up to 1/4 the number of pages in the bio, when it
> sees that the REQ_RAHEAD flag is set on the bio.  The readahead size is
> then passed down to ->read_merkle_tree_page() for the filesystem to
> (optionally) implement if it sees that the requested page is uncached.
> 
> While we're at it, also make build_merkle_tree_level() set the Merkle
> tree readahead size, since it's easy to do there.
> 
> However, for now don't set the readahead size in fsverity_verify_page(),
> since currently it's only used to verify holes on ext4 and f2fs, and it
> would need parameters added to know how much to read ahead.
> 
> This patch significantly improves fs-verity sequential read performance.
> Some quick benchmarks with 'cat'-ing a 250MB file after dropping caches:
> 
>     On an ARM64 phone (using sha256-ce):
>         Before: 217 MB/s
>         After: 263 MB/s
>         (compare to sha256sum of non-verity file: 357 MB/s)
> 
>     In an x86_64 VM (using sha256-avx2):
>         Before: 173 MB/s
>         After: 215 MB/s
>         (compare to sha256sum of non-verity file: 223 MB/s)
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> Changed v1 => v2:
>   - Ensure that the pages continue being marked accessed when they're
>     already cached and Uptodate.
>   - Removed unnecessary IS_ERR(page) checks.
>   - Adjusted formatting of the prototype of f2fs_mpage_readpages() to
>     avoid a merge conflict with the f2fs tree.
> 
>  fs/ext4/verity.c             | 47 ++++++++++++++++++++++++++++++++++--
>  fs/f2fs/data.c               |  2 +-
>  fs/f2fs/f2fs.h               |  3 +++
>  fs/f2fs/verity.c             | 47 ++++++++++++++++++++++++++++++++++--
>  fs/verity/enable.c           |  8 +++++-
>  fs/verity/fsverity_private.h |  1 +
>  fs/verity/open.c             |  1 +
>  fs/verity/verify.c           | 34 +++++++++++++++++++++-----
>  include/linux/fsverity.h     |  7 +++++-
>  9 files changed, 137 insertions(+), 13 deletions(-)

Applied to fscrypt.git#fsverity for 5.6.

- Eric
