Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB301123B9
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Dec 2019 08:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfLDHxy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Dec 2019 02:53:54 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37346 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfLDHxx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Dec 2019 02:53:53 -0500
Received: by mail-lj1-f193.google.com with SMTP id u17so6949110lja.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 03 Dec 2019 23:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o7BdwW/nndIBcsxZWW8vbo3uXBPbU7tTjh33V04X4ek=;
        b=R15GZEj9KTLTNO0VqqzBo4GIYJtcpTb2kJpdaZtblji+D+RrmcI9rTjDxe+QmhairT
         Dbdver0Sq7o39O5yoG4UDoGmJmo9vH5HMuLXGO7h9I6dmFkSgcGzoSd18zm/LtsqK2mF
         lUVjO8y7iCVF2gvIFJREkER6zjHAaENjaCcLtLpziuR4Pq2w3Z8Wlhe3XDpq/lUxhE9O
         T4/3msAlwIt0YUvQb44lViYxzbj8rFEkqw+r1HWH3ILYKZPpWy2mnzcedUuXScZGEePd
         QqT5lFUQEHQIvzSg5F3M5PVgRTSf84jSg366orX8ATHSyfkMZ7VBL4bHLLLgCBkyqZGQ
         zDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7BdwW/nndIBcsxZWW8vbo3uXBPbU7tTjh33V04X4ek=;
        b=tVZOCKvUUpbPHuSz2o7ySdCN3th+GYKJhWUcF4DTS3C11khkpTEz/8rIPLPfVYZNvZ
         77Zv7XOJkOAqOMZ/UOMogS5mQpWLlpysi/a96LUn8Ojh6FvHxDi6KVcE2TmlG36InfwF
         VMNXHqSURbF7sSMo+HOIGf14Z6mNS/FQEZilKv39vpo1oBd2I9UMGWhVPAgnnIVu2sd4
         eY9lCbq8p3SyHgcm5FFEcObA0OFSGnKuPfCG/OQcZfGydQXnELocqK+055aJwDQWEkyk
         rXNciXjZBf4Y9X8opI5nTuuD8J3ETyKDg3L1P4ea+fFVpcvWu4NSgXrqKtz6a0QzHHbk
         weEg==
X-Gm-Message-State: APjAAAWeYvT2855+YmV2jttMxKiYkck8odmfB0ShKig/W/adjE9CZ9x7
        64+wGVK9HsIoUw7QkYCT9KPcmA==
X-Google-Smtp-Source: APXvYqw9cr0AJeOMuYf9c3iwqsmg8RWLKAie3QTXWVS6sDwM7krFflTW5KVptECDL2Qepv39q9RcUg==
X-Received: by 2002:a2e:9e97:: with SMTP id f23mr1068434ljk.89.1575446031396;
        Tue, 03 Dec 2019 23:53:51 -0800 (PST)
Received: from msk1wst115n.omp.ru (mail.omprussia.ru. [5.134.221.218])
        by smtp.gmail.com with ESMTPSA id x23sm2807809lff.24.2019.12.03.23.53.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Dec 2019 23:53:50 -0800 (PST)
Message-ID: <96a288281d9d84f11dcc06e62a1ff20e2bb2f776.camel@dubeyko.com>
Subject: Re: [PATCH] fs-verity: implement readahead for FS_IOC_ENABLE_VERITY
From:   Vyacheslav Dubeyko <slava@dubeyko.com>
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        Victor Hsieh <victorhsieh@google.com>
Date:   Wed, 04 Dec 2019 10:53:50 +0300
In-Reply-To: <20191203193001.66906-1-ebiggers@kernel.org>
References: <20191203193001.66906-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2019-12-03 at 11:30 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When it builds the first level of the Merkle tree,
> FS_IOC_ENABLE_VERITY
> sequentially reads each page of the file using read_mapping_page().
> This works fine if the file's data is already in pagecache, which
> should
> normally be the case, since this ioctl is normally used immediately
> after writing out the file.
> 
> But in any other case this implementation performs very poorly, since
> only one page is read at a time.
> 
> Fix this by implementing readahead using the functions from
> mm/readahead.c.
> 
> This improves performance in the uncached case by about 20x, as seen
> in
> the following benchmarks done on a 250MB file (on x86_64 with SHA-
> NI):
> 
>     FS_IOC_ENABLE_VERITY uncached (before) 3.299s
>     FS_IOC_ENABLE_VERITY uncached (after)  0.160s
>     FS_IOC_ENABLE_VERITY cached            0.147s
>     sha256sum uncached                     0.191s
>     sha256sum cached                       0.145s
> 
> Note: we could instead switch to kernel_read().  But that would mean
> we'd no longer be hashing the data directly from the pagecache, which
> is
> a nice optimization of its own.  And using kernel_read() would
> require
> allocating another temporary buffer, hashing the data and tree pages
> separately, and explicitly zero-padding the last page -- so it
> wouldn't
> really be any simpler than direct pagecache access, at least for now.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/verity/enable.c | 46 ++++++++++++++++++++++++++++++++++++++++--
> ----
>  1 file changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/verity/enable.c b/fs/verity/enable.c
> index eabc6ac19906..f7eaffa60196 100644
> --- a/fs/verity/enable.c
> +++ b/fs/verity/enable.c
> @@ -13,14 +13,44 @@
>  #include <linux/sched/signal.h>
>  #include <linux/uaccess.h>
>  
> -static int build_merkle_tree_level(struct inode *inode, unsigned int
> level,
> +/*
> + * Read a file data page for Merkle tree construction.  Do
> aggressive readahead,
> + * since we're sequentially reading the entire file.
> + */
> +static struct page *read_file_data_page(struct inode *inode,
> +					struct file_ra_state *ra,
> +					struct file *filp,
> +					pgoff_t index,
> +					pgoff_t num_pages_in_file)
> +{
> +	struct page *page;
> +
> +	page = find_get_page(inode->i_mapping, index);
> +	if (!page || !PageUptodate(page)) {
> +		if (page)
> +			put_page(page);


It looks like that there is not necessary check here. If we have NULL
pointer on page then we will not enter inside. But if we have valid
pointer on page then we have double check inside. Am I correct? 


> +		page_cache_sync_readahead(inode->i_mapping, ra, filp,
> +					  index, num_pages_in_file -
> index);
> +		page = read_mapping_page(inode->i_mapping, index,
> NULL);
> +		if (IS_ERR(page))
> +			return page;

Could we recieve the NULL pointer here? Is callee ready to process theNULL return value? 

Thanks,
Viacheslav Dubeyko.


