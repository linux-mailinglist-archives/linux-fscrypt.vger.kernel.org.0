Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78872754265
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jul 2023 20:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbjGNSOW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 14:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbjGNSOV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 14:14:21 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01CC35AB
        for <linux-fscrypt@vger.kernel.org>; Fri, 14 Jul 2023 11:14:00 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-563439ea4a2so1479563eaf.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 14 Jul 2023 11:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689358440; x=1691950440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Hdu2InbnZf8zZ43qw4QAyACx5oSj6HL3+2N5nCu1wA=;
        b=k3G2PzEy0/TjadwEMX4AISCCZcZQ26hJGHqqTdhWP7o17GXWX60iEiAq99DYuBR14C
         qLpTkN2xqp3MrUrtxBdPHfe3vCs2IbX/vLi+5FdDHAAsIAhteZZ1oZVi2EMQZnctgBUB
         gjZdsAP6OD2zBJgFCTNH+nf2ecimoImwHDLOA+dD9bXppkiaDP2lSmcIrAEm8iSwciIz
         YWVTIhPXFDAZYsDrjRLk+bjsO/S2jhQ2+vHBnjw0O3wb26TNjf9b5LR+OErGbh3TEdaM
         c/+ZedXbRL+zAyosKgGJXRPTsPXIBAOHTase1AGfi+w4xJ7dzpPk1+fuVVvO+7IPW76M
         F+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689358440; x=1691950440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Hdu2InbnZf8zZ43qw4QAyACx5oSj6HL3+2N5nCu1wA=;
        b=HvrnBRNGQEUP6yibDF9Dr9Tz681wpEIbfWxvcJzRWLlH4QACQwGRuPtDxSczmMfJ6S
         ZffieJUC5MOMWmlCBBYpBCl/qkkjWGTFHguDzm5J/+bKnlB7NFOCiDooD2MxqFp4nvl+
         6jgDuCTkkPs4w71gvuhyoAzDHXfgaHl0dOusRIyqruQdfAeQuJRW3O6QDJxVZh2m17O1
         dlFJ6mzL0C4ProaTWqPu46KPpD2JBOGT1gNMV3VYo9X9WFldYMPFgg4bNP36aYgobnT0
         w9K1vmVBCykJt+xG3jUnCevLCxn4616pgP+mTb7bo3qY+vi0v1clmE+W2RJWH1bU6HQC
         KNug==
X-Gm-Message-State: ABy/qLbSVmiuy/T8azU5w5h2iydysfYsxXEGv7aZfL1j6vuWGuysdwqW
        cG18FiSurXUioYaYEQKqdFU/nA==
X-Google-Smtp-Source: APBJJlEA7P5OZ5d0XThiykbhJWzpmPzDC6Os0oNNzxwe6eb3uYbg+psf3TwtC4jP41q+VPqGnKu/Tg==
X-Received: by 2002:a05:6358:9327:b0:134:e3e6:c0bd with SMTP id x39-20020a056358932700b00134e3e6c0bdmr6399483rwa.32.1689358439806;
        Fri, 14 Jul 2023 11:13:59 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id k63-20020a0dfa42000000b005773babc3cdsm2434024ywf.83.2023.07.14.11.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 11:13:59 -0700 (PDT)
Date:   Fri, 14 Jul 2023 14:13:58 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 03/14] fscrypt: adjust effective lblks based on extents
Message-ID: <20230714181358.GA510453@perftesting>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
 <d198508a448c08103691a1649b49edfa0d4eb98e.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d198508a448c08103691a1649b49edfa0d4eb98e.1688927487.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 09, 2023 at 02:53:36PM -0400, Sweet Tea Dorminy wrote:
> If a filesystem uses extent-based encryption, then the offset within a
> file is not a constant which can be used for calculating an IV.
> For instance, the same extent could be blocks 0-8 in one file, and
> blocks 100-108 in another file. Instead, the block offset within the
> extent must be used instead.
> 
> Update all uses of logical block offset within the file to use logical
> block offset within the extent, if applicable.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/crypto.c       |  3 ++-
>  fs/crypto/inline_crypt.c | 24 +++++++++++++++++-------
>  2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 1b7e375b1c6b..d75f1b3f5795 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -107,8 +107,9 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
>  	struct skcipher_request *req = NULL;
>  	DECLARE_CRYPTO_WAIT(wait);
>  	struct scatterlist dst, src;
> +	u64 ci_offset = 0;
>  	struct fscrypt_info *ci =
> -		fscrypt_get_lblk_info(inode, lblk_num, NULL, NULL);
> +		fscrypt_get_lblk_info(inode, lblk_num, &ci_offset, NULL);
>  	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
>  	int res = 0;
>  
> diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
> index 885a2ec3d711..b3e7a5291d22 100644
> --- a/fs/crypto/inline_crypt.c
> +++ b/fs/crypto/inline_crypt.c
> @@ -267,12 +267,15 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
>  {
>  	const struct fscrypt_info *ci;
>  	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
> +	u64 ci_offset = 0;
>  
>  	if (!fscrypt_inode_uses_inline_crypto(inode))
>  		return;
> -	ci = fscrypt_get_lblk_info(inode, first_lblk, NULL, NULL);
> +	ci = fscrypt_get_lblk_info(inode, first_lblk, &ci_offset, NULL);
> +	if (!ci)
> +		return;
>  
> -	fscrypt_generate_dun(ci, first_lblk, dun);
> +	fscrypt_generate_dun(ci, ci_offset, dun);
>  	bio_crypt_set_ctx(bio, ci->ci_enc_key->blk_key, dun, gfp_mask);
>  }
>  EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
> @@ -350,22 +353,23 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
>  	const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
>  	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
>  	struct fscrypt_info *ci;
> +	u64 ci_offset = 0;
>  
>  	if (!!bc != fscrypt_inode_uses_inline_crypto(inode))
>  		return false;
>  	if (!bc)
>  		return true;
>  
> -	ci = fscrypt_get_lblk_info(inode, next_lblk, NULL, NULL);
> +	ci = fscrypt_get_lblk_info(inode, next_lblk, &ci_offset, NULL);
>  	/*
>  	 * Comparing the key pointers is good enough, as all I/O for each key
>  	 * uses the same pointer.  I.e., there's currently no need to support
>  	 * merging requests where the keys are the same but the pointers differ.
>  	 */
> -	if (bc->bc_key != ci->ci_enc_key->blk_key)
> +	if (!ci || bc->bc_key != ci->ci_enc_key->blk_key)
>  		return false;
>  

This seems like an unrelated change, we weren't checking !ci before and the
behavior hasn't changed with the new code.  Thanks,

Josef
