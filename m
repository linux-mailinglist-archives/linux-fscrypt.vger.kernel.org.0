Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D798152335D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 May 2022 14:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242730AbiEKMua (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 May 2022 08:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbiEKMu3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 May 2022 08:50:29 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6A15EBE7;
        Wed, 11 May 2022 05:50:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x88so2156683pjj.1;
        Wed, 11 May 2022 05:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+viyLqjrUdtjOibi08MOw0j4Eq0aWUQozPemEDDC3QU=;
        b=lL9dLvBjj7LiM1PLF7+ChiPTLOQzhWf1wmKbcqqI24qrOfsY9/Je7d9WiU4L+tEu+r
         jPQcOlQqVX/SS2WAfD7ghSJ+J8edxf0C7UxbPDMQslfKcQye/lXTPNNi3BaP72Eu8qdl
         gIWbXqlS3WMSDVr6IPxS3JDR0tb3ZfTYlThGOpZtXOGJ1ThRaGVutya/0Tci04flRr3I
         xPPD0yBrDJ7WEk38IUBuGUh5IzYWI/vihFNikyjS5kivJfjTuRh4KsxeJeaaPbMV9nDh
         iqYkAxNODjweFov4shSAh4aKhbbRWDnqU/SXAp6SSHN85OMBoWnA7Ni8AJAFuYrLQ5aF
         3Ehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+viyLqjrUdtjOibi08MOw0j4Eq0aWUQozPemEDDC3QU=;
        b=4stibwnAgHN27+QMWxm4xqB/U9wGKNYekhHi4ND2oYwARUJw7CehLWV+XiPmz9h+u9
         Y/l/U/kMpWmOziNyj29fV5RrDoiN5Z+B7UN+SyBEk4dSjrOldMMZjK8fYjdJGuIbg2Ba
         kPKqcqau44Oq4HPdFmcOysmBmiASI8ZUc8Vwf6fGCfp+1/CDhVyvXGfRRGzbz1YDv79b
         FSE38OWmGQFc4+0C3xy2Ta5LLd5JbwIuaYg3vNymcPvwAz6oN6Jc/+KX5hRcLcBT5fLp
         pqKf77ThqsO8hF4boZmnOsiITXir58T9KxuUR+JEwUFe0eZyD6nguUNck4Rkyr4VidCv
         u4kg==
X-Gm-Message-State: AOAM533TNPq7n3Tw1FMitRmM7R5lZ7ox8P3wJs9rdXj4SyO+oaWz/Nb+
        CB0nW8w9YfRxZhzTM+tYc7U=
X-Google-Smtp-Source: ABdhPJx7yP2M50cFkRqGLDJe9numrZNfsCFjSZWPTWZ80iF63V521EQf8g/ynHHyzcHfXyKnuoc3Fg==
X-Received: by 2002:a17:902:ccc4:b0:156:5d37:b42f with SMTP id z4-20020a170902ccc400b001565d37b42fmr25008502ple.157.1652273428265;
        Wed, 11 May 2022 05:50:28 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:2759:da01:e9ea:1584])
        by smtp.gmail.com with ESMTPSA id 9-20020a170902c20900b0015f36687452sm1514743pll.296.2022.05.11.05.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 05:50:27 -0700 (PDT)
Date:   Wed, 11 May 2022 18:20:23 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 1/7] ext4: only allow test_dummy_encryption when
 supported
Message-ID: <20220511125023.gxfkgft35gkjyhef@riteshh-domain>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <20220501050857.538984-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501050857.538984-2-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/04/30 10:08PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Make the test_dummy_encryption mount option require that the encrypt
> feature flag be already enabled on the filesystem, rather than
> automatically enabling it.  Practically, this means that "-O encrypt"
> will need to be included in MKFS_OPTIONS when running xfstests with the
> test_dummy_encryption mount option.  (ext4/053 also needs an update.)
>
> Moreover, as long as the preconditions for test_dummy_encryption are
> being tightened anyway, take the opportunity to start rejecting it when
> !CONFIG_FS_ENCRYPTION rather than ignoring it.
>
> The motivation for requiring the encrypt feature flag is that:
>
> - Having the filesystem auto-enable feature flags is problematic, as it
>   bypasses the usual sanity checks.  The specific issue which came up
>   recently is that in kernel versions where ext4 supports casefold but
>   not encrypt+casefold (v5.1 through v5.10), the kernel will happily add
>   the encrypt flag to a filesystem that has the casefold flag, making it
>   unmountable -- but only for subsequent mounts, not the initial one.
>   This confused the casefold support detection in xfstests, causing
>   generic/556 to fail rather than be skipped.
>
> - The xfstests-bld test runners (kvm-xfstests et al.) already use the
>   required mkfs flag, so they will not be affected by this change.  Only
>   users of test_dummy_encryption alone will be affected.  But, this
>   option has always been for testing only, so it should be fine to
>   require that the few users of this option update their test scripts.
>
> - f2fs already requires it (for its equivalent feature flag).
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

