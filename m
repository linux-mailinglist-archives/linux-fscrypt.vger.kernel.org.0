Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F304D6B887B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 03:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCNCZu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 22:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCNCZt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 22:25:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B2C9271A;
        Mon, 13 Mar 2023 19:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBF8FB81185;
        Tue, 14 Mar 2023 02:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330DAC433EF;
        Tue, 14 Mar 2023 02:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678760745;
        bh=P0ezneI5X8CeksDVdkTeZD98KMa41KNfiE8mhEHmDWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IDy6DWnGHugfVC9bvWa0leDh5BS06noWGcohLXISN2mi8U7k6UpbnzUyUvzhh/6Yr
         BeZjA5DNDxWjfQG2Tp2JQA5ONeLTeChOKzz+Iqrk7Ss/LtaV0lKp6+uxzFJBfYjHRj
         cEEDs2oUq2pvtqHKRAQB/MzT/VccwCavR8juaqar8VH8lUYqb+Vh5eSyyE8brIFzkS
         4G+X1ou3oODj5w/Zy2mZBKcof7qRFO9eqW3QmO/C1Vmr/LlLOnGmcV/znKrTOYkDEa
         SyloU/iRrxaqudvs4PbzjCTUbxjPcxSPeFN0xOVmfKRDzxPHXjNLIcEYvFx45lZUIr
         +0SHbYpi6wCOQ==
Date:   Mon, 13 Mar 2023 19:25:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fscrypt: new helper function -
 fscrypt_prepare_atomic_open()
Message-ID: <ZA/bJ+BNEAIsunsG@sol.localdomain>
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-2-lhenriques@suse.de>
 <ZA9mwPUg7H/fq0L8@sol.localdomain>
 <f72cf7fe-f489-47f2-fab9-be9eee441fca@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f72cf7fe-f489-47f2-fab9-be9eee441fca@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 14, 2023 at 08:53:51AM +0800, Xiubo Li wrote:
> 
> On 14/03/2023 02:09, Eric Biggers wrote:
> > On Mon, Mar 13, 2023 at 12:33:09PM +0000, Luís Henriques wrote:
> > > + * The regular open path will use fscrypt_file_open for that, but in the
> > > + * atomic open a different approach is required.
> > This should actually be fscrypt_prepare_lookup, not fscrypt_file_open, right?
> > 
> > > +int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
> > > +{
> > > +	int err;
> > > +
> > > +	if (!IS_ENCRYPTED(dir))
> > > +		return 0;
> > > +
> > > +	err = fscrypt_get_encryption_info(dir, true);
> > > +	if (!err && !fscrypt_has_encryption_key(dir)) {
> > > +		spin_lock(&dentry->d_lock);
> > > +		dentry->d_flags |= DCACHE_NOKEY_NAME;
> > > +		spin_unlock(&dentry->d_lock);
> > > +	}
> > > +
> > > +	return err;
> > > +}
> > > +EXPORT_SYMBOL_GPL(fscrypt_prepare_atomic_open);
> > [...]
> > > +static inline int fscrypt_prepare_atomic_open(struct inode *dir,
> > > +					      struct dentry *dentry)
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > This has different behavior on unencrypted directories depending on whether
> > CONFIG_FS_ENCRYPTION is enabled or not.  That's bad.
> > 
> > In patch 2, the caller you are introducing has already checked IS_ENCRYPTED().
> > 
> > Also, your kerneldoc comment for fscrypt_prepare_atomic_open() says it is for
> > *encrypted* directories.
> > 
> > So IMO, just remove the IS_ENCRYPTED() check from the CONFIG_FS_ENCRYPTION
> > version of fscrypt_prepare_atomic_open().
> 
> IMO we should keep this check in fscrypt_prepare_atomic_open() to make it
> consistent with the existing fscrypt_prepare_open(). And we can just remove
> the check from ceph instead.
> 

Well, then the !CONFIG_FS_ENCRYPTION version would need to return 0 if
IS_ENCRYPTED() too.

Either way would be okay, but please don't do a mix of both approaches within a
single function, as this patch currently does.

Note that there are other fscrypt_* functions, such as fscrypt_get_symlink(),
that require an IS_ENCRYPTED() inode, so that pattern is not new.

- Eric
