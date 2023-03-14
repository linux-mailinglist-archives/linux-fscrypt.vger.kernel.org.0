Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0209C6B9DA2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 18:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCNR4U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Mar 2023 13:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCNR4U (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Mar 2023 13:56:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFFC125A5;
        Tue, 14 Mar 2023 10:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED1461876;
        Tue, 14 Mar 2023 17:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D20AC433D2;
        Tue, 14 Mar 2023 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816577;
        bh=GX4dlDMgUaHYRF+PdcM/afh8DXK+G9ABWRwC0IDhSAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SHToTRDRJ8uu0qxCjQmBZgj5+lDlV226SxSgFbtyKGPxBvGRsl0WGxZtfsy6McrWs
         vRF7PNkl6YAP7NugiEb4iCrSQxS11CjRO4nY6/mIeATk+U/eeaHQsYU36l+/R408IZ
         E2xMZbaEgkFkyAHbjCDzq07VHaX18e7KH4iThrNu8uJ74+gRys5qO8ikRP6e17tqQx
         JVYssmxscSETBryWO8kKB3nYgkHlZNwv3VapmoGO/ZRXn/BR/2dptXZFiaXtDAmrD1
         mV422QO0K5Vnrye4JNicBgvA767iT1hQpFF4VqHtdOWfmhqeQq6ozo9oBeEfMHzSTX
         Qgxdv6/63NEvg==
Date:   Tue, 14 Mar 2023 10:56:15 -0700
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
Message-ID: <ZBC1P4Gn6eAKD61+@sol.localdomain>
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-2-lhenriques@suse.de>
 <ZA9mwPUg7H/fq0L8@sol.localdomain>
 <87zg8ftz9s.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zg8ftz9s.fsf@suse.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 14, 2023 at 10:15:11AM +0000, Luís Henriques wrote:
> Eric Biggers <ebiggers@kernel.org> writes:
> 
> > On Mon, Mar 13, 2023 at 12:33:09PM +0000, Luís Henriques wrote:
> >> + * The regular open path will use fscrypt_file_open for that, but in the
> >> + * atomic open a different approach is required.
> >
> > This should actually be fscrypt_prepare_lookup, not fscrypt_file_open, right?
> 
> Ups, I missed this comment.
> 
> I was comparing the regular open() with the atomic_open() paths.  I think
> I really mean fscrypt_file_open() because that's where the encryption info
> is (or may be) set by calling fscrypt_require_key().  atomic_open needs
> something similar, but combined with a lookup.
> 
> Maybe I can rephrase it to:
> 
>   The reason for getting the encryption info before checking if the
>   directory has the encryption key is because the key may be available but
>   the encryption info isn't yet set (maybe due to a drop_caches).  The
>   regular open path will call fscrypt_file_open which uses function
>   fscrypt_require_key for setting the encryption info if needed.  The
>   atomic open needs to do something similar.
> 

No, regular open is two parts: ->lookup and ->open.  fscrypt_prepare_lookup()
sets up the directory's key, whereas fscrypt_file_open() sets up the file's key.

Your proposed fscrypt_prepare_atomic_open() sets up the directory's key.  So it
is really fscrypt_prepare_lookup() that is its equivalent.

However, that raises the question of why doesn't ceph just use
fscrypt_prepare_lookup()?  It seems the answer is that ceph wants to handle the
filenames encryption and no-key name encoding itself.  And for that reason, its
->lookup() does the following and does *not* use fscrypt_prepare_lookup():

	if (IS_ENCRYPTED(dir)) {
		err = ceph_fscrypt_prepare_readdir(dir);
		if (err < 0)
			return ERR_PTR(err);
		if (!fscrypt_has_encryption_key(dir)) {
			spin_lock(&dentry->d_lock);
			dentry->d_flags |= DCACHE_NOKEY_NAME;
			spin_unlock(&dentry->d_lock);
		}
	}

So, actually I think this patch doesn't make sense.  If ceph is doing the above
in its ->lookup() anyway, then it just should do the exact same thing in its
->atomic_open() too.

If you want to add a new fscrypt_* helper function which *just* sets up the
given directory's key and sets the NOKEY_NAME flag on the given dentry
accordingly, that could make sense.  However, it should be called from *both*
->lookup() and ->atomic_open(), not just ->atomic_open().

It's also worth mentioning that setting up the filename separately from the
NOKEY_NAME flag makes ceph have the same race condition that I had fixed for the
other filesystems in commit b01531db6cec ("fscrypt: fix race where ->lookup()
marks plaintext dentry as ciphertext").  It's not a huge deal, but it can cause
some odd behavior, so it's worth thinking about whether it can be solved.

- Eric
