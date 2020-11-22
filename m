Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FA42BC3A9
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Nov 2020 06:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgKVFMk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Nov 2020 00:12:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbgKVFMj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Nov 2020 00:12:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606021957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kkf8a6qy5yhhSG9mvfioRD8ySsdwKXfzz3BkGnvDRY4=;
        b=XYb82dh9zqLCQACkLtEv1KegeDZ7BXKLgOZOd0K1i8ULcb4qwWKGhTOHAiBe9B28GpTud+
        xzQWJjweDj5jZMtE22/QNXGChIBx4U8XhlOYEqFgluht3C6mx23n2RC6d5BzkM6K148112
        HM9BwjgfldT0C9uZ8ek9edZLkj0/MNY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-lnShjyhKPS6YO57qQqOJRg-1; Sun, 22 Nov 2020 00:12:34 -0500
X-MC-Unique: lnShjyhKPS6YO57qQqOJRg-1
Received: by mail-pf1-f198.google.com with SMTP id c24so2106613pfd.13
        for <linux-fscrypt@vger.kernel.org>; Sat, 21 Nov 2020 21:12:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kkf8a6qy5yhhSG9mvfioRD8ySsdwKXfzz3BkGnvDRY4=;
        b=J8UDKj0hz8ozxvUEDz7z39mN9QK8WuAp7KAm+85l0hUWAovvsWp/vFeHXbBXiHXXRa
         /UaPx4uvccvX6Rc4tmbsScStwilp50MxpbAHm1+zjfQeByAD9EuRMoRk+Bwd1u3852f9
         KMhNTUTefz4Akjf0Nzj9idsjfmXslBwiTVO+F4K8CpOBeVVgOCm5JBhBXswu6y586DY9
         ZNNxDBRDxXiG2iWXLSgGiDW+dLCGaCp6US2lJfmyBvHvd5IaJuAAlKOHoIJcF+kcObVU
         iOu6Xy7bxySz4Kt9bd2uei+ZVABWKCI6NyObD7S3qdO4vqXCcr0qkQrJlGLWT87qDjpa
         THBw==
X-Gm-Message-State: AOAM532cn2oQtcfjCaRTptVFzltvAkeWX+YrT3Dve8QPUmZM7KV2HDqe
        KJM1mXPvfm2PgjkQioSdSAwClryYNeEc69lb0z3lQgFd13zpPW6Nyrcg2t0b8nPLg3KHDsxDdZK
        vpbAjg7p06J3yu4Gcs0/puFy/CQ==
X-Received: by 2002:a63:4513:: with SMTP id s19mr22764163pga.254.1606021953658;
        Sat, 21 Nov 2020 21:12:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhkBDDpVzvwVvP6QvR7b7bk5JCtZ4ytNenw2ZosC6tbrjTUa7xakgrk4oLyDhCHqqDiw3bXw==
X-Received: by 2002:a63:4513:: with SMTP id s19mr22764154pga.254.1606021953454;
        Sat, 21 Nov 2020 21:12:33 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b21sm9346038pji.24.2020.11.21.21.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 21:12:33 -0800 (PST)
Date:   Sun, 22 Nov 2020 13:12:18 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chao Yu <chao@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4 2/3] fscrypt: Have filesystems handle their d_ops
Message-ID: <20201122051218.GA2717478@xiangao.remote.csb>
References: <20201119060904.463807-1-drosen@google.com>
 <20201119060904.463807-3-drosen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201119060904.463807-3-drosen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi all,

On Thu, Nov 19, 2020 at 06:09:03AM +0000, Daniel Rosenberg wrote:
> This shifts the responsibility of setting up dentry operations from
> fscrypt to the individual filesystems, allowing them to have their own
> operations while still setting fscrypt's d_revalidate as appropriate.
> 
> Most filesystems can just use generic_set_encrypted_ci_d_ops, unless
> they have their own specific dentry operations as well. That operation
> will set the minimal d_ops required under the circumstances.
> 
> Since the fscrypt d_ops are set later on, we must set all d_ops there,
> since we cannot adjust those later on. This should not result in any
> change in behavior.
> 
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> Acked-by: Eric Biggers <ebiggers@google.com>
> ---

...

>  extern const struct file_operations ext4_dir_operations;
>  
> -#ifdef CONFIG_UNICODE
> -extern const struct dentry_operations ext4_dentry_ops;
> -#endif
> -
>  /* file.c */
>  extern const struct inode_operations ext4_file_inode_operations;
>  extern const struct file_operations ext4_file_operations;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 33509266f5a0..12a417ff5648 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1614,6 +1614,7 @@ static struct buffer_head *ext4_lookup_entry(struct inode *dir,
>  	struct buffer_head *bh;
>  
>  	err = ext4_fname_prepare_lookup(dir, dentry, &fname);
> +	generic_set_encrypted_ci_d_ops(dentry);

One thing might be worth noticing is that currently overlayfs might
not work properly when dentry->d_sb->s_encoding is set even only some
subdirs are CI-enabled but the others not, see generic_set_encrypted_ci_d_ops(),
ovl_mount_dir_noesc => ovl_dentry_weird()

For more details, see:
https://android-review.googlesource.com/c/device/linaro/hikey/+/1483316/2#message-2e1f6ab0010a3e35e7d8effea73f60341f84ee4d

Just found it by chance (and not sure if it's vital for now), and
a kind reminder about this.

Thanks,
Gao Xiang

