Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661F9327047
	for <lists+linux-fscrypt@lfdr.de>; Sun, 28 Feb 2021 05:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhB1ExS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 27 Feb 2021 23:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhB1ExR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 27 Feb 2021 23:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E9D64E10;
        Sun, 28 Feb 2021 04:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614487955;
        bh=TPuIvHd6Bs3bRcf4BzsMlYT1Gou/E7eosJtAO9spevc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XWT16qHiyEgYEN0ob4FNSqQgnCfQ43mP460op4rpQT66dn4Fgs7IsUpqLG2JNYtDy
         lyTR/iNVLSrRWSzYlY2V6Hbv09osFS66gmwtmch8TPIB2U8morsrtYSSRK61UNk0bW
         koQt8M22CxbzZBby7YoAlZVS9w1roVZXprnWrOYpE1ykxHUGfW98OxtaZGDbbQXER7
         K3MtK7AdhMjg7M0pr11zcGILqHTaddZGeGEbZxoSP0ezV7FYO1SIBsr0Lcngk7JU0Q
         W2DcSSDKOpezdbVlCe4Knz4sCn3RKOCl9S6Eobzr/W0lf8hFBiNj/HdVkjapTh2tsH
         bZeaSrB1i/Slg==
Date:   Sat, 27 Feb 2021 20:52:34 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     heyunlei 00015531 <heyunlei@hihonor.com>,
        Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, bintian.wang@hihonor.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] f2fs: fsverity: Truncate cache pages if set verity failed
Message-ID: <YDshkqMPGk3iY2YO@google.com>
References: <20210223112425.19180-1-heyunlei@hihonor.com>
 <c1ce1421-2576-5b48-322c-fa682c7510d7@kernel.org>
 <YDbbGSsd6ibKOpzT@sol.localdomain>
 <YDbdEEcEV5bzgtL6@sol.localdomain>
 <fae4a2f9-b1c9-e673-cefe-fe024ce6f9ab@hihonor.com>
 <YDhZuaF8lEQPtBmp@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YDhZuaF8lEQPtBmp@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Yunlei,

Could you please post another version to have all the suggestions? :)

Thanks,

On 02/25, Eric Biggers wrote:
> On Fri, Feb 26, 2021 at 09:42:33AM +0800, heyunlei 00015531 wrote:
> > 
> > 在 2021/2/25 7:11, Eric Biggers 写道:
> > > On Wed, Feb 24, 2021 at 03:02:52PM -0800, Eric Biggers wrote:
> > > > Hi Yunlei,
> > > > 
> > > > On Wed, Feb 24, 2021 at 09:16:24PM +0800, Chao Yu wrote:
> > > > > Hi Yunlei,
> > > > > 
> > > > > On 2021/2/23 19:24, heyunlei wrote:
> > > > > > If file enable verity failed, should truncate anything wrote
> > > > > > past i_size, including cache pages.
> > > > > +Cc Eric,
> > > > > 
> > > > > After failure of enabling verity, we will see verity metadata if we truncate
> > > > > file to larger size later?
> > > > > 
> > > > > Thanks,
> > Hi Eric，
> > > > > > Signed-off-by: heyunlei <heyunlei@hihonor.com>
> > > > > > ---
> > > > > >    fs/f2fs/verity.c | 4 +++-
> > > > > >    1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
> > > > > > index 054ec852b5ea..f1f9b9361a71 100644
> > > > > > --- a/fs/f2fs/verity.c
> > > > > > +++ b/fs/f2fs/verity.c
> > > > > > @@ -170,8 +170,10 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
> > > > > >    	}
> > > > > >    	/* If we failed, truncate anything we wrote past i_size. */
> > > > > > -	if (desc == NULL || err)
> > > > > > +	if (desc == NULL || err) {
> > > > > > +		truncate_inode_pages(inode->i_mapping, inode->i_size);
> > > > > >    		f2fs_truncate(inode);
> > > > > > +	}
> > > > > >    	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
> > > > > > 
> > By the way，should  we consider  set xattr failed?
> > 
> 
> Yes, that seems to be another oversight.  Similarly for ext4, if
> ext4_journal_start(), ext4_orphan_del(), or ext4_reserve_inode_write() fails.
> 
> I think the right fix is to move the truncation to the end of the function.
> 
> - Eric
