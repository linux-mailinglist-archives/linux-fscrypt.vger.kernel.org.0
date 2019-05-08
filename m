Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4358816FB7
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 May 2019 05:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfEHDzR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 May 2019 23:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfEHDzR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 May 2019 23:55:17 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02F8E20850;
        Wed,  8 May 2019 03:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557287716;
        bh=pRTYelSiHwn9y5A6mLWps/84JwT6lVmP1IHZ/1mtEAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wuLfpzK14ygxNZKYPf81+T7VK5P7B6uQKCpDuS3joeE8jjk1Ho+xgufluM8oy4eMq
         vlP00bEOQfsSH0BCw2IiTqNh7PYjBZavV4LuezbgILSbcA4MoLT3NBMC1UcMTngdxZ
         amYg21suuHEfLDUlzlzIgqNIvAfpT8mI1EQjp1Gk=
Date:   Tue, 7 May 2019 20:55:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Fang =?utf-8?B?SG9uZ2ppZSjmlrnmtKrmnbAp?= 
        <hongjiefang@asrmicro.com>
Cc:     "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't set policy for a dead directory
Message-ID: <20190508035513.GB26575@sol.localdomain>
References: <1557204108-29048-1-git-send-email-hongjiefang@asrmicro.com>
 <20190507155531.GA1399@sol.localdomain>
 <8294e7217a014c5ca64f29fdf69bdeec@mail2012.asrmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8294e7217a014c5ca64f29fdf69bdeec@mail2012.asrmicro.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[+Cc linux-ext4]

On Wed, May 08, 2019 at 02:11:10AM +0000, Fang Hongjie(方洪杰) wrote:
> 
> > -----Original Message-----
> > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > Sent: Tuesday, May 07, 2019 11:56 PM
> > To: Fang Hongjie(方洪杰)
> > Cc: tytso@mit.edu; jaegeuk@kernel.org; linux-fscrypt@vger.kernel.org
> > Subject: Re: [PATCH] fscrypt: don't set policy for a dead directory
> > 
> > Hi,
> > 
> > On Tue, May 07, 2019 at 12:41:48PM +0800, hongjiefang wrote:
> > > if the directory had been removed, should not set policy for it.
> > >
> > > Signed-off-by: hongjiefang <hongjiefang@asrmicro.com>
> > 
> > Can you explain the motivation for this change?  It makes some sense, but I
> > don't see why it's really needed.  If you look at all the other IS_DEADDIR()
> > checks in the kernel, they're not for operations on the directory inode itself,
> > but rather for creating/finding/listing entries in the directory.  I think
> > FS_IOC_SET_ENCRYPTION_POLICY is more like the former (though it does have to
> > check whether the directory is empty).
> 
> I met a panic issue when run the syzkaller on kernel 4.14.81(EXT4 FBE enabled).
> the flow of case as follow:
> r0 = openat$dir(0xffffffffffffff9c, &(0x7f0000000000)='.\x00', 0x0, 0x0)
> mkdirat(r0, &(0x7f0000000040)='./file0\x00', 0x0)
> r1 = openat$dir(0xffffffffffffff9c, &(0x7f0000000140)='./file0\x00', 0x0, 0x0)
> unlinkat(r0, &(0x7f0000000240)='./file0\x00', 0x200)
> ioctl$FS_IOC_SET_ENCRYPTION_POLICY(r1, 0x800c6613, &(0x7f00000000c0)
> ={0x0, @aes128, 0x0, "8acc73da97d6accc"})
> 
> The file0 directory maybe removed before doing FS_IOC_SET_ENCRYPTION_POLICY.
> In this case, fscrypt_ioctl_set_policy()-> ext4_empty_dir() will return the
> " invalid size " and trigger a panic when check the i_size of inode.
> the panic stack as follow:
> PID: 2682   TASK: ffffffc087d18080  CPU: 3   COMMAND: "syz-executor"
>  #0 [ffffffc087d26fc0] panic at ffffff90080dc04c
>  #1 [ffffffc087d27260] ext4_handle_error at ffffff9008689b08
>  #2 [ffffffc087d27290] __ext4_error_inode at ffffff9008689e90
>  #3 [ffffffc087d273f0] ext4_empty_dir at ffffff900865b064
>  #4 [ffffffc087d274d0] fscrypt_ioctl_set_policy at ffffff9008565d70
>  #5 [ffffffc087d27630] ext4_ioctl at ffffff900863105c
>  #6 [ffffffc087d27b00] do_vfs_ioctl at ffffff90084cc440
>  #7 [ffffffc087d27e80] sys_ioctl at ffffff90084cdaf0
>  #8 [ffffffc087d27ff0] el0_svc_naked at ffffff9008084ffc
> 
> So, it need to check the directory status in the fscrypt_ioctl_set_policy().
> 

Okay, this is a real bug, thanks for reporting this!  So ext4_rmdir() sets
i_size = 0, then ext4_empty_dir() reports an error because 'inode->i_size <
EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2)'.  Note that it's actually an ext4
error, not necessarily a panic.  But the fs may be mounted with errors=panic.

This could also be fixed by updating ext4_empty_dir() to allow i_size == 0.  But
we might as well check IS_DEADDIR() in fscrypt_ioctl_set_policy() either way.

Can you please update the commit message to describe the problem, and add:

	Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
	Cc: <stable@vger.kernel.org> # v4.1+

(Another comment below)

> 
> > 
> > > ---
> > >  fs/crypto/policy.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> > > index bd7eaf9..82900a4 100644
> > > --- a/fs/crypto/policy.c
> > > +++ b/fs/crypto/policy.c
> > > @@ -77,6 +77,12 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user
> > *arg)
> > >
> > >  	inode_lock(inode);
> > >
> > > +	/* don't set policy for a dead directory */
> > > +	if (IS_DEADDIR(inode)) {
> > > +		ret = -ENOENT;
> > > +		goto deaddir_out;
> > > +	}
> > > +

This seems a bit misplaced given the actual purpose of the check, and the
comment doesn't help explain it.  How about moving this to just before the
->empty_dir() call, so it's only done when actually setting a new policy?
I think that would make it more obvious:

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index d536889ac31bf..4941fe8471cef 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -81,6 +81,8 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 	if (ret == -ENODATA) {
 		if (!S_ISDIR(inode->i_mode))
 			ret = -ENOTDIR;
+		else if (IS_DEADDIR(inode))
+			ret = -ENOENT;
 		else if (!inode->i_sb->s_cop->empty_dir(inode))
 			ret = -ENOTEMPTY;
 		else

(Then the label below wouldn't be needed, of course.)

> > >  	ret = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
> > >  	if (ret == -ENODATA) {
> > >  		if (!S_ISDIR(inode->i_mode))
> > > @@ -96,6 +102,7 @@ int fscrypt_ioctl_set_policy(struct file *filp, const void __user
> > *arg)
> > >  		ret = -EEXIST;
> > >  	}
> > >
> > > +deaddir_out:
> > >  	inode_unlock(inode);
> > 
> > Call this label 'out_unlock' instead?
> > 
> > >
> > >  	mnt_drop_write_file(filp);
> > > --

Thanks,

- Eric
