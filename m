Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161E0756666
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjGQOcB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 10:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjGQObz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 10:31:55 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3580E52
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 07:31:39 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-7659db6339eso193061385a.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 07:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689604298; x=1692196298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dGWMUDxSQOjpHSgIRh8kQLLol2Vu+O8ZewckuFC3Jfs=;
        b=R4BWQIZQs66wIIH0o2cGXlx3r4TiXwMoUj8H9peotVvJiNDcvptFP7eEt6O3oL2F3R
         Wx9yQ/l2eHR2Gj67wrGN/9ZhepzXR/U54PBJyajHddNSxmPhoWJF74XRoebhikBJsmp5
         G3yWXHfz2wigxBmRJMPUl0G5IxV34it/OFtjJTTTO0DkhCsFLXE6n6aPPLUceSCDIjrW
         3xO9xO9fyfxzbzvdLG+Pf2aVluYGdyPkq08iYkUgkG/gMfEG+ezg/J6UmjxuHUD92Woa
         WGzpnxBvs80GhT5/c0OroSHKc/Wp74njeFMSco9bFmJwur4G3sZC+uBRYM2uHwHYZRkt
         aBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689604298; x=1692196298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGWMUDxSQOjpHSgIRh8kQLLol2Vu+O8ZewckuFC3Jfs=;
        b=ReaXBj1l0RAyPW58foPVvVHcZMv/gK6FXcwYkjlzIP8dafsm++SX3DvDpN3R7GDj+w
         W4or8L5fL7ozJZIDCIDQxVTAITICNIsoviiqHuk/2CBZGEmtvHZ+wAchGcpAk5DzTG7C
         sELgythb+vgS3d2c4kJYfD9W2CH5C3ziEk2OGaGvm1E/+iCEb0Y5SNwk1fOFxtiS2FWq
         gtnNj76KAhdgb6xIIzD9SkQpQ6BFIx1GyEMfTCiXWXTO9tFQGBMwtZ7boJk16Csuo/T1
         qZKWuh5VWonmb8KhDcgs1Toz8RjhcGYA4aXQLSz3HMcxnP9zuAN2BWrQC3KIfTjzm2z1
         6c5Q==
X-Gm-Message-State: ABy/qLaWJJnKFbWpF+ZbDNXrU7G1nLcXmR58Fpdykh8fBlPqcG18tF/r
        tGdyqN7i5vKvfho/Yo9Un3gehhiTW+TWDKFssRdn0g==
X-Google-Smtp-Source: APBJJlGj3mK26kZuYA8XDlflMI5fvQ1xO2FYadwQtcENLoWSZke+Dc/P425Ou4RtNbH6GU92oRf0Jw==
X-Received: by 2002:a05:620a:1724:b0:767:f176:cf4a with SMTP id az36-20020a05620a172400b00767f176cf4amr12378172qkb.5.1689604298528;
        Mon, 17 Jul 2023 07:31:38 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id f22-20020ae9ea16000000b00767177a5bebsm6085108qkg.56.2023.07.17.07.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 07:31:38 -0700 (PDT)
Date:   Mon, 17 Jul 2023 10:31:37 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 13/14] fscrypt: save session key credentials for
 extent infos
Message-ID: <20230717143137.GB691303@perftesting>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
 <7ad2677a3c27039167e95bfe67c75336b540fd17.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ad2677a3c27039167e95bfe67c75336b540fd17.1688927487.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 09, 2023 at 02:53:46PM -0400, Sweet Tea Dorminy wrote:
> For v1 encryption policies using per-session keys, the thread which
> opens the inode and therefore initializes the encryption info is part of
> the session, so it can get the key from the session keyring. However,
> for extent encryption, the extent infos are likely loaded from a
> different thread, which does not have access to the session keyring.
> This change saves the credentials of the inode opening thread and reuses
> those credentials temporarily when dealing with extent infos, allowing
> finding the encryption key correctly.
> 
> v1 encryption policies using per-session keys should probably not exist
> for new usages such as extent encryption, but this makes more tests
> work without change; maybe the right answer is to disallow v1 session
> keys plus extent encryption and deal with editing tests to not use v1
> session encryption so much.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h |  8 ++++++++
>  fs/crypto/keysetup.c        | 14 ++++++++++++++
>  fs/crypto/keysetup_v1.c     |  1 +
>  3 files changed, 23 insertions(+)
> 
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 6e6020f7746c..a1c484511ba3 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -231,6 +231,14 @@ struct fscrypt_info {
>  	 */
>  	bool ci_inlinecrypt;
>  #endif
> +	/* Credential struct from the thread which created this info. This is
> +	 * only used in v1 session keyrings with extent encryption; it allows
> +	 * the thread creating extents for an inode to join the session
> +	 * keyring temporarily, since otherwise the thread is usually part of
> +	 * kernel writeback and therefore unrelated to the thread with the
> +	 * right session key.
> +	 */
> +	struct cred *ci_session_creds;
>  
>  	/*
>  	 * Encryption mode used for this inode.  It corresponds to either the
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index 3b80e7061039..9c56ef8d2eb6 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -646,6 +646,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
>  
>  		fscrypt_put_master_key_activeref(ci->ci_sb, mk);
>  	}
> +	if (ci->ci_session_creds)
> +		abort_creds(ci->ci_session_creds);
>  	memzero_explicit(ci, sizeof(*ci));
>  	kmem_cache_free(fscrypt_info_cachep, ci);
>  }
> @@ -662,6 +664,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
>  	struct fscrypt_master_key *mk = NULL;
>  	int res;
>  	bool info_for_extent = !!info_ptr;
> +	const struct cred *creds = NULL;
>  
>  	if (!info_ptr)
>  		info_ptr = &inode->i_crypt_info;
> @@ -705,7 +708,18 @@ fscrypt_setup_encryption_info(struct inode *inode,
>  	if (res)
>  		goto out;
>  
> +	if (info_for_extent && inode->i_crypt_info->ci_session_creds) {
> +		 creds = override_creds(inode->i_crypt_info->ci_session_creds);

Whitespace.  Thanks,

Josef
