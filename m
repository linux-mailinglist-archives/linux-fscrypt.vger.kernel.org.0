Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598DA75FACB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Jul 2023 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjGXPbN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Jul 2023 11:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjGXPbN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Jul 2023 11:31:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99F5E5A;
        Mon, 24 Jul 2023 08:31:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5B0E81FD7B;
        Mon, 24 Jul 2023 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690212670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6vCGqXuxAtySUa/Hmk/Z1BMteleIzoulc14jakz0RbQ=;
        b=NQaKIC3O6H67kMfoMLCAqqm4klLcPwcj4+CZ9eX9BrUt+baeigWJaSnSeiOGZkn9ojqLE3
        rmmhdZIKA4BPXQ5QF/ZDbXKM8c2aZx2w9ygNoX20RGt8nS45Jdj24gBn3WeOQLRpGV/61A
        dSGBNrKuTKFGT7IOkIP6+ifJRQ01w2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690212670;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6vCGqXuxAtySUa/Hmk/Z1BMteleIzoulc14jakz0RbQ=;
        b=TZcavybPm/y9P3A4V9Ho+iZVKjW/OcMHy/gJp6k++ZKO1bTe+UsHBxfGVYVjLCmNx/rAyF
        pyR8Xl4VRpT7b5CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BBB52138E8;
        Mon, 24 Jul 2023 15:31:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6RKwKj2ZvmREBAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 24 Jul 2023 15:31:09 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 8d3d91e2;
        Mon, 24 Jul 2023 15:31:09 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 8/8] fscrypt: make prepared keys record their type
In-Reply-To: <1e985d7666440b53cbda968fa45db78eb56baae3.1688927423.git.sweettea-kernel@dorminy.me>
        (Sweet Tea Dorminy's message of "Sun, 9 Jul 2023 14:53:08 -0400")
References: <cover.1688927423.git.sweettea-kernel@dorminy.me>
        <1e985d7666440b53cbda968fa45db78eb56baae3.1688927423.git.sweettea-kernel@dorminy.me>
Date:   Mon, 24 Jul 2023 16:31:08 +0100
Message-ID: <87o7k1xr5v.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:

> Right now fscrypt_infos have two fields dedicated solely to recording
> what type of prepared key the info has: whether it solely owns the
> prepared key, or has borrowed it from a master key, or from a direct
> key.
>
> The ci_direct_key field is only used for v1 direct key policies,
> recording the direct key that needs to have its refcount reduced when
> the crypt_info is freed. However, now that crypt_info->ci_enc_key is a
> pointer to the authoritative prepared key -- embedded in the direct key,
> in this case, we no longer need to keep a full pointer to the direct key
> -- we can use container_of() to go from the prepared key to its
> surrounding direct key.
>
> The key ownership information doesn't change during the lifetime of a
> prepared key.  Since at worst there's a prepared key per info, and at
> best many infos share a single prepared key, it can be slightly more
> efficient to store this ownership info in the prepared key instead of in
> the fscrypt_info, especially since we can squash both fields down into
> a single enum.
>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h | 31 +++++++++++++++++++++++--------
>  fs/crypto/keysetup.c        | 21 +++++++++++++--------
>  fs/crypto/keysetup_v1.c     |  7 +++++--
>  3 files changed, 41 insertions(+), 18 deletions(-)
>
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 5011737b60b3..e726a1fb9f7e 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -174,18 +174,39 @@ struct fscrypt_symlink_data {
>  	char encrypted_path[1];
>  } __packed;
>=20=20
> +/**
> + * enum fscrypt_prepared_key_type - records a prepared key's ownership
> + *
> + * @FSCRYPT_KEY_PER_INFO: this prepared key is allocated for a specific =
info
> + *		          and is never shared.
> + * @FSCRYPT_KEY_DIRECT_V1: this prepared key is embedded in a fscrypt_di=
rect_key
> + *		           used in v1 direct key policies.
> + * @FSCRYPT_KEY_MASTER_KEY: this prepared key is a per-mode and policy k=
ey,
> + *			    part of a fscrypt_master_key, shared between all
> + *			    users of this master key having this mode and
> + *			    policy.
> + */
> +enum fscrypt_prepared_key_type {
> +	FSCRYPT_KEY_PER_INFO =3D 1,
> +	FSCRYPT_KEY_DIRECT_V1,
> +	FSCRYPT_KEY_MASTER_KEY,
> +} __packed;
> +
>  /**
>   * struct fscrypt_prepared_key - a key prepared for actual encryption/de=
cryption
>   * @tfm: crypto API transform object
>   * @blk_key: key for blk-crypto
> + * @type: records the ownership type of the prepared key
>   *
> - * Normally only one of the fields will be non-NULL.
> + * Normally only one of @tfm and @blk_key will be non-NULL, although it =
is
> + * possible if @type is FSCRYPT_KEY_MASTER_KEY.
>   */
>  struct fscrypt_prepared_key {
>  	struct crypto_skcipher *tfm;
>  #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
>  	struct blk_crypto_key *blk_key;
>  #endif
> +	enum fscrypt_prepared_key_type type;
>  };
>=20=20
>  /*
> @@ -233,12 +254,6 @@ struct fscrypt_info {
>  	 */
>  	struct list_head ci_master_key_link;
>=20=20
> -	/*
> -	 * If non-NULL, then encryption is done using the master key directly
> -	 * and ci_enc_key will equal ci_direct_key->dk_key.
> -	 */
> -	struct fscrypt_direct_key *ci_direct_key;
> -
>  	/*
>  	 * This inode's hash key for filenames.  This is a 128-bit SipHash-2-4
>  	 * key.  This is only set for directories that use a keyed dirhash over
> @@ -641,7 +656,7 @@ static inline int fscrypt_require_key(struct inode *i=
node)
>=20=20
>  /* keysetup_v1.c */
>=20=20
> -void fscrypt_put_direct_key(struct fscrypt_direct_key *dk);
> +void fscrypt_put_direct_key(struct fscrypt_prepared_key *prep_key);
>=20=20
>  int fscrypt_setup_v1_file_key(struct fscrypt_info *ci,
>  			      const u8 *raw_master_key);
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index 4f04999ecfd1..a19650f954e2 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -191,11 +191,11 @@ void fscrypt_destroy_prepared_key(struct super_bloc=
k *sb,
>  /* Given a per-file encryption key, set up the file's crypto transform o=
bject */
>  int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_=
key)
>  {
> -	ci->ci_owns_key =3D true;
>  	ci->ci_enc_key =3D kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
>  	if (!ci->ci_enc_key)
>  		return -ENOMEM;
>=20=20
> +	ci->ci_enc_key->type =3D FSCRYPT_KEY_PER_INFO;
>  	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
>  }
>=20=20
> @@ -290,7 +290,8 @@ static int setup_new_mode_prepared_key(struct fscrypt=
_master_key *mk,
>  				  hkdf_context, hkdf_info, hkdf_infolen,
>  				  mode_key, mode->keysize);
>  	if (err)
> -		goto out_unlock;
> +		return err;

Is this change really intended?  I guess it's a mistake, because if we
simply return we'll leave keysetup mutex locked, which is probably not
what we want here.

Cheers,
--=20
Lu=C3=ADs

> +	prep_key->type =3D FSCRYPT_KEY_MASTER_KEY;
>  	err =3D fscrypt_prepare_key(prep_key, mode_key, ci);
>  	memzero_explicit(mode_key, mode->keysize);
>=20=20

