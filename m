Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1DA324763
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Feb 2021 00:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbhBXXLz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Feb 2021 18:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234728AbhBXXLy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Feb 2021 18:11:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCAE664F03;
        Wed, 24 Feb 2021 23:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614208274;
        bh=rZVUqkTMZlcMmWm+aXRNCV+Y6RkVX+1tzIDNnF3d2Cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=spTz5pST1kAP6ui7FZglg52WzjJqcI7HzVSjQApb/cbQ8DVWAsfy+6iVP8kCul1Qi
         1TY4P89LM2TEBNbYh0DDqS/JzZE8/r8+JG0+sdX6m5/Ab8vHgyVnwRbJJqlXgLYktz
         5vqRci3RHL3PUTCLe1GaZxOHXKia1qsdlfEfqJVNzkmBZjsz80HlPMtnEiXYI04hEw
         7tlwVU/6erD+W7G8zW8ZQfLuHf3gFrX4xc+M4rm9EePbo2BILB5G2yn8xT+aTfn9XU
         3U6i1fc79etfk6yIQt12VAA3LE4OYUj1X50L0tAq/gAR4snalhMpF2B3wd1XMUIBpu
         PVEA5Sqlxryxg==
Date:   Wed, 24 Feb 2021 15:11:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     heyunlei <heyunlei@hihonor.com>
Cc:     Chao Yu <chao@kernel.org>, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, bintian.wang@hihonor.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] f2fs: fsverity: Truncate cache pages if set verity failed
Message-ID: <YDbdEEcEV5bzgtL6@sol.localdomain>
References: <20210223112425.19180-1-heyunlei@hihonor.com>
 <c1ce1421-2576-5b48-322c-fa682c7510d7@kernel.org>
 <YDbbGSsd6ibKOpzT@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDbbGSsd6ibKOpzT@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Feb 24, 2021 at 03:02:52PM -0800, Eric Biggers wrote:
> Hi Yunlei,
> 
> On Wed, Feb 24, 2021 at 09:16:24PM +0800, Chao Yu wrote:
> > Hi Yunlei,
> > 
> > On 2021/2/23 19:24, heyunlei wrote:
> > > If file enable verity failed, should truncate anything wrote
> > > past i_size, including cache pages.
> > 
> > +Cc Eric,
> > 
> > After failure of enabling verity, we will see verity metadata if we truncate
> > file to larger size later?
> > 
> > Thanks,
> > 
> > > 
> > > Signed-off-by: heyunlei <heyunlei@hihonor.com>
> > > ---
> > >   fs/f2fs/verity.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> > > index 054ec852b5ea..f1f9b9361a71 100644
> > > --- a/fs/f2fs/verity.c
> > > +++ b/fs/f2fs/verity.c
> > > @@ -170,8 +170,10 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
> > >   	}
> > >   	/* If we failed, truncate anything we wrote past i_size. */
> > > -	if (desc == NULL || err)
> > > +	if (desc == NULL || err) {
> > > +		truncate_inode_pages(inode->i_mapping, inode->i_size);
> > >   		f2fs_truncate(inode);
> > > +	}
> > >   	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
> > > 
> 
> This looks good; thanks for finding this.  You can add:
> 
> 	Reviewed-by: Eric Biggers <ebiggers@google.com>
> 
> I thought that f2fs_truncate() would truncate pagecache pages too, but in fact
> that's not the case.
> 
> ext4_end_enable_verity() has the same bug too.  Can you please send a patch for
> that too (to linux-ext4)?
> 

Also please include the following tags in the f2fs patch:

	Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
	Cc: <stable@vger.kernel.org> # v5.4+

and in the ext4 patch:

	Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
	Cc: <stable@vger.kernel.org> # v5.4+

- Eric
