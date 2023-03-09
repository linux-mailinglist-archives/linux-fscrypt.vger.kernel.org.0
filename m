Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076B26B2CD4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Mar 2023 19:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjCISX0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Mar 2023 13:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCISXZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Mar 2023 13:23:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9FE55072;
        Thu,  9 Mar 2023 10:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D105FB82049;
        Thu,  9 Mar 2023 18:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EBAC433D2;
        Thu,  9 Mar 2023 18:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678386200;
        bh=B8aarlloxQhXvTzMnoHLGVrwoYPf0Qv0vpup1c+r4oY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8UEnwq2li48NXA2lg4Mqv5K5NLCt/ujoHCoZG9K7XTz+0xGKFqya3O4ifPfIwt5b
         1rF8BKVgVDvI3TApMC8yGtK+RB6gc/DnxNQ25/W4RuncQbaZ+dQVVrkDdCQwgnvsS9
         VXQCzVLjVcqth+armh9ConGtkhelsCeUB5dAu6+N/gGDYhUf+hcGaueHpktg+Lv3Ne
         kD2Ybl8bOItUCqFaIxiH2QbEBANYpG6LrCJHSOHF7Ue80e4vmCIsVk1NgPCXEd8HXd
         v+tTXA/fk2EZl1h4MBi+hO8BSJD+vdXmTIEKCEtD0joOw+vMiZVLTuSSkJ6zBheIFu
         gL/0JPZiOIr1A==
Date:   Thu, 9 Mar 2023 10:23:18 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] fscrypt: new helper function -
 __fscrypt_prepare_atomic_open()
Message-ID: <ZAokFixlHwav4oio@sol.localdomain>
References: <20230309121910.18939-1-lhenriques@suse.de>
 <20230309121910.18939-2-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230309121910.18939-2-lhenriques@suse.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 09, 2023 at 12:19:09PM +0000, Luís Henriques wrote:
> This patch introduces a new helper function which prepares an atomic_open.
> Because atomic open can act as a lookup if handed a dentry that is negative,
> we need to set DCACHE_NOKEY_NAME if the key for the parent isn't available.
> 
> The reason for getting the encryption info before checking if the directory
> has the encryption key is because we may have the key available but the
> encryption info isn't yet set (maybe due to a drop_caches).  The regular
> open path will use fscrypt_file_open for that but in the atomic open a
> different approach is required.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>  fs/crypto/hooks.c       | 14 ++++++++++++++
>  include/linux/fscrypt.h |  6 ++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index 7b8c5a1104b5..cbb828ecc5eb 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -117,6 +117,20 @@ int __fscrypt_prepare_readdir(struct inode *dir)
>  }
>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_readdir);
>  
> +int __fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)

Anything exported to filesystems should have a kerneldoc comment.  That would be
a good place to put some of the explanation that you currently have only in the
commit message.

Also, double-underscored functions are not for use by filesystems directly.
Normally the pattern would be to make fscrypt_prepare_atomic_open() an inline
function that checks IS_ENCRYPTED() and calls an out-of-line function
__fscrypt_prepare_atomic_open().  But if it happens to be simpler to make the
caller handle the IS_ENCRYPTED() check in this case, then there should simply be
one function: fscrypt_prepare_atomic_open() (no leading underscores).

> +{
> +	int err = fscrypt_get_encryption_info(dir, true);
> +
> +	if (err || (!err && !fscrypt_has_encryption_key(dir))) {
> +		spin_lock(&dentry->d_lock);
> +		dentry->d_flags |= DCACHE_NOKEY_NAME;
> +		spin_unlock(&dentry->d_lock);
> +	}

Why does DCACHE_NOKEY_NAME need to be set on error?

Also note that the '!err &&' part has no effect.

- Eric
