Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4235B2259
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 17:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiIHPdc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 11:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiIHPda (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 11:33:30 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53332120B0
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 08:33:29 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id x3so830643qkn.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 08:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=5xj/DQQndBFw5+cImee+2TOeEr0r4xJjiH6FYre2kAY=;
        b=fo+rC4C75zAhwjqVDzfGyONGqrN3KdSlBOOnMmICVWMletBmcSrnxw6DtN3NEcuSUq
         3YzcJDceN/V+ifA5jQpXPyoFGr5lGyEOyKbcv6qIL92tMAujSinCeXXpHzRtfsLJuFZV
         fDDs8pkKLzgzQydZ2Dpru/z9QLjodhV2GD6aV6fhkGjnecpy2gM1r33QPPYa52q/qu17
         3Ha9kHrYRaameGISr48YURQB2Q+scwTqJ9rLX1we8PkQ2GVMJVHjIB+VHne7N06ilGw+
         dbUVBpbjC1cWsDvs/vNI9UCrzPPTem/w0cMymAW6AsSXU/+4yMMC1JvB+9EqM5/SsCzG
         PG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5xj/DQQndBFw5+cImee+2TOeEr0r4xJjiH6FYre2kAY=;
        b=px0/YGXiTuLTtWtQrCpPtw+9D0NWgvj7FrTeTugAivBRYKQIKh35Jia0837V4yiV30
         0fn9QTqM1iGfaH7PIWTpMXCqdiYhw//f0h/OEJWtU6+Wz52+9p6YhdXlmYpySwGz1+9s
         p+wQ06ddY2cLD6ezk3Y4ToeUFkBtBkb/FHTg6ycFQ3CqnpYSoejsQwoOraDjA9IFgqBD
         rqUx8HbUq/TH2dWbyATUhkGi6ch1ltdOQQbYrAfOfLB4wGPKtHYf0iRQTVEuk2usOOZW
         Bpgbft4LTuSWSWkAMvR0MbJzeXm+se4QgRgVWogbnMziUpD7frh4HChySgWkJS4IA27H
         zuQA==
X-Gm-Message-State: ACgBeo1mpelEaktednJTUPJZNY4b/KTagHIORg2zMwZxNp7DZ+3hP8We
        k7bEJQAKCod9sFzBMo/m6PqplA==
X-Google-Smtp-Source: AA6agR59fC9cIRjTl3IpaaYjVZnBKB/XnZdjJ3dLaUM2VkdLMOJ1i7S3Hmqxf/vYuJRmnSVeATywCQ==
X-Received: by 2002:a05:620a:4014:b0:6ba:e955:a1db with SMTP id h20-20020a05620a401400b006bae955a1dbmr6805441qko.558.1662651208261;
        Thu, 08 Sep 2022 08:33:28 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id x9-20020a05620a448900b006b5e296452csm18486301qkp.54.2022.09.08.08.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:33:27 -0700 (PDT)
Date:   Thu, 8 Sep 2022 11:33:26 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 05/20] fscrypt: add extent-based encryption
Message-ID: <YxoLRh0b4Qf8BtUh@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <48d09d4905d0c6e5e72d37535eb852487f1bd9cb.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d09d4905d0c6e5e72d37535eb852487f1bd9cb.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:20PM -0400, Sweet Tea Dorminy wrote:
> Some filesystems need to encrypt data based on extents, rather than on
> inodes, due to features incompatible with inode-based encryption. For
> instance, btrfs can have multiple inodes referencing a single block of
> data, and moves logical data blocks to different physical locations on
> disk in the background; these two features mean inode or
> physical-location-based policies will not work for btrfs.
> 
> This change introduces fscrypt_extent_context objects, in analogy to
> existing context objects based on inodes. For a filesystem which uses
> extents, a new hook provides a new fscrypt_extent_context. During file
> content encryption/decryption, the existing fscrypt_context object
> provides key information, while the new fscrypt_extent_context provides
> IV information. For filename encryption, the existing IV generation
> methods are still used, since filenames are not stored in extents.
> 
> As individually keyed inodes prevent sharing of extents, such policies
> are forbidden for filesystems with extent-based encryption.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/crypto.c          | 15 +++++++-
>  fs/crypto/fscrypt_private.h | 26 ++++++++++++-
>  fs/crypto/inline_crypt.c    | 29 +++++++++++---
>  fs/crypto/policy.c          | 77 +++++++++++++++++++++++++++++++++++++
>  include/linux/fscrypt.h     | 41 ++++++++++++++++++++
>  5 files changed, 178 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 7fe5979fbea2..77537736096b 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -81,8 +81,19 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
>  			 const struct fscrypt_info *ci)
>  {
>  	u8 flags = fscrypt_policy_flags(&ci->ci_policy);
> +	struct inode *inode = ci->ci_inode;
> +	const struct fscrypt_operations *s_cop = inode->i_sb->s_cop;
>  
>  	memset(iv, 0, ci->ci_mode->ivsize);
> +	if (s_cop->get_extent_context && lblk_num != U64_MAX) {
> +		size_t extent_offset;
> +		union fscrypt_extent_context ctx;
> +		int ret = fscrypt_get_extent_context(inode, lblk_num, &ctx, &extent_offset, NULL);

Newline between declarations and code, and since you use the warnon i'd do

int ret;

ret = fscrypt_get_extent_context();
WARN_ON_ONCE(ret);

> +		WARN_ON_ONCE(ret != 0);
> +		memcpy(iv->raw, ctx.v1.iv, ci->ci_mode->ivsize);
> +		iv->lblk_num = iv->lblk_num + cpu_to_le64(extent_offset);
> +		return;
> +	}
>  
>  	/*
>  	 * Filename encryption. For inode-based policies, filenames are
> @@ -93,8 +104,8 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
>  
>  	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
>  		WARN_ON_ONCE(lblk_num > U32_MAX);
> -		WARN_ON_ONCE(ci->ci_inode->i_ino > U32_MAX);
> -		lblk_num |= (u64)ci->ci_inode->i_ino << 32;
> +		WARN_ON_ONCE(inode->i_ino > U32_MAX);
> +		lblk_num |= (u64)inode->i_ino << 32;
>  	} else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
>  		WARN_ON_ONCE(lblk_num > U32_MAX);
>  		lblk_num = (u32)(ci->ci_hashed_ino + lblk_num);
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 3afdaa084773..2092ef63c80a 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -165,6 +165,27 @@ fscrypt_policy_flags(const union fscrypt_policy *policy)
>  	BUG();
>  }
>  
> +#define FSCRYPT_MAX_IV_SIZE	32
> +
> +/*
> + * fscrypt_extent_context - the encryption context for an extent
> + * 

Whitespace.

> + * For filesystems that support extent encryption, this context provides the
> + * necessary randomly-initialized IV in order to encrypt/decrypt the data
> + * stored in the extent. It is stored alongside each extent, and is
> + * insufficient to decrypt the extent: the extent's owning inode(s) provide the
> + * policy information (including key identifier) necessary to decrypt.
> + */
> +struct fscrypt_extent_context_v1 {
> +	u8 version;
> +	u8 iv[FSCRYPT_MAX_IV_SIZE];
> +};
> +
> +union fscrypt_extent_context {
> +	u8 version;
> +	struct fscrypt_extent_context_v1 v1;
> +};
> +
>  /*
>   * For encrypted symlinks, the ciphertext length is stored at the beginning
>   * of the string in little-endian format.
> @@ -279,8 +300,6 @@ fscrypt_msg(const struct inode *inode, const char *level, const char *fmt, ...);
>  #define fscrypt_err(inode, fmt, ...)		\
>  	fscrypt_msg((inode), KERN_ERR, fmt, ##__VA_ARGS__)
>  
> -#define FSCRYPT_MAX_IV_SIZE	32
> -
>  union fscrypt_iv {
>  	struct {
>  		/* logical block number within the file */
> @@ -628,5 +647,8 @@ int fscrypt_policy_from_context(union fscrypt_policy *policy_u,
>  				const union fscrypt_context *ctx_u,
>  				int ctx_size);
>  const union fscrypt_policy *fscrypt_policy_to_inherit(struct inode *dir);
> +int fscrypt_get_extent_context(const struct inode *inode, u64 lblk_num,
> +			       union fscrypt_extent_context *ctx,
> +			       size_t *extent_offset, size_t *extent_length);
>  
>  #endif /* _FSCRYPT_PRIVATE_H */
> diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
> index 90f3e68f166e..0537f710047e 100644
> --- a/fs/crypto/inline_crypt.c
> +++ b/fs/crypto/inline_crypt.c
> @@ -1,3 +1,4 @@
> +

Whitespace.  Thanks,

Josef
