Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414C21BE3A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 May 2019 21:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfEMT44 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 May 2019 15:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfEMT4z (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 May 2019 15:56:55 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97820208C3;
        Mon, 13 May 2019 19:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557777414;
        bh=H/CvBCQg09lqqJZk0o1uuzjbgPqRVU7YsyNxmQ//uKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=poPdEHBr8h8uMe+khz3FYPyc+6HX4i3FGRXcwJkWW0s4xdgiLkvBeI27pgQQEvvR1
         /hNCpiDpG8sNusieY3szYv2k0eEeb4viOuObmWyzM2bGJl0tS6CFZ8/MIUP/LZhaQ+
         Qpuh9oK58WZ+P+xpmTuu2EfTnIKZdzXksXiQ2Xv8=
Date:   Mon, 13 May 2019 12:56:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard@nod.at>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-fscrypt@vger.kernel.org, tytso <tytso@mit.edu>,
        kernel <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] ubifs: Remove #ifdef around CONFIG_FS_ENCRYPTION
Message-ID: <20190513195652.GB142816@gmail.com>
References: <20190326075232.11717-1-s.hauer@pengutronix.de>
 <20190326075232.11717-2-s.hauer@pengutronix.de>
 <20190508031954.GA26575@sol.localdomain>
 <1170873772.48849.1557298158182.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1170873772.48849.1557298158182.JavaMail.zimbra@nod.at>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 08, 2019 at 08:49:18AM +0200, Richard Weinberger wrote:
> Eric,
> 
> ----- Ursprüngliche Mail -----
> > Von: "Eric Biggers" <ebiggers@kernel.org>
> > An: "Sascha Hauer" <s.hauer@pengutronix.de>, "richard" <richard@nod.at>
> > CC: "linux-mtd" <linux-mtd@lists.infradead.org>, linux-fscrypt@vger.kernel.org, "tytso" <tytso@mit.edu>, "kernel"
> > <kernel@pengutronix.de>
> > Gesendet: Mittwoch, 8. Mai 2019 05:19:55
> > Betreff: Re: [PATCH 1/2] ubifs: Remove #ifdef around CONFIG_FS_ENCRYPTION
> 
> > On Tue, Mar 26, 2019 at 08:52:31AM +0100, Sascha Hauer wrote:
> >> ifdefs reduce readablity and compile coverage. This removes the ifdefs
> >> around CONFIG_FS_ENCRYPTION by using IS_ENABLED and relying on static
> >> inline wrappers. A new static inline wrapper for setting sb->s_cop is
> >> introduced to allow filesystems to unconditionally compile in their
> >> s_cop operations.
> >> 
> >> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> >> ---
> >>  fs/ubifs/ioctl.c        | 11 +----------
> >>  fs/ubifs/sb.c           |  7 ++++---
> >>  fs/ubifs/super.c        |  4 +---
> >>  include/linux/fscrypt.h | 11 +++++++++++
> >>  4 files changed, 17 insertions(+), 16 deletions(-)
> >> 
> >> diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
> >> index 82e4e6a30b04..6b05b3ec500e 100644
> >> --- a/fs/ubifs/ioctl.c
> >> +++ b/fs/ubifs/ioctl.c
> >> @@ -193,7 +193,6 @@ long ubifs_ioctl(struct file *file, unsigned int cmd,
> >> unsigned long arg)
> >>  		return err;
> >>  	}
> >>  	case FS_IOC_SET_ENCRYPTION_POLICY: {
> >> -#ifdef CONFIG_FS_ENCRYPTION
> >>  		struct ubifs_info *c = inode->i_sb->s_fs_info;
> >>  
> >>  		err = ubifs_enable_encryption(c);
> >> @@ -201,17 +200,9 @@ long ubifs_ioctl(struct file *file, unsigned int cmd,
> >> unsigned long arg)
> >>  			return err;
> >>  
> >>  		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
> >> -#else
> >> -		return -EOPNOTSUPP;
> >> -#endif
> >>  	}
> >> -	case FS_IOC_GET_ENCRYPTION_POLICY: {
> >> -#ifdef CONFIG_FS_ENCRYPTION
> >> +	case FS_IOC_GET_ENCRYPTION_POLICY:
> >>  		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
> >> -#else
> >> -		return -EOPNOTSUPP;
> >> -#endif
> >> -	}
> >>  
> >>  	default:
> >>  		return -ENOTTY;
> >> diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
> >> index 67fac1e8adfb..2afc8b1d4c3b 100644
> >> --- a/fs/ubifs/sb.c
> >> +++ b/fs/ubifs/sb.c
> >> @@ -748,14 +748,12 @@ int ubifs_read_superblock(struct ubifs_info *c)
> >>  		goto out;
> >>  	}
> >>  
> >> -#ifndef CONFIG_FS_ENCRYPTION
> >> -	if (c->encrypted) {
> >> +	if (!IS_ENABLED(CONFIG_UBIFS_FS_ENCRYPTION) && c->encrypted) {
> >>  		ubifs_err(c, "file system contains encrypted files but UBIFS"
> >>  			     " was built without crypto support.");
> >>  		err = -EINVAL;
> >>  		goto out;
> >>  	}
> > 
> > A bit late, but I noticed this in ubifs/linux-next.  This needs to use
> > CONFIG_FS_ENCRYPTION here, not CONFIG_UBIFS_FS_ENCRYPTION, as the latter no
> > longer exists.
> 
> Thanks for spotting. I'll fit it myself in -next.
> 
> Thanks,
> //richard

This was merged to mainline and it's still broken.  This breaks UBIFS encryption
entirely, BTW.  Do you not run xfstests before sending pull requests?

- Eric
