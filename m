Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DF36B7FF0
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Mar 2023 19:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCMSJM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 14:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCMSJJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 14:09:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C5B664F1;
        Mon, 13 Mar 2023 11:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FB226142D;
        Mon, 13 Mar 2023 18:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAAAC433EF;
        Mon, 13 Mar 2023 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678730946;
        bh=gS1aOPoH/Fq3TsY+rrYj8smt1ZKE5SHgfZ50AlsYCvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FxuBEL36dLum3cD8BmsyKHHpVRSKrkZ+RaoUWXWZRCbEAc5dP9ourZbZ0YbJUt34Y
         SNI9U+La1bDxORdFJlKNz0BA2sVBuNi2+JguCDG4VTMqoU/oJS4VZCUhYUrJczuTTM
         CKz3y6q9npgLoJQ7KTjkOOLPyM5N+6iM+eQhoUnOpCz5dN2wZPuSXeKq0OYUIBA1yJ
         B9ZvOjIGJkgDPQhjP98j0KCCsW213KF7loK6bjliYFTbHW+0wlbK6Qj6reoQh/z7AJ
         2I3S8pW+wsJKCBdTDpvWSuCs4AMWp6yIw/8kIb1JqFyKw2UD/0UKC0sZnN8vN5/ZTU
         PPVnDVOgESQ6g==
Date:   Mon, 13 Mar 2023 11:09:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fscrypt: new helper function -
 fscrypt_prepare_atomic_open()
Message-ID: <ZA9mwPUg7H/fq0L8@sol.localdomain>
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-2-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230313123310.13040-2-lhenriques@suse.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 13, 2023 at 12:33:09PM +0000, Luís Henriques wrote:
> + * The regular open path will use fscrypt_file_open for that, but in the
> + * atomic open a different approach is required.

This should actually be fscrypt_prepare_lookup, not fscrypt_file_open, right?

> +int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
> +{
> +	int err;
> +
> +	if (!IS_ENCRYPTED(dir))
> +		return 0;
> +
> +	err = fscrypt_get_encryption_info(dir, true);
> +	if (!err && !fscrypt_has_encryption_key(dir)) {
> +		spin_lock(&dentry->d_lock);
> +		dentry->d_flags |= DCACHE_NOKEY_NAME;
> +		spin_unlock(&dentry->d_lock);
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(fscrypt_prepare_atomic_open);
[...]
> +static inline int fscrypt_prepare_atomic_open(struct inode *dir,
> +					      struct dentry *dentry)
> +{
> +	return -EOPNOTSUPP;
> +}

This has different behavior on unencrypted directories depending on whether
CONFIG_FS_ENCRYPTION is enabled or not.  That's bad.

In patch 2, the caller you are introducing has already checked IS_ENCRYPTED().

Also, your kerneldoc comment for fscrypt_prepare_atomic_open() says it is for
*encrypted* directories.

So IMO, just remove the IS_ENCRYPTED() check from the CONFIG_FS_ENCRYPTION
version of fscrypt_prepare_atomic_open().

- Eric
