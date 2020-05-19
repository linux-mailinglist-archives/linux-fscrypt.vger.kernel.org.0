Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09411D8E24
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 May 2020 05:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgESDTJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 May 2020 23:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgESDTI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 May 2020 23:19:08 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DED49206C3;
        Tue, 19 May 2020 03:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589858348;
        bh=PllARKm9f4ccZ/gUJMOlC7odKltZnclKy8uutdPb+k0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JRoNLpVnWz3SGXLNQ6Ppoj9p+wnKByVI+HT8sOgdeK0039aW0gKbfCEykPZnjexzU
         L7rCc55PGqNEjqLvpNkePRNd/vy3IeeMsiJa3f+jnlIeDwpzYlwUJHfAEq+ckKh3MG
         D9mLh/mIFFPJhgxULyW2K34Bovp+5a9G0pHi2J5Y=
Date:   Mon, 18 May 2020 20:19:07 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH 3/4] fscrypt: support test_dummy_encryption=v2
Message-ID: <20200519031907.GA155398@google.com>
References: <20200512233251.118314-1-ebiggers@kernel.org>
 <20200512233251.118314-4-ebiggers@kernel.org>
 <20200519025355.GC2396055@mit.edu>
 <20200519030205.GB954@sol.localdomain>
 <20200519031115.GC954@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519031115.GC954@sol.localdomain>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 05/18, Eric Biggers wrote:
> On Mon, May 18, 2020 at 08:02:05PM -0700, Eric Biggers wrote:
> > On Mon, May 18, 2020 at 10:53:55PM -0400, Theodore Y. Ts'o wrote:
> > > On Tue, May 12, 2020 at 04:32:50PM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > v1 encryption policies are deprecated in favor of v2, and some new
> > > > features (e.g. encryption+casefolding) are only being added for v2.
> > > > 
> > > > Therefore, the "test_dummy_encryption" mount option (which is used for
> > > > encryption I/O testing with xfstests) needs to support v2 policies.
> > > > 
> > > > To do this, extend its syntax to be "test_dummy_encryption=v1" or
> > > > "test_dummy_encryption=v2".  The existing "test_dummy_encryption" (no
> > > > argument) also continues to be accepted, to specify the default setting
> > > > -- currently v1, but the next patch changes it to v2.
> > > > 
> > > > To cleanly support both v1 and v2 while also making it easy to support
> > > > specifying other encryption settings in the future (say, accepting
> > > > "$contents_mode:$filenames_mode:v2"), make ext4 and f2fs maintain a
> > > > pointer to the dummy fscrypt_context rather than using mount flags.
> > > > 
> > > > To avoid concurrency issues, don't allow test_dummy_encryption to be set
> > > > or changed during a remount.  (The former restriction is new, but
> > > > xfstests doesn't run into it, so no one should notice.)
> > > > 
> > > > Tested with 'gce-xfstests -c {ext4,f2fs}/encrypt -g auto'.  On ext4,
> > > > there are two regressions, both of which are test bugs: ext4/023 and
> > > > ext4/028 fail because they set an xattr and expect it to be stored
> > > > inline, but the increase in size of the fscrypt_context from
> > > > 24 to 40 bytes causes this xattr to be spilled into an external block.
> > > > 
> > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > 
> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > > 
> > > Looks good, but could you do me a favor and merge in this?
> > > 
> > > diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> > > index 04bfaf63752c..6c9fc9e21c13 100644
> > > --- a/fs/ext4/sysfs.c
> > > +++ b/fs/ext4/sysfs.c
> > > @@ -293,6 +293,7 @@ EXT4_ATTR_FEATURE(batched_discard);
> > >  EXT4_ATTR_FEATURE(meta_bg_resize);
> > >  #ifdef CONFIG_FS_ENCRYPTION
> > >  EXT4_ATTR_FEATURE(encryption);
> > > +EXT4_ATTR_FEATURE(test_dummy_encryption_v2);
> > >  #endif
> > >  #ifdef CONFIG_UNICODE
> > >  EXT4_ATTR_FEATURE(casefold);
> > > @@ -308,6 +309,7 @@ static struct attribute *ext4_feat_attrs[] = {
> > >  	ATTR_LIST(meta_bg_resize),
> > >  #ifdef CONFIG_FS_ENCRYPTION
> > >  	ATTR_LIST(encryption),
> > > +	ATTR_LIST(test_dummy_encryption_v2),
> > >  #endif
> > >  #ifdef CONFIG_UNICODE
> > >  	ATTR_LIST(casefold),
> > > 
> > > This will make it easier to have the gce-xfstests test runner know
> > > whether or not test_dummy_encryption=v1 / test_dummy_encryption=v2
> > > will work, and whether test_dummy_encryption tests v1 or v2.
> > > 
> > 
> > Thanks, I'll add that.  I assume you meant "Reviewed-by"?
> 
> Jaegeuk, do you want /sys/fs/f2fs/features/test_dummy_encryption_v2 as well, to
> match what Ted wants for ext4?  It would be the following change:

Yes, please. Thank you.

> 
> diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
> index e3bbbef9b4f09e4..3162f46b3c9bfc1 100644
> --- a/fs/f2fs/sysfs.c
> +++ b/fs/f2fs/sysfs.c
> @@ -446,6 +446,7 @@ enum feat_id {
>  	FEAT_SB_CHECKSUM,
>  	FEAT_CASEFOLD,
>  	FEAT_COMPRESSION,
> +	FEAT_TEST_DUMMY_ENCRYPTION_V2,
>  };
>  
>  static ssize_t f2fs_feature_show(struct f2fs_attr *a,
> @@ -466,6 +467,7 @@ static ssize_t f2fs_feature_show(struct f2fs_attr *a,
>  	case FEAT_SB_CHECKSUM:
>  	case FEAT_CASEFOLD:
>  	case FEAT_COMPRESSION:
> +	case FEAT_TEST_DUMMY_ENCRYPTION_V2:
>  		return sprintf(buf, "supported\n");
>  	}
>  	return 0;
> @@ -563,6 +565,7 @@ F2FS_GENERAL_RO_ATTR(avg_vblocks);
>  
>  #ifdef CONFIG_FS_ENCRYPTION
>  F2FS_FEATURE_RO_ATTR(encryption, FEAT_CRYPTO);
> +F2FS_FEATURE_RO_ATTR(test_dummy_encryption_v2, FEAT_TEST_DUMMY_ENCRYPTION_V2);
>  #endif
>  #ifdef CONFIG_BLK_DEV_ZONED
>  F2FS_FEATURE_RO_ATTR(block_zoned, FEAT_BLKZONED);
> @@ -647,6 +650,7 @@ ATTRIBUTE_GROUPS(f2fs);
>  static struct attribute *f2fs_feat_attrs[] = {
>  #ifdef CONFIG_FS_ENCRYPTION
>  	ATTR_LIST(encryption),
> +	ATTR_LIST(test_dummy_encryption_v2),
>  #endif
>  #ifdef CONFIG_BLK_DEV_ZONED
>  	ATTR_LIST(block_zoned),
