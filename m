Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C933BA44E6
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Aug 2019 17:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfHaPC5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Aug 2019 11:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbfHaPC4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Aug 2019 11:02:56 -0400
Received: from zzz.localdomain (h184-61-154-48.mdsnwi.dsl.dynamic.tds.net [184.61.154.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ACF720870;
        Sat, 31 Aug 2019 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567263775;
        bh=PxrDdalpr9suwjOCDgI9j5W8+hzqZYotv3brVPaQt5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LiyfcK+Q7uipDrMq/ga2KPglA43UgWVvnrHVMHIXmhEEPYrA8sqzDGftKZyrNa/V2
         iCdfe4eyAwbObOD3/akZv39EXva84QO8g3sNBwYPxMtohr44BiSojmdcQ8+NOZ7QXw
         8M38zGvhNWGXv0h4fgaFHNPp7gAijMLsWHxu+cKU=
Date:   Sat, 31 Aug 2019 10:02:51 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, Chao Yu <chao@kernel.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ext4 crypto: fix to check feature status before get
 policy
Message-ID: <20190831150251.GA528@zzz.localdomain>
Mail-Followup-To: Chao Yu <yuchao0@huawei.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, Chao Yu <chao@kernel.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
References: <20190804095643.7393-1-chao@kernel.org>
 <f5186fae-ac58-a5f5-f9dc-b749ade7285d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5186fae-ac58-a5f5-f9dc-b749ade7285d@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Aug 31, 2019 at 06:32:28PM +0800, Chao Yu wrote:
> Hi,
> 
> Is this change not necessary? A month has passed...
> 
> Thanks,
> 
> On 2019/8/4 17:56, Chao Yu wrote:
> > From: Chao Yu <yuchao0@huawei.com>
> > 
> > When getting fscrypto policy via EXT4_IOC_GET_ENCRYPTION_POLICY, if
> > encryption feature is off, it's better to return EOPNOTSUPP instead
> > of ENODATA, so let's add ext4_has_feature_encrypt() to do the check
> > for that.
> > 
> > Signed-off-by: Chao Yu <yuchao0@huawei.com>
> > ---
> >  fs/ext4/ioctl.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> > index 442f7ef873fc..bf87835c1237 100644
> > --- a/fs/ext4/ioctl.c
> > +++ b/fs/ext4/ioctl.c
> > @@ -1112,9 +1112,11 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  		return -EOPNOTSUPP;
> >  #endif
> >  	}
> > -	case EXT4_IOC_GET_ENCRYPTION_POLICY:
> > +	case EXT4_IOC_GET_ENCRYPTION_POLICY: {
> > +		if (!ext4_has_feature_encrypt(sb))
> > +			return -EOPNOTSUPP;
> >  		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
> > -
> > +	}
> >  	case EXT4_IOC_FSGETXATTR:
> >  	{
> >  		struct fsxattr fa;
> > 

Sorry, I was preoccupied with all the other fscrypt changes, and was thinking of
waiting until 5.5 for this to avoid a potential extra merge conflict or a
potentially breaking change.  Looking at this again though, the new ioctl
FS_IOC_GET_ENCRYPTION_POLICY_EX *does* do the feature check, which doesn't match
the documentation, which implies the check isn't done.  Also, f2fs does the
check in FS_IOC_GET_ENCRYPTION_POLICY, so the filesystems are inconsistent.

So, it makes some sense to apply this now.  So I've gone ahead and applied the
following to fscrypt.git#master, edited a bit from your original patch:

From 0642ea2409f3bfa105570e12854b8e2628db6835 Mon Sep 17 00:00:00 2001
From: Chao Yu <yuchao0@huawei.com>
Date: Sun, 4 Aug 2019 17:56:43 +0800
Subject: [PATCH] ext4 crypto: fix to check feature status before get policy

When getting fscrypt policy via EXT4_IOC_GET_ENCRYPTION_POLICY, if
encryption feature is off, it's better to return EOPNOTSUPP instead of
ENODATA, so let's add ext4_has_feature_encrypt() to do the check for
that.

This makes it so that all fscrypt ioctls consistently check for the
encryption feature, and makes ext4 consistent with f2fs in this regard.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
[EB - removed unneeded braces, updated the documentation, and
      added more explanation to commit message]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 3 ++-
 fs/ext4/ioctl.c                       | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 4289c29d7c5a..8a0700af9596 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -562,7 +562,8 @@ FS_IOC_GET_ENCRYPTION_POLICY_EX can fail with the following errors:
   or this kernel is too old to support FS_IOC_GET_ENCRYPTION_POLICY_EX
   (try FS_IOC_GET_ENCRYPTION_POLICY instead)
 - ``EOPNOTSUPP``: the kernel was not configured with encryption
-  support for this filesystem
+  support for this filesystem, or the filesystem superblock has not
+  had encryption enabled on it
 - ``EOVERFLOW``: the file is encrypted and uses a recognized
   encryption policy version, but the policy struct does not fit into
   the provided buffer
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index fe5a4b13f939..5703d607f5af 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1113,6 +1113,8 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 #endif
 	}
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
 		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
 
 	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
-- 
2.23.0

