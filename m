Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A71659367
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 00:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbiL2Xxh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Dec 2022 18:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiL2Xxh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Dec 2022 18:53:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33E4BE20;
        Thu, 29 Dec 2022 15:53:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A13A8B81A27;
        Thu, 29 Dec 2022 23:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A96C433D2;
        Thu, 29 Dec 2022 23:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672358013;
        bh=Ju4DjdS/HXzTD3IM5c13zn2ojMGH+90pId7bhFor3g8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8I0mmE07QTCYnbEnV8BP34qV5rPxZx69zp9scI0sn6l3Zh+P554ALo30LKk5JMsD
         Mo95ApIr9VNzs2V0ewPVpm7NOngVxuSzTGAGHTx8I7Dl8k3z95w9OCvrCp0yWIvlaS
         6oIh3pt7889A3UoDonfuf+JB1B1PoR0MFC47A0aeq1LCKVxDlYu+GDJP+zklIOUxQX
         qSsMzMd1e6Xce/Jbo/ZO6y/EZmpbOJA8VfEe4gnYC3yVqIt0sJBEIhJ5Ria9WsG8Oq
         bZmWSRU7VrFm1OCI7vwdq0ziQ7V3JSe7EL19jnjeVWIfgJFPbuyo2AGDQeM9GrURS9
         wGnBUcyjhsqgg==
Date:   Thu, 29 Dec 2022 15:53:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ceph: make sure all the files successfully put before
 unmounting
Message-ID: <Y64oe9c9U1+Y98yt@sol.localdomain>
References: <20221201065800.18149-1-xiubli@redhat.com>
 <Y4j+Ccqzi6JxWchv@sol.localdomain>
 <Y4kYN8FPeq6NDe5i@gmail.com>
 <b30e579d-6919-d35b-aaa5-b71129a32810@redhat.com>
 <Y4l8vDmKIpypc8I3@sol.localdomain>
 <c0925b4f-ef5f-31fc-1bd0-05fa097b6b34@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0925b4f-ef5f-31fc-1bd0-05fa097b6b34@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Xiubo,

On Fri, Dec 02, 2022 at 03:04:58PM +0800, Xiubo Li wrote:
> 
> On 02/12/2022 12:19, Eric Biggers wrote:
> > On Fri, Dec 02, 2022 at 09:49:49AM +0800, Xiubo Li wrote:
> > > On 02/12/2022 05:10, Eric Biggers wrote:
> > > > On Thu, Dec 01, 2022 at 11:18:33AM -0800, Eric Biggers wrote:
> > > > > On Thu, Dec 01, 2022 at 02:58:00PM +0800, xiubli@redhat.com wrote:
> > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > > 
> > > > > > When close a file it will be deferred to call the fput(), which
> > > > > > will hold the inode's i_count. And when unmounting the mountpoint
> > > > > > the evict_inodes() may skip evicting some inodes.
> > > > > > 
> > > > > > If encrypt is enabled the kernel generate a warning when removing
> > > > > > the encrypt keys when the skipped inodes still hold the keyring:
> > > > > This does not make sense.  Unmounting is only possible once all the files on the
> > > > > filesystem have been closed.
> > > > > 
> > > > Specifically, __fput() puts the reference to the dentry (and thus the inode)
> > > > *before* it puts the reference to the mount.  And an unmount cannot be done
> > > > while the mount still has references.  So there should not be any issue here.
> > > Eric,
> > > 
> > > When I unmounting I can see the following logs, which I added a debug log in
> > > the evcit_inodes():
> > > 
> > > diff --git a/fs/inode.c b/fs/inode.c
> > > index b608528efd3a..f6e69b778d9c 100644
> > > --- a/fs/inode.c
> > > +++ b/fs/inode.c
> > > @@ -716,8 +716,11 @@ void evict_inodes(struct super_block *sb)
> > >   again:
> > >          spin_lock(&sb->s_inode_list_lock);
> > >          list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
> > > -               if (atomic_read(&inode->i_count))
> > > +               if (atomic_read(&inode->i_count)) {
> > > +                       printk("evict_inodes inode %p, i_count = %d, was
> > > skipped!\n",
> > > +                              inode, atomic_read(&inode->i_count));
> > >                          continue;
> > > +               }
> > > 
> > >                  spin_lock(&inode->i_lock);
> > >                  if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
> > > 
> > > The logs:
> > > 
> > > <4>[   95.977395] evict_inodes inode 00000000f90aab7b, i_count = 1, was
> > > skipped!
> > > 
> > > Any reason could cause this ? Since the inode couldn't be evicted in time
> > > and then when removing the master keys it will print this warning.
> > > 
> > It is expected for evict_inodes() to see some inodes with nonzero refcount, but
> > they should only be filesystem internal inodes.  For example, with ext4 this
> > happens with the journal inode.
> > 
> > However, filesystem internal inodes cannot be encrypted, so they are irrelevant
> > here.
> > 
> > I'd guess that CephFS has a bug where it is leaking a reference to a user inode
> > somewhere.
> 
> I also added some debug logs to tracker all the inodes in ceph, and all the
> requests has been finished.
> 
> I will debug it more to see whether it's leaking a reference here.
> 
> Thanks Eric.
> 

Any progress on tracking this down?

- Eric