So we are changing user behavior with this patch, but since it is only for
test_dummy_encryption mount option which is used for testing and given it is
nicely documented here, the patch looks good to me with a small nit.


> ---
>  fs/ext4/super.c | 59 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 22 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 1466fbdbc8e34..64ce17714e193 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2427,11 +2427,12 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
>  		ctx->spec |= EXT4_SPEC_DUMMY_ENCRYPTION;
>  		ctx->test_dummy_enc_arg = kmemdup_nul(param->string, param->size,
>  						      GFP_KERNEL);
> +		return 0;
>  #else
>  		ext4_msg(NULL, KERN_WARNING,
> -			 "Test dummy encryption mount option ignored");
> +			 "test_dummy_encryption option not supported");
> +		return -EINVAL;
>  #endif
> -		return 0;
>  	case Opt_dax:
>  	case Opt_dax_type:
>  #ifdef CONFIG_FS_DAX
> @@ -2786,12 +2787,43 @@ static int ext4_check_quota_consistency(struct fs_context *fc,
>  #endif
>  }
>
> +static int ext4_check_test_dummy_encryption(const struct fs_context *fc,
> +					    struct super_block *sb)

Maybe the function name should match with other option checking, like
ext4_check_test_dummy_encryption_consistency() similar to
ext4_check_quota_consistency(). This makes it clear that both are residents of
ext4_check_opt_consistency()

One can argue it makes the function name quite long. So I don't have hard
objections anyways.

So either ways, feel free to add -

Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>



> +{
> +	const struct ext4_fs_context *ctx = fc->fs_private;
> +	const struct ext4_sb_info *sbi = EXT4_SB(sb);
> +
> +	if (!IS_ENABLED(CONFIG_FS_ENCRYPTION) ||
> +	    !(ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION))
> +		return 0;
> +
> +	if (!ext4_has_feature_encrypt(sb)) {
> +		ext4_msg(NULL, KERN_WARNING,
> +			 "test_dummy_encryption requires encrypt feature");
> +		return -EINVAL;
> +	}
> +	/*
> +	 * This mount option is just for testing, and it's not worthwhile to
> +	 * implement the extra complexity (e.g. RCU protection) that would be
> +	 * needed to allow it to be set or changed during remount.  We do allow
> +	 * it to be specified during remount, but only if there is no change.
> +	 */
> +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE &&
> +	    !DUMMY_ENCRYPTION_ENABLED(sbi)) {
> +		ext4_msg(NULL, KERN_WARNING,
> +			 "Can't set test_dummy_encryption on remount");
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static int ext4_check_opt_consistency(struct fs_context *fc,
>  				      struct super_block *sb)
>  {
>  	struct ext4_fs_context *ctx = fc->fs_private;
>  	struct ext4_sb_info *sbi = fc->s_fs_info;
>  	int is_remount = fc->purpose == FS_CONTEXT_FOR_RECONFIGURE;
> +	int err;
>
>  	if ((ctx->opt_flags & MOPT_NO_EXT2) && IS_EXT2_SB(sb)) {
>  		ext4_msg(NULL, KERN_ERR,
> @@ -2821,20 +2853,9 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
>  				 "for blocksize < PAGE_SIZE");
>  	}
>
> -#ifdef CONFIG_FS_ENCRYPTION
> -	/*
> -	 * This mount option is just for testing, and it's not worthwhile to
> -	 * implement the extra complexity (e.g. RCU protection) that would be
> -	 * needed to allow it to be set or changed during remount.  We do allow
> -	 * it to be specified during remount, but only if there is no change.
> -	 */
> -	if ((ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION) &&
> -	    is_remount && !sbi->s_dummy_enc_policy.policy) {
> -		ext4_msg(NULL, KERN_WARNING,
> -			 "Can't set test_dummy_encryption on remount");
> -		return -1;

Nice, we also got rid of -1 return value in this patch which is returned to user.
I think this should have been -EINVAL from the very beginning.


-ritesh

> -	}
> -#endif
> +	err = ext4_check_test_dummy_encryption(fc, sb);
> +	if (err)
> +		return err;
>
>  	if ((ctx->spec & EXT4_SPEC_DATAJ) && is_remount) {
>  		if (!sbi->s_journal) {
> @@ -5279,12 +5300,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  		goto failed_mount_wq;
>  	}
>
> -	if (DUMMY_ENCRYPTION_ENABLED(sbi) && !sb_rdonly(sb) &&
> -	    !ext4_has_feature_encrypt(sb)) {
> -		ext4_set_feature_encrypt(sb);
> -		ext4_commit_super(sb);
> -	}
> -
>  	/*
>  	 * Get the # of file system overhead blocks from the
>  	 * superblock if present.
> --
> 2.36.0
>
