Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61ECE2869FD
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Oct 2020 23:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgJGVUy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Oct 2020 17:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727798AbgJGVUy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Oct 2020 17:20:54 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08952083B;
        Wed,  7 Oct 2020 21:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602105654;
        bh=zenTSMmmb5eoRKiXCYgBR26ANJMtA08lFO4cBuL9ebw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mBsJfroYtovwhJx/hZzE6EiVmQp8z2bwboXPwbY3mPrt7JG9O2mySDQHT+Tm5qxzP
         O674Ww+cCnufqlNRk6YUyA9CXZj6VKEJkOqik4Qa/nQ9+xpWDXFfZyBueAKFMCTKE/
         7zImGzySs7JGLKEhB9Zm41gorW65f8m9A46g8EwI=
Date:   Wed, 7 Oct 2020 14:20:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/3] f2fs: Add metadata encryption support
Message-ID: <20201007212052.GC1530638@gmail.com>
References: <20201005073606.1949772-1-satyat@google.com>
 <20201005073606.1949772-4-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005073606.1949772-4-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 05, 2020 at 07:36:06AM +0000, Satya Tangirala wrote:
> Wire up metadata encryption support with the fscrypt metadata crypt
> additions.
> 
> Introduces a new mount option for metadata encryption -
> metadata_crypt_key=%s. The argument to this option is the key descriptor of
> the metadata encryption key in hex. 

It's unclear what "key descriptor in hex" means in this context.  Keys in the
Linux keyrings subsystem can be specified either by an integer ID or by a string
"description".

fscrypt_policy_v1 has an 8-byte binary master_key_descriptor, which specifies a
keyring key with description "fscrypt:" + ToHex(master_key_descriptor).  So I'm
guessing that's where this terminology is coming from.

However, here the value passed to metadata_crypt_key is just a key description
that's passed directly to the Linux keyrings subsystem.  I don't see why it has
to be a hex string (and it fact, it seems it's not enforced?).

The current proposal is also missing any sort of key verification.  The
filesystem will use any key that is provided, even if a different key was used
at format time.

In "fscrypt v2", we solved the equivalent problem by making the keys be
specified by a HKDF-derived master_key_identifier.

How about doing something similar for the metadata encryption key?  I.e. the
metadata encryption key could be used as input to HKDF to derive two subkeys:
metadata_key_identifier and the real metadata encryption key.  Then
metadata_key_identifier could be stored in the superblock.  Then the filesystem
could request the keyring key "fscrypt:" + ToHex(metadata_key_identifier) at
mount time, which would eliminate the need for a mount option.

> Direct I/O with metadata encryption is also not supported for now.
> Attempts to do direct I/O on a metadata encrypted F2FS filesystem will fall
> back to using buffered I/O (just as attempts to do direct I/O on fscrypt
> encrypted files also fall back to buffered I/O).

What would it take to get direct I/O working?

> +#ifdef CONFIG_FS_ENCRYPTION_METADATA
> +	if (metadata_crypt_alg &&
> +	    !fscrypt_metadata_crypted(sb)) {
> +		f2fs_err(sbi, "Filesystem has metadata encryption. Please provide metadata encryption key to mount filesystem");
> +		return -EINVAL;
> +	}
> +#endif

Please try to avoid #ifdefs.  It looks like some of these could be replaced with
IS_ENABLED() or the use of stub functions.

- Eric
