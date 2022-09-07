Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DD55B0F42
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 23:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiIGVi5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 17:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiIGVi4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 17:38:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08E6C2EAE;
        Wed,  7 Sep 2022 14:38:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7FABC341C1;
        Wed,  7 Sep 2022 21:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662586734;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=THuvsEX6UOHMKMNKwub0IrugBP6wvRAwbiWDVHnCrDM=;
        b=0lI6ZXVEqcP9QzS2vmJ5T+zGRVit5Ko5jI+KQ855mhHwgbc6Qy2TUtpao5zQp9wrdGCrLq
        gS2r6DY1WV+z2Wwr9q7OzZqTLRtCXtro81Ygg0adi/MTC7zizItA4K9XgxkxRLblLjNRME
        NZ1A0Mx+W94SXxbxi8IiSu0COMOBug8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662586734;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=THuvsEX6UOHMKMNKwub0IrugBP6wvRAwbiWDVHnCrDM=;
        b=goX4lfIuI8ZQ/ALBw8ubdcTv+tp5oSXhzXI83Ez0KwCk1WMs4J56p2PznWfx9Ru1f9Hohb
        Ttgm17xRuwdtjtDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 31F3C13A66;
        Wed,  7 Sep 2022 21:38:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jm5tC24PGWNFVQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 07 Sep 2022 21:38:54 +0000
Date:   Wed, 7 Sep 2022 23:33:31 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 20/20] btrfs: implement fscrypt ioctls
Message-ID: <20220907213330.GO32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <e7dd2cb0f4eef391566e1e60f05136244a288693.1662420177.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7dd2cb0f4eef391566e1e60f05136244a288693.1662420177.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:35PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> These ioctls allow encryption to be set up.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ioctl.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 708e514aca25..ea1c14b26206 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5457,6 +5457,34 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_get_fslabel(fs_info, argp);
>  	case FS_IOC_SETFSLABEL:
>  		return btrfs_ioctl_set_fslabel(file, argp);
> +	case FS_IOC_SET_ENCRYPTION_POLICY: {
> +		if (!IS_ENABLED(CONFIG_FS_ENCRYPTION))
> +			return -EOPNOTSUPP;
> +		if (sb_rdonly(fs_info->sb))
> +			return -EROFS;
> +		/*
> +		 *  If we crash before we commit, nothing encrypted could have
> +		 * been written so it doesn't matter whether the encrypted
> +		 * state persists.
> +		 */
> +		btrfs_set_fs_incompat(fs_info, FSCRYPT);
> +		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
> +	}
> +	case FS_IOC_GET_ENCRYPTION_POLICY:
> +		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
> +	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
> +		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
> +	case FS_IOC_ADD_ENCRYPTION_KEY:
> +		return fscrypt_ioctl_add_key(file, (void __user *)arg);
> +	case FS_IOC_REMOVE_ENCRYPTION_KEY:
> +		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
> +	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
> +		return fscrypt_ioctl_remove_key_all_users(file,
> +							  (void __user *)arg);
> +	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
> +		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
> +	case FS_IOC_GET_ENCRYPTION_NONCE:
> +		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);

I've looked what ext4 does for the ioctls and there's a check before
each case if the feature is supported, do we need something like that as
well?

>  	case FITRIM:
>  		return btrfs_ioctl_fitrim(fs_info, argp);
>  	case BTRFS_IOC_SNAP_CREATE:
> -- 
> 2.35.1
