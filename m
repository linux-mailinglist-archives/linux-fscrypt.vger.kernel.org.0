Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72888AADE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Aug 2019 00:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHLW6w (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 18:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfHLW6w (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 18:58:52 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC06206A2;
        Mon, 12 Aug 2019 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565650731;
        bh=Ron4sxTEpdo3+tpd+CjwxdTV+/gJhLyorORoDwJgP+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=paZ4tvByJADBX3s27FaJRrB5Ej2g8FmLvUxijggpEnAqzN/w4/EHi3nLjltk5O7ac
         34S/LLZzrFMatbOCPVVfEvQgfRT0oOd/9Da1W1dmXXDYBmTco5QM2ITb/lKh7b5/ZQ
         XZ0B4OmQnZ1PxsCIS/KHU9xEfZS0QCiia6NLmDPM=
Date:   Mon, 12 Aug 2019 15:58:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/6] f2fs: skip truncate when verity in progress in
 ->write_begin()
Message-ID: <20190812225848.GA175194@gmail.com>
Mail-Followup-To: Chao Yu <yuchao0@huawei.com>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <20190811213557.1970-1-ebiggers@kernel.org>
 <20190811213557.1970-4-ebiggers@kernel.org>
 <e5d57ee4-f022-12ca-7f09-e4b8ef86c6b6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5d57ee4-f022-12ca-7f09-e4b8ef86c6b6@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Chao,

On Mon, Aug 12, 2019 at 08:25:33PM +0800, Chao Yu wrote:
> Hi Eric,
> 
> On 2019/8/12 5:35, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > When an error (e.g. ENOSPC) occurs during f2fs_write_begin() when called
> > from f2fs_write_merkle_tree_block(), skip truncating the file.  i_size
> > is not meaningful in this case, and the truncation is handled by
> > f2fs_end_enable_verity() instead.
> > 
> > Fixes: 60d7bf0f790f ("f2fs: add fs-verity support")
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  fs/f2fs/data.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 3f525f8a3a5fa..00b03fb87bd9b 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -2476,7 +2476,7 @@ static void f2fs_write_failed(struct address_space *mapping, loff_t to)
> >  	struct inode *inode = mapping->host;
> >  	loff_t i_size = i_size_read(inode);
> >  
> > -	if (to > i_size) {
> 
> Maybe adding one single line comment to mention that it's redundant/unnecessary
> truncation here is better, if I didn't misunderstand this.
> 
> Thanks,
> 
> > +	if (to > i_size && !f2fs_verity_in_progress(inode)) {
> >  		down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
> >  		down_write(&F2FS_I(inode)->i_mmap_sem);
> >  

Do you mean add a comment instead of the !f2fs_verity_in_progress() check, or in
addition to it?  ->write_begin(), ->writepages(), and ->write_end() are all
supposed to ignore i_size when verity is in progress, so I don't think this
particular part should be different, even if technically it's still correct to
truncate twice.  Also, ext4 needs this check in its ->write_begin() for locking
reasons; we should keep f2fs similar.

How about having both a comment and the check, like:

        /* In the fs-verity case, f2fs_end_enable_verity() does the truncate */
        if (to > i_size && !f2fs_verity_in_progress(inode)) {

- Eric
