Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25917756824
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 17:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjGQPj7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 11:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjGQPj6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 11:39:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B69A1;
        Mon, 17 Jul 2023 08:39:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9582F21921;
        Mon, 17 Jul 2023 15:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689608396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=7LRYDu1aJK6pGfatdY+PZC7G13BOWgbr8I0EbgOfdU8=;
        b=ArvNbEg7cqSzNpL9CuuCcVIPThTaf8Mn9YzzNHMdQFk5zzX0Q+TsPkyoVVPwLNC0lmp4Wp
        nOan5BnEp11oN/c2JhgRZPGnKmfCg/16Gvn3Ic6seoCmR7xrA89VJbsrVdN1xqKjJFYq3y
        q9jbxBE09VQ1JGqdNQiD+KFSQznyxjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689608396;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=7LRYDu1aJK6pGfatdY+PZC7G13BOWgbr8I0EbgOfdU8=;
        b=bwvvYcUse/XORgA6oDuS0GT6lMrUMFZUNF0TEeXNjn99PlV7OW+k0Tzj/xC3pNDgmEXLMP
        hBHnDAFuCqkEdNAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E412F13276;
        Mon, 17 Jul 2023 15:39:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mTF5NMtgtWTpFAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 17 Jul 2023 15:39:55 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id fcaa553e;
        Mon, 17 Jul 2023 15:39:55 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs?= Henriques <lhenriques@suse.de>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 12/17] btrfs: turn on inlinecrypt mount option for
 encrypt
Date:   Mon, 17 Jul 2023 16:34:42 +0100
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
        <303b721e0c738ebb8ee3ada3d4b867a07d6d5bfb.1689564024.git.sweettea-kernel@dorminy.me>
Message-ID: <87wmyyv96c.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:

> fscrypt's extent encryption requires the use of inline encryption or the
> software fallback that the block layer provides; it is rather
> complicated to allow software encryption with extent encryption due to
> the timing of memory allocations. Thus, if btrfs has ever had a
> encrypted file, or when encryption is enabled on a directory, update the
> mount flags to include inlinecrypt.
>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ioctl.c |  4 ++++
>  fs/btrfs/super.c | 10 ++++++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 91ad59519900..11866a88e33f 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4574,6 +4574,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		 * state persists.
>  		 */
>  		btrfs_set_fs_incompat(fs_info, ENCRYPT);
> +		if (!(inode->i_sb->s_flags & SB_INLINECRYPT)) {
> +			inode->i_sb->s_flags |=3D SB_INLINECRYPT;
> +			mb();

I've no idea this mb() is needed here, but I know it's usually a good
practice to document why it is needed.

Cheers,
--=20
Lu=C3=ADs

> +		}
>  		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
>  	}
>  	case FS_IOC_GET_ENCRYPTION_POLICY:
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 0cc9c2909f64..1e9a93c6750a 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1165,6 +1165,16 @@ static int btrfs_fill_super(struct super_block *sb,
>  		return err;
>  	}
>=20=20
> +	if (btrfs_fs_incompat(fs_info, ENCRYPT)) {
> +		if (IS_ENABLED(CONFIG_FS_ENCRYPTION_INLINE_CRYPT)) {
> +			sb->s_flags |=3D SB_INLINECRYPT;
> +		} else {
> +			btrfs_err(fs_info, "encryption not supported");
> +			err =3D -EINVAL;
> +			goto fail_close;
> +		}
> +	}
> +
>  	inode =3D btrfs_iget(sb, BTRFS_FIRST_FREE_OBJECTID, fs_info->fs_root);
>  	if (IS_ERR(inode)) {
>  		err =3D PTR_ERR(inode);
> --=20
>
> 2.40.1
>

