Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632436C2453
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Mar 2023 23:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCTWQQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 18:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCTWQP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 18:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1EA18B1B;
        Mon, 20 Mar 2023 15:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4521961853;
        Mon, 20 Mar 2023 22:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65091C433D2;
        Mon, 20 Mar 2023 22:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679350572;
        bh=CQ6Jyq/XbuH8Cdz3SMErtDjfK7UfcAFZFSD5D5gNHGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DqD2FJ3Ih1P1ILtnvYDaFrWSSoxkW+K/Sft69RWi5IljbX3vzww1KTjCd5cBaPyxM
         FNo1iltK2V63z5T8q7c024IQTMCboYRxsNg8Tgb6azqC9gRYe0kd8FbeT/e8pw+k9N
         xNkaF+Xj6WRAjMmCn9taZ8l3SsqfnXnvxZxUeBo4UXMKIw/RYPtSUeap+R4quhq2dx
         Qw4AXUDKoDG38zehbR8czWqziPHWtoFwDazKdWZ2ciqnD7aB+4Y/xXNKFsZzl/yMgF
         ZkWtosYCxLSX8lm/zWtU8MimGrCVs4MMLoTQYNye4AayqWimeK9SryQQ2HjYB/fFSt
         iqvPMluWXv/Pw==
Date:   Mon, 20 Mar 2023 15:16:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] ceph: fscrypt: fix atomic open bug for encrypted
 directories
Message-ID: <20230320221609.GA21979@sol.localdomain>
References: <20230316181413.26916-1-lhenriques@suse.de>
 <568da52f-18a6-5f96-cd51-5b07dedefb2d@redhat.com>
 <CAOi1vP9QsbSUq9JNRcpQpV3XWM2Eurhk+6AkDDNmks5PLTx3YQ@mail.gmail.com>
 <0b51da52-bb38-2094-b9b2-bc3858066be5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b51da52-bb38-2094-b9b2-bc3858066be5@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 20, 2023 at 08:47:18PM +0800, Xiubo Li wrote:
> 
> On 20/03/2023 19:20, Ilya Dryomov wrote:
> > On Mon, Mar 20, 2023 at 2:07 AM Xiubo Li <xiubli@redhat.com> wrote:
> > > 
> > > On 17/03/2023 02:14, Luís Henriques wrote:
> > > > Hi!
> > > > 
> > > > I started seeing fstest generic/123 failing in ceph fscrypt, when running it
> > > > with 'test_dummy_encryption'.  This test is quite simple:
> > > > 
> > > > 1. Creates a directory with write permissions for root only
> > > > 2. Writes into a file in that directory
> > > > 3. Uses 'su' to try to modify that file as a different user, and
> > > >      gets -EPERM
> > > > 
> > > > All the test steps succeed, but the test fails to cleanup: 'rm -rf <dir>'
> > > > will fail with -ENOTEMPTY.  'strace' shows that calling unlinkat() to remove
> > > > the file got a -ENOENT and then -ENOTEMPTY for the directory.
> > > > 
> > > > This is because 'su' does a drop_caches ('su (874): drop_caches: 2' in
> > > > dmesg), and ceph's atomic open will do:
> > > > 
> > > >        if (IS_ENCRYPTED(dir)) {
> > > >                set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> > > >                if (!fscrypt_has_encryption_key(dir)) {
> > > >                        spin_lock(&dentry->d_lock);
> > > >                        dentry->d_flags |= DCACHE_NOKEY_NAME;
> > > >                        spin_unlock(&dentry->d_lock);
> > > >                }
> > > >        }
> > > > 
> > > > Although 'dir' has the encryption key available, fscrypt_has_encryption_key()
> > > > will return 'false' because fscrypt info isn't yet set after the cache
> > > > cleanup.
> > > > 
> > > > The first patch will add a new helper for the atomic_open that will force
> > > > the fscrypt info to be loaded into an inode that has been evicted recently
> > > > but for which the key is still available.
> > > > 
> > > > The second patch switches ceph atomic_open to use the new fscrypt helper.
> > > > 
> > > > Cheers,
> > > > --
> > > > Luís
> > > > 
> > > > Changes since v2:
> > > > - Make helper more generic and to be used both in lookup and atomic open
> > > >     operations
> > > > - Modify ceph_lookup (patch 0002) and ceph_atomic_open (patch 0003) to use
> > > >     the new helper
> > > > 
> > > > Changes since v1:
> > > > - Dropped IS_ENCRYPTED() from helper function because kerneldoc says
> > > >     already that it applies to encrypted directories and, most importantly,
> > > >     because it would introduce a different behaviour for
> > > >     CONFIG_FS_ENCRYPTION and !CONFIG_FS_ENCRYPTION.
> > > > - Rephrased helper kerneldoc
> > > > 
> > > > Changes since initial RFC (after Eric's review):
> > > > - Added kerneldoc comments to the new fscrypt helper
> > > > - Dropped '__' from helper name (now fscrypt_prepare_atomic_open())
> > > > - Added IS_ENCRYPTED() check in helper
> > > > - DCACHE_NOKEY_NAME is not set if fscrypt_get_encryption_info() returns an
> > > >     error
> > > > - Fixed helper for !CONFIG_FS_ENCRYPTION (now defined 'static inline')
> > > This series looks good to me.
> > > 
> > > And I have run the test locally and worked well.
> > > 
> > > 
> > > > Luís Henriques (3):
> > > >     fscrypt: new helper function - fscrypt_prepare_lookup_partial()
> > > Eric,
> > > 
> > > If possible I we can pick this together to ceph repo and need your ack
> > > about this. Or you can pick it to the crypto repo then please feel free
> > > to add:
> > > 
> > > Tested-by: Xiubo Li <xiubli@redhat.com> and Reviewed-by: Xiubo Li
> > > <xiubli@redhat.com>
> > I would prefer the fscrypt helper to go through the fscrypt tree.
> 
> Sure. This also LGTM.
> 
> Thanks
> 

I've applied it to
https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=for-next

But I ended up reworking the comment a bit and moving the function to be just
below __fscrypt_prepare_lookup().  So I sent out v4 that matches what I applied.

BTW, I'm wondering if anyone has had any thoughts about the race condition I
described at https://lore.kernel.org/r/ZBC1P4Gn6eAKD61+@sol.localdomain/.  In
particular, I'm wondering whether this helper function will need to be changed
or not.  Maybe not, because ceph could look at DCACHE_NOKEY_NAME to determine
whether the name should be treated as a no-key name or not, instead of checking
fscrypt_has_encryption_key() again (as I think it is doing currently)?

- Eric
