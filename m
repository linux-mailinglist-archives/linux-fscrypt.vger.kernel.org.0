Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD763FF6D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  2 Dec 2022 05:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiLBETW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 23:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiLBETT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 23:19:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5196ED15B6;
        Thu,  1 Dec 2022 20:19:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E527D60F8B;
        Fri,  2 Dec 2022 04:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF0FC433D6;
        Fri,  2 Dec 2022 04:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669954750;
        bh=8DmLndQn9pLyv0FE2h9/xpF/YzmFtX/FOcDvsNWWpvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sf59McGYY3EjPAy8vCtg2JYw8uhjPXwKfuEKWcHyekI7YHnD6xhMmviGy3Zn6QsIR
         L1KfX8Jb38vkHA3wK4jI1KIbpbGpbylUTpWyuS3AZ7J0v3seDKzPmxcT5Scwm/hMh3
         3DJp8s3BxDwFfTHPGyLbsrJvmQz8M+E7vN+xvOppKpwSMwfJpNcMsHyQG2DnsseDcE
         BVuuTdQogah5WH8Orr89YwgPH7uaFftdaAmcGscuOKE1Fm+7UT/AXvv41ojs/PEsk/
         arZSm6dS/6p33Z8C29m6122KrhMbZUfhUMQO24uUMT8ail0upt1hxWdezcN+DGIqHC
         +sOtoM/eVWBAw==
Date:   Thu, 1 Dec 2022 20:19:08 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ceph: make sure all the files successfully put before
 unmounting
Message-ID: <Y4l8vDmKIpypc8I3@sol.localdomain>
References: <20221201065800.18149-1-xiubli@redhat.com>
 <Y4j+Ccqzi6JxWchv@sol.localdomain>
 <Y4kYN8FPeq6NDe5i@gmail.com>
 <b30e579d-6919-d35b-aaa5-b71129a32810@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b30e579d-6919-d35b-aaa5-b71129a32810@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Dec 02, 2022 at 09:49:49AM +0800, Xiubo Li wrote:
> 
> On 02/12/2022 05:10, Eric Biggers wrote:
> > On Thu, Dec 01, 2022 at 11:18:33AM -0800, Eric Biggers wrote:
> > > On Thu, Dec 01, 2022 at 02:58:00PM +0800, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > > 
> > > > When close a file it will be deferred to call the fput(), which
> > > > will hold the inode's i_count. And when unmounting the mountpoint
> > > > the evict_inodes() may skip evicting some inodes.
> > > > 
> > > > If encrypt is enabled the kernel generate a warning when removing
> > > > the encrypt keys when the skipped inodes still hold the keyring:
> > > This does not make sense.  Unmounting is only possible once all the files on the
> > > filesystem have been closed.
> > > 
> > Specifically, __fput() puts the reference to the dentry (and thus the inode)
> > *before* it puts the reference to the mount.  And an unmount cannot be done
> > while the mount still has references.  So there should not be any issue here.
> 
> Eric,
> 
> When I unmounting I can see the following logs, which I added a debug log in
> the evcit_inodes():
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index b608528efd3a..f6e69b778d9c 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -716,8 +716,11 @@ void evict_inodes(struct super_block *sb)
>  again:
>         spin_lock(&sb->s_inode_list_lock);
>         list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
> -               if (atomic_read(&inode->i_count))
> +               if (atomic_read(&inode->i_count)) {
> +                       printk("evict_inodes inode %p, i_count = %d, was
> skipped!\n",
> +                              inode, atomic_read(&inode->i_count));
>                         continue;
> +               }
> 
>                 spin_lock(&inode->i_lock);
>                 if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
> 
> The logs:
> 
> <4>[   95.977395] evict_inodes inode 00000000f90aab7b, i_count = 1, was
> skipped!
> 
> Any reason could cause this ? Since the inode couldn't be evicted in time
> and then when removing the master keys it will print this warning.
> 

It is expected for evict_inodes() to see some inodes with nonzero refcount, but
they should only be filesystem internal inodes.  For example, with ext4 this
happens with the journal inode.

However, filesystem internal inodes cannot be encrypted, so they are irrelevant
here.

I'd guess that CephFS has a bug where it is leaking a reference to a user inode
somewhere.

(Based on the code, it might also be possible for evict_inodes() to also see
nonzero refcount inodes due to fsnotify.  However, fsnotify_sb_delete() runs
before fscrypt_destroy_keyring(), so likewise it seems irrelevant here.)

- Eric
