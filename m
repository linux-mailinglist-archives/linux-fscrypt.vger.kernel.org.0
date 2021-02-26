Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD22325B89
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Feb 2021 03:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBZCQF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 25 Feb 2021 21:16:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhBZCQE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 25 Feb 2021 21:16:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0E8164EF5;
        Fri, 26 Feb 2021 02:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614305723;
        bh=+24u6XMY4WfQ/a0wNzIwknMb5GmaXdJ5COacjbeXKHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVhjMDf0gr3PW+o1GsVPO7MumHDcb4u8nkiz7jHzvVoNJsSYbRT/OBYO5VVcU624o
         5lqY29011//QicZvkpTqdwYRPK/HrCSXTARR1kd+X6sYnw3ak4g4ooONeNmQLbCYGd
         U+oqAIKMLEesvaQhmy9kiItXQ9UzTBYryTdrT70e8Uoa8UGwl2o9toP1USciy+/edr
         FxKojG28hwir+1Jq5sS7b+Wwo8kB1iBtQPaoh+qMnHi4bHQ74VbntiWelfHsAd36g9
         piAAtml8SRgSWwJoc7/XTrGJnwV9QkBG8A9sJEL2HYyfmUOt48ClI7YFE8ShigQegS
         qRYa0sJhWClvg==
Date:   Thu, 25 Feb 2021 18:15:21 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     heyunlei 00015531 <heyunlei@hihonor.com>
Cc:     Chao Yu <chao@kernel.org>, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, bintian.wang@hihonor.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] f2fs: fsverity: Truncate cache pages if set verity failed
Message-ID: <YDhZuaF8lEQPtBmp@sol.localdomain>
References: <20210223112425.19180-1-heyunlei@hihonor.com>
 <c1ce1421-2576-5b48-322c-fa682c7510d7@kernel.org>
 <YDbbGSsd6ibKOpzT@sol.localdomain>
 <YDbdEEcEV5bzgtL6@sol.localdomain>
 <fae4a2f9-b1c9-e673-cefe-fe024ce6f9ab@hihonor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fae4a2f9-b1c9-e673-cefe-fe024ce6f9ab@hihonor.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Feb 26, 2021 at 09:42:33AM +0800, heyunlei 00015531 wrote:
> 
> 在 2021/2/25 7:11, Eric Biggers 写道:
> > On Wed, Feb 24, 2021 at 03:02:52PM -0800, Eric Biggers wrote:
> > > Hi Yunlei,
> > > 
> > > On Wed, Feb 24, 2021 at 09:16:24PM +0800, Chao Yu wrote:
> > > > Hi Yunlei,
> > > > 
> > > > On 2021/2/23 19:24, heyunlei wrote:
> > > > > If file enable verity failed, should truncate anything wrote
> > > > > past i_size, including cache pages.
> > > > +Cc Eric,
> > > > 
> > > > After failure of enabling verity, we will see verity metadata if we truncate
> > > > file to larger size later?
> > > > 
> > > > Thanks,
> Hi Eric，
> > > > > Signed-off-by: heyunlei <heyunlei@hihonor.com>
> > > > > ---
> > > > >    fs/f2fs/verity.c | 4 +++-
> > > > >    1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> > > > > index 054ec852b5ea..f1f9b9361a71 100644
> > > > > --- a/fs/f2fs/verity.c
> > > > > +++ b/fs/f2fs/verity.c
> > > > > @@ -170,8 +170,10 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
> > > > >    	}
> > > > >    	/* If we failed, truncate anything we wrote past i_size. */
> > > > > -	if (desc == NULL || err)
> > > > > +	if (desc == NULL || err) {
> > > > > +		truncate_inode_pages(inode->i_mapping, inode->i_size);
> > > > >    		f2fs_truncate(inode);
> > > > > +	}
> > > > >    	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
> > > > > 
> By the way，should  we consider  set xattr failed?
> 

Yes, that seems to be another oversight.  Similarly for ext4, if
ext4_journal_start(), ext4_orphan_del(), or ext4_reserve_inode_write() fails.

I think the right fix is to move the truncation to the end of the function.

- Eric
