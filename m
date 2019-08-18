Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7AC91987
	for <lists+linux-fscrypt@lfdr.de>; Sun, 18 Aug 2019 22:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfHRUY3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 18 Aug 2019 16:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbfHRUY2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 18 Aug 2019 16:24:28 -0400
Received: from zzz.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A5BE206BB;
        Sun, 18 Aug 2019 20:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566159867;
        bh=Jh5Ix1Is82ONb8wHIbToD8YP+ZDZW+pBP6C/nAQhTzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ylz/BQ2XWLsri1rObtepn8jOl/INXaYtOJ7hD5K8gZSWxNJ9jDnpkV5yf6N+OubrE
         4ugxzItfLzY1NdgYWeFyANbTx9QogPOYg3MT3ntXDSuH7aMg+bwi8/Fi4DYj6Z+Jgh
         vQxHqN5ocmzElOA7PsGNfK3ZRD/gaKXwKP8wVT94=
Date:   Sun, 18 Aug 2019 13:24:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 3/6] f2fs: skip truncate when verity in
 progress in ->write_begin()
Message-ID: <20190818202426.GB1824@zzz.localdomain>
Mail-Followup-To: Chao Yu <yuchao0@huawei.com>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <20190811213557.1970-1-ebiggers@kernel.org>
 <20190811213557.1970-4-ebiggers@kernel.org>
 <e5d57ee4-f022-12ca-7f09-e4b8ef86c6b6@huawei.com>
 <20190812225848.GA175194@gmail.com>
 <13be698c-1a3d-9f6a-66d8-b9024b7963f3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13be698c-1a3d-9f6a-66d8-b9024b7963f3@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 13, 2019 at 10:40:39AM +0800, Chao Yu wrote:
> Hi Eric,
> 
> On 2019/8/13 6:58, Eric Biggers wrote:
> > Hi Chao,
> > 
> > On Mon, Aug 12, 2019 at 08:25:33PM +0800, Chao Yu wrote:
> >> Hi Eric,
> >>
> >> On 2019/8/12 5:35, Eric Biggers wrote:
> >>> From: Eric Biggers <ebiggers@google.com>
> >>>
> >>> When an error (e.g. ENOSPC) occurs during f2fs_write_begin() when called
> >>> from f2fs_write_merkle_tree_block(), skip truncating the file.  i_size
> >>> is not meaningful in this case, and the truncation is handled by
> >>> f2fs_end_enable_verity() instead.
> >>>
> >>> Fixes: 60d7bf0f790f ("f2fs: add fs-verity support")
> >>> Signed-off-by: Eric Biggers <ebiggers@google.com>
> >>> ---
> >>>  fs/f2fs/data.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> >>> index 3f525f8a3a5fa..00b03fb87bd9b 100644
> >>> --- a/fs/f2fs/data.c
> >>> +++ b/fs/f2fs/data.c
> >>> @@ -2476,7 +2476,7 @@ static void f2fs_write_failed(struct address_space *mapping, loff_t to)
> >>>  	struct inode *inode = mapping->host;
> >>>  	loff_t i_size = i_size_read(inode);
> >>>  
> >>> -	if (to > i_size) {
> >>
> >> Maybe adding one single line comment to mention that it's redundant/unnecessary
> >> truncation here is better, if I didn't misunderstand this.
> >>
> >> Thanks,
> >>
> >>> +	if (to > i_size && !f2fs_verity_in_progress(inode)) {
> >>>  		down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
> >>>  		down_write(&F2FS_I(inode)->i_mmap_sem);
> >>>  
> > 
> > Do you mean add a comment instead of the !f2fs_verity_in_progress() check, or in
> > addition to it?  ->write_begin(), ->writepages(), and ->write_end() are all
> 
> Sorry, I didn't make this very clear, I meant adding the comment in addition on
> above change.
> 
> > supposed to ignore i_size when verity is in progress, so I don't think this
> > particular part should be different, even if technically it's still correct to
> > truncate twice.  Also, ext4 needs this check in its ->write_begin() for locking
> > reasons; we should keep f2fs similar.
> 
> Agreed.
> 
> > 
> > How about having both a comment and the check, like:
> > 
> >         /* In the fs-verity case, f2fs_end_enable_verity() does the truncate */
> >         if (to > i_size && !f2fs_verity_in_progress(inode)) {
> 
> The comment looks good to me. :)
> 
> Thanks,
> 
> > 
> > - Eric
> > .
> > 
> 

Okay, this is what I applied:

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3f525f8a3a5f..54cad80acb7d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2476,7 +2476,8 @@ static void f2fs_write_failed(struct address_space *mapping, loff_t to)
 	struct inode *inode = mapping->host;
 	loff_t i_size = i_size_read(inode);
 
-	if (to > i_size) {
+	/* In the fs-verity case, f2fs_end_enable_verity() does the truncate */
+	if (to > i_size && !f2fs_verity_in_progress(inode)) {
 		down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 		down_write(&F2FS_I(inode)->i_mmap_sem);
 
