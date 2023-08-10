Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965D8777CB7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjHJPvi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 11:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjHJPvh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 11:51:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A451A19F;
        Thu, 10 Aug 2023 08:51:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5F7D421872;
        Thu, 10 Aug 2023 15:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1691682695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vw/d5Li1YPBi3wq5W2joPHwif8vbo2Pps/y8sAbKZJ0=;
        b=wFa9+jnFGUaHHzU64Rsq5DXg4U4SmJMYZI6zU0EkAErlY5cmLl7ia9hw59KykjT5e7fXXI
        k1wqHuOgzJ742H0GnAhpmj1HjLApc2BTXRbVtgdvfRYfb2cdbm3Qm/utZWOLeCY8tLWBzX
        v00SaNhNsnF8n+h1exNElVoIaU+lIaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1691682695;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vw/d5Li1YPBi3wq5W2joPHwif8vbo2Pps/y8sAbKZJ0=;
        b=kcNGuOQWCwI1VWsdzLUYTAY1fiS2qkxHVr1XHsSTXCvxpmIHHpI1K9aMA8CobmXfXl0t0A
        SJYKmupKGlUVA+Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BE11A138E2;
        Thu, 10 Aug 2023 15:51:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uaUrK4YH1WRBKgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 10 Aug 2023 15:51:34 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id fcbfb369;
        Thu, 10 Aug 2023 15:51:31 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 13/16] fscrypt: allow multiple extents to reference
 one info
In-Reply-To: <2fc070a3990716077dee122740f21abcea8121a8.1691505882.git.sweettea-kernel@dorminy.me>
        (Sweet Tea Dorminy's message of "Tue, 8 Aug 2023 13:08:30 -0400")
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
        <2fc070a3990716077dee122740f21abcea8121a8.1691505882.git.sweettea-kernel@dorminy.me>
Date:   Thu, 10 Aug 2023 16:51:31 +0100
Message-ID: <87edkagakc.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:

> btrfs occasionally splits in-memory extents while holding a mutex. This
> means we can't just copy the info, since setting up a new inlinecrypt
> key requires taking a semaphore. Thus adding a mechanism to split
> extents and merely take a new reference on the info is necessary.
>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h |  5 +++++
>  fs/crypto/keysetup.c        | 18 +++++++++++++++++-
>  include/linux/fscrypt.h     |  2 ++
>  3 files changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index cd29c71b4349..03be2c136c0e 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -287,6 +287,11 @@ struct fscrypt_info {
>=20=20
>  	/* Hashed inode number.  Only set for IV_INO_LBLK_32 */
>  	u32 ci_hashed_ino;
> +
> +	/* Reference count. Normally 1, unless a extent info is shared by
> +	 * several virtual extents.
> +	 */
> +	refcount_t refs;
>  };
>=20=20
>  typedef enum {
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index 8d50716bdf11..12c3851b7cd6 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -598,7 +598,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
>  {
>  	struct fscrypt_master_key *mk;
>=20=20
> -	if (!ci)
> +	if (!ci || !refcount_dec_and_test(&ci->refs))
>  		return;
>=20=20
>  	if (ci->ci_enc_key) {
> @@ -686,6 +686,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
>  	crypt_info->ci_inode =3D inode;
>  	crypt_info->ci_sb =3D inode->i_sb;
>  	crypt_info->ci_policy =3D *policy;
> +	refcount_set(&crypt_info->refs, 1);
>  	memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
>=20=20
>  	mode =3D select_encryption_mode(&crypt_info->ci_policy, inode);
> @@ -1046,6 +1047,21 @@ int fscrypt_load_extent_info(struct inode *inode, =
void *buf, size_t len,
>  }
>  EXPORT_SYMBOL_GPL(fscrypt_load_extent_info);
>=20=20
> +/**
> + * fscrypt_get_extent_info_ref() - mark a second extent using the same i=
nfo
> + * @info: the info to be used by another extent
> + *
> + * Sometimes, an existing extent must be split into multiple extents in =
memory.
> + * In such a case, this function allows multiple extents to use the same=
 extent
> + * info without allocating or taking any lock, which is necessary in cer=
tain IO
> + * paths.
> + */
> +void fscrypt_get_extent_info_ref(struct fscrypt_info *info)
> +{
> +	if (info)
> +		refcount_inc(&info->refs);
> +}
> +

There's an EXPORT_SYMBOL_GPL() missing here, right?

Cheers,
--=20
Lu=C3=ADs

>=20
>  /**
>   * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
>   * @inode: an inode being evicted
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index 4ba624beea91..b67054a2c965 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -370,6 +370,8 @@ void fscrypt_free_extent_info(struct fscrypt_info **i=
nfo_ptr);
>  int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
>  			     struct fscrypt_info **info_ptr);
>=20=20
> +void fscrypt_get_extent_info_ref(struct fscrypt_info *info);
> +
>  /* fname.c */
>  int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *=
iname,
>  			  u8 *out, unsigned int olen);
> --=20
>
> 2.41.0
>
